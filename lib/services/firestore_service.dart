import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/event_model.dart';

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _events =>
      _firestore.collection('events');

  Stream<List<EventModel>> watchEvents() {
    return _events
        .orderBy('createdAt', descending: true)
        .snapshots(includeMetadataChanges: true)
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => _eventFromDocument(doc.id, doc.data()))
              .toList(),
        );
  }

  // Compatibility method used by the existing FirestoreEventsScreen.
  Stream<List<Map<String, dynamic>>> getEventsStream() {
    return watchEvents().map(
      (events) => events.map((event) => event.toMap()).toList(),
    );
  }

  Future<void> createEvent(EventModel event) async {
    await _events.doc(event.id).set({
      'title': event.title,
      'description': event.description,
      'category': event.category,
      'location': event.location,
      'date': Timestamp.fromDate(event.date),
      'imageUrl': event.imageUrl,
      'organizer': event.organizer,
      'attendees': event.attendees,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'schemaVersion': 1,
    });
  }

  Future<void> setRsvp({
    required String eventId,
    required String userId,
    required bool going,
  }) async {
    final ref = _events.doc(eventId);
    // Array transforms are atomic and avoid overwriting other users' RSVPs.
    await ref.update({
      'attendees': going
          ? FieldValue.arrayUnion([userId])
          : FieldValue.arrayRemove([userId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteEvent(String eventId) => _events.doc(eventId).delete();

  EventModel _eventFromDocument(String id, Map<String, dynamic> data) {
    final rawDate = data['date'];
    final rawCreatedAt = data['createdAt'];
    DateTime parseDate(dynamic value, DateTime fallback) {
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      if (value is String) return DateTime.tryParse(value) ?? fallback;
      return fallback;
    }

    return EventModel(
      id: id,
      title: data['title']?.toString() ?? 'Untitled event',
      description: data['description']?.toString() ?? '',
      category: data['category']?.toString() ?? 'Other',
      location: data['location']?.toString() ?? 'Location not specified',
      date: parseDate(rawDate, DateTime.now()),
      imageUrl: data['imageUrl']?.toString(),
      organizer: data['organizer']?.toString() ?? 'CampusConnect',
      attendees: List<String>.from(data['attendees'] ?? const []),
      createdAt: parseDate(rawCreatedAt, DateTime.now()),
    );
  }
}
