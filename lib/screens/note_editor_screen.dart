import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note_model.dart';
import '../providers/note_provider.dart';

class NoteEditorScreen extends StatefulWidget {
  final NoteModel? note;
  const NoteEditorScreen({super.key, this.note});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _title = TextEditingController();
  final _content = TextEditingController();
  Timer? _saveTimer;
  bool _hasChanges = false;
  bool _isSaving = false;
  String? _category;

  @override
  void initState() {
    super.initState();
    _title.text = widget.note?.title ?? '';
    _content.text = widget.note?.content ?? '';
    _category = widget.note?.category;
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  void _onChanged() {
    setState(() => _hasChanges = true);
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 900), _save);
  }

  Future<void> _save() async {
    if (_title.text.trim().isEmpty && _content.text.trim().isEmpty) return;

    setState(() => _isSaving = true);
    await Future<void>.delayed(const Duration(milliseconds: 250));

    final now = DateTime.now();
    final existing = widget.note;
    final note = NoteModel(
      id: existing?.id ?? 'note_${now.microsecondsSinceEpoch}',
      title: _title.text.trim().isEmpty ? 'Untitled note' : _title.text.trim(),
      content: _content.text,
      category: _category,
      isPinned: existing?.isPinned ?? false,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );

    final provider = context.read<NoteProvider>();
    if (existing == null) {
      provider.addNote(note);
    } else {
      provider.updateNote(note);
    }

    if (!mounted) return;
    setState(() {
      _hasChanges = false;
      _isSaving = false;
    });
  }

  Future<void> _saveAndClose() async {
    _saveTimer?.cancel();
    await _save();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                _isSaving
                    ? 'Saving...'
                    : _hasChanges
                    ? 'Unsaved'
                    : 'Saved',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ),
          IconButton(
            onPressed: _saveAndClose,
            icon: const Icon(Icons.check),
            tooltip: 'Save note',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _title,
              onChanged: (_) => _onChanged(),
              textCapitalization: TextCapitalization.sentences,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: 'Note title',
                border: InputBorder.none,
                filled: false,
              ),
            ),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(
                labelText: 'Category (optional)',
                border: OutlineInputBorder(),
              ),
              items: const ['Study', 'Personal', 'Work', 'Ideas']
                  .map(
                    (value) =>
                        DropdownMenuItem(value: value, child: Text(value)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() => _category = value);
                _onChanged();
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _content,
                onChanged: (_) => _onChanged(),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: 'Start writing your notes...',
                  border: InputBorder.none,
                  filled: false,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${_content.text.length} characters',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
