import 'package:flutter_test/flutter_test.dart';
import 'package:campus/models/event_model.dart';
import 'package:campus/models/note_model.dart';

void main() {
  group('CampusConnect model tests', () {
    test('EventModel serializes and deserializes', () {
      final event = EventModel(
        id: 'e1',
        title: 'Flutter Workshop',
        description: 'Learn Flutter',
        category: 'Technology',
        location: 'Lab 1',
        date: DateTime(2026, 12, 1),
        organizer: 'CP Club',
        attendees: const ['u1'],
        createdAt: DateTime(2026, 11, 23),
      );

      expect(EventModel.fromMap(event.toMap()), event);
    });

    test('NoteModel serializes and deserializes', () {
      final note = NoteModel(
        id: 'n1',
        title: 'Lecture notes',
        content: 'Dart and Flutter',
        category: 'Study',
        isPinned: true,
        createdAt: DateTime(2026, 11, 20),
        updatedAt: DateTime(2026, 11, 23),
      );

      expect(NoteModel.fromMap(note.toMap()), note);
    });
  });
}
