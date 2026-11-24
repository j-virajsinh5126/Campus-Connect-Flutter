import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/event_model.dart';
import '../services/local_storage_service.dart';
import '../services/mock_event_services.dart';
import '../services/firestore_service.dart';

class EventProvider extends ChangeNotifier {
  final MockEventService _service;
  final LocalStorageService _storage;
  final FirestoreService _firestore;

  EventProvider({
    MockEventService? service,
    LocalStorageService? storage,
    FirestoreService? firestore,
  }) : _service = service ?? MockEventService(),
       _storage = storage ?? LocalStorageService(),
       _firestore = firestore ?? FirestoreService();

  List<EventModel> _events = [];
  final Map<String, EventModel> _pendingCreates = {};
  final Set<String> _firestoreEventIds = {};
  Set<String> _rsvpedIds = {};
  StreamSubscription<List<EventModel>>? _firestoreSubscription;
  bool _isLoading = false;
  String? _error;
  String? _syncMessage;
  String _selectedCategory = 'All';

  List<EventModel> get events => List.unmodifiable(_events);
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get syncMessage => _syncMessage;
  String get selectedCategory => _selectedCategory;
  List<EventModel> get myEvents =>
      _events.where((event) => _rsvpedIds.contains(event.id)).toList();

  List<EventModel> get filteredEvents {
    if (_selectedCategory == 'All') return events;
    return _events.where((e) => e.category == _selectedCategory).toList();
  }

  Future<void> loadEvents() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _rsvpedIds = await _storage.loadRsvps();
      final mockEvents = await _service.fetchEvents();
      if (_events.isEmpty) _events = mockEvents;
      _mergeRsvpState();
      _startFirestoreSync();
    } catch (e) {
      _error = 'Unable to load sample events: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _startFirestoreSync() {
    if (_firestoreSubscription != null) return;
    _firestoreSubscription = _firestore.watchEvents().listen(
      (remoteEvents) {
        final remoteIds = remoteEvents.map((e) => e.id).toSet();
        _firestoreEventIds
          ..clear()
          ..addAll(remoteIds);
        final localOnly = _events.where(
          (e) =>
              !remoteIds.contains(e.id) && !_pendingCreates.containsKey(e.id),
        );
        _events = [..._pendingCreates.values, ...remoteEvents, ...localOnly];
        _mergeRsvpState();
        _syncMessage = null;
        notifyListeners();
      },
      onError: (Object error) {
        _syncMessage =
            'Cloud sync unavailable. Local/sample events remain visible.';
        notifyListeners();
      },
    );
  }

  void _mergeRsvpState() {
    _events = _events.map((event) {
      final attendees = [...event.attendees]..remove('current_student');
      if (_rsvpedIds.contains(event.id)) attendees.add('current_student');
      return event.copyWith(attendees: attendees);
    }).toList();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<bool> addEvent(EventModel event) async {
    // Optimistic UI: display immediately before waiting for Firestore.
    _pendingCreates[event.id] = event;
    _events = [event, ..._events];
    _syncMessage = 'Saving event…';
    notifyListeners();

    try {
      await _firestore.createEvent(event);
      _pendingCreates.remove(event.id);
      _firestoreEventIds.add(event.id);
      _syncMessage = 'Event synced with the campus community.';
      notifyListeners();
      return true;
    } catch (e) {
      // Firestore queues writes while offline. A hard failure is rolled back.
      _pendingCreates.remove(event.id);
      _events.removeWhere((item) => item.id == event.id);
      _syncMessage = 'Could not save event: $e';
      notifyListeners();
      return false;
    }
  }

  void updateEvent(EventModel updated) {
    final index = _events.indexWhere((e) => e.id == updated.id);
    if (index == -1) return;
    _events[index] = updated;
    notifyListeners();
  }

  Future<void> toggleRsvp(String eventId, String userId) async {
    final index = _events.indexWhere((e) => e.id == eventId);
    if (index == -1) return;
    final previous = _events[index];
    final going = !previous.attendees.contains(userId);
    final attendees = [...previous.attendees];
    if (going) {
      attendees.add(userId);
      _rsvpedIds.add(eventId);
    } else {
      attendees.remove(userId);
      _rsvpedIds.remove(eventId);
    }
    _events[index] = previous.copyWith(attendees: attendees);
    notifyListeners();

    try {
      await _storage.saveRsvps(_rsvpedIds);
      if (eventId.startsWith('cc_') || _firestoreEventIds.contains(eventId)) {
        await _firestore.setRsvp(
          eventId: eventId,
          userId: userId,
          going: going,
        );
      }
    } catch (e) {
      // Roll back the optimistic RSVP if the server rejects the operation.
      _events[index] = previous;
      if (going) {
        _rsvpedIds.remove(eventId);
      } else {
        _rsvpedIds.add(eventId);
      }
      await _storage.saveRsvps(_rsvpedIds);
      _syncMessage = 'RSVP could not sync. Your previous status was restored.';
      notifyListeners();
    }
  }

  Future<void> clearLocalRsvpData() async {
    _rsvpedIds.clear();
    _events = _events.map((event) {
      final attendees = [...event.attendees]..remove('current_student');
      return event.copyWith(attendees: attendees);
    }).toList();
    await _storage.saveRsvps(_rsvpedIds);
    notifyListeners();
  }

  @override
  void dispose() {
    _firestoreSubscription?.cancel();
    super.dispose();
  }
}
