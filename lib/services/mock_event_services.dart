import '../models/event_model.dart';
import '../utils/app_constants.dart';

class MockEventService {
  Future<List<EventModel>> fetchEvents() async {
    // Simulate network latency.
    await Future.delayed(AppConstants.simulatedNetworkDelay);

    final now = DateTime.now();

    return [
      EventModel(
        id: 'event_001',
        title: 'Flutter Development Workshop',
        description:
            'Learn Flutter fundamentals and build your first '
            'cross-platform application.',
        category: 'Technology',
        location: 'Computer Lab 1',
        date: now.add(const Duration(days: 2)),
        imageUrl: null,
        organizer: 'CP Club',
        attendees: ['student_01', 'student_02'],
        createdAt: now,
      ),
      EventModel(
        id: 'event_002',
        title: 'Annual Cultural Festival',
        description:
            'Celebrate music, dance, art and creativity '
            'with the entire campus.',
        category: 'Cultural',
        location: 'University Auditorium',
        date: now.add(const Duration(days: 5)),
        imageUrl: null,
        organizer: 'Cultural Committee',
        attendees: ['student_03'],
        createdAt: now,
      ),
      EventModel(
        id: 'event_003',
        title: 'Inter-Department Cricket',
        description:
            'Join the annual cricket tournament '
            'and represent your department.',
        category: 'Sports',
        location: 'University Sports Ground',
        date: now.add(const Duration(days: 7)),
        imageUrl: null,
        organizer: 'Sports Committee',
        attendees: [],
        createdAt: now,
      ),
    ];
  }

  Future<EventModel?> fetchEventById(String id) async {
    await Future.delayed(AppConstants.simulatedNetworkDelay);

    final events = await fetchEvents();

    try {
      return events.firstWhere((event) => event.id == id);
    } catch (_) {
      return null;
    }
  }
}
