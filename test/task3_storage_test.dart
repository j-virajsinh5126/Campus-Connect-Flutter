import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:campus/models/note_model.dart';
import 'package:campus/services/local_storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');

  late Directory testDirectory;

  setUpAll(() async {
    testDirectory = await Directory.systemTemp.createTemp(
      'campus_connect_test_',
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, (MethodCall call) async {
          if (call.method == 'getApplicationDocumentsDirectory') {
            return testDirectory.path;
          }
          return null;
        });
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  tearDownAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, null);

    if (await testDirectory.exists()) {
      await testDirectory.delete(recursive: true);
    }
  });

  test('notes persist as JSON in a local file', () async {
    final storage = LocalStorageService();

    final note = NoteModel(
      id: 'n1',
      title: 'Test note',
      content: 'Persistent content',
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 2),
    );

    await storage.saveNotes([note]);

    final restored = await storage.loadNotes();

    expect(restored, [note]);
  });

  test('RSVP selections persist in SharedPreferences', () async {
    final storage = LocalStorageService();

    await storage.saveRsvps({'event_a', 'event_b'});

    final restored = await storage.loadRsvps();

    expect(restored, {'event_a', 'event_b'});
  });
}
