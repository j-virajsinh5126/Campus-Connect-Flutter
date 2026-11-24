import 'package:flutter/foundation.dart';

import '../models/note_model.dart';
import '../services/local_storage_service.dart';

class NoteProvider extends ChangeNotifier {
  final LocalStorageService _storage;
  NoteProvider({LocalStorageService? storage})
    : _storage = storage ?? LocalStorageService();

  final List<NoteModel> _notes = [];
  bool _loaded = false;
  List<NoteModel> get notes => List.unmodifiable(_notes);

  Future<void> loadNotes() async {
    if (_loaded) return;
    _notes
      ..clear()
      ..addAll(await _storage.loadNotes());
    _loaded = true;
    notifyListeners();
  }

  Future<void> _persist() => _storage.saveNotes(_notes);

  Future<void> addNote(NoteModel note) async {
    _notes.insert(0, note);
    notifyListeners();
    await _persist();
  }

  Future<void> updateNote(NoteModel updated) async {
    final index = _notes.indexWhere((note) => note.id == updated.id);
    if (index == -1) return;
    _notes[index] = updated;
    notifyListeners();
    await _persist();
  }

  Future<void> deleteNote(String id) async {
    _notes.removeWhere((note) => note.id == id);
    notifyListeners();
    await _persist();
  }

  Future<void> togglePinned(String id) async {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index == -1) return;
    _notes[index] = _notes[index].copyWith(
      isPinned: !_notes[index].isPinned,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
    await _persist();
  }

  Future<void> clearAll() async {
    _notes.clear();
    _loaded = true;
    notifyListeners();
    await _storage.saveNotes(_notes);
  }
}
