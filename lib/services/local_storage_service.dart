import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/note_model.dart';

/// Notes are stored in a real JSON file; RSVP IDs are stored in
/// SharedPreferences, as required by the Task 3 specification.
class LocalStorageService {
  static const String _rsvpKey = 'campus_connect_rsvps_v1';
  static const String _notesFileName = 'campus_connect_notes.json';

  Future<File> _notesFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}${Platform.pathSeparator}$_notesFileName');
  }

  Future<void> saveNotes(List<NoteModel> notes) async {
    final file = await _notesFile();
    final encoded = jsonEncode(notes.map((note) => note.toMap()).toList());
    await file.writeAsString(encoded, flush: true);
  }

  Future<List<NoteModel>> loadNotes() async {
    try {
      final file = await _notesFile();
      if (!await file.exists()) return [];
      final raw = await file.readAsString();
      if (raw.trim().isEmpty) return [];
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map(
            (item) => NoteModel.fromMap(Map<String, dynamic>.from(item as Map)),
          )
          .toList();
    } on FormatException {
      return [];
    } on FileSystemException {
      return [];
    }
  }

  Future<void> saveRsvps(Set<String> eventIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_rsvpKey, eventIds.toList());
  }

  Future<Set<String>> loadRsvps() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_rsvpKey) ?? <String>[]).toSet();
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rsvpKey);
    final file = await _notesFile();
    if (await file.exists()) await file.delete();
  }
}
