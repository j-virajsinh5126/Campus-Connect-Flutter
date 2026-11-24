import 'package:flutter/material.dart';

import '../services/firestore_service.dart';

class FirestoreEventsScreen extends StatelessWidget {
  FirestoreEventsScreen({super.key});

  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Campus Events')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firestoreService.getEventsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading events:\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final events = snapshot.data ?? [];

          if (events.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.event_busy, size: 55),
                  SizedBox(height: 12),
                  Text('No campus events available yet.'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.event)),
                  title: Text(event['title']?.toString() ?? 'Untitled Event'),
                  subtitle: Text(
                    [
                      event['category']?.toString() ?? 'General',
                      event['location']?.toString() ?? 'Location not specified',
                      event['description']?.toString() ?? '',
                    ].where((value) => value.isNotEmpty).join('\n'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
