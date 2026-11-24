import 'dart:io';

import 'package:flutter/material.dart';

import '../extensions/date_extensions.dart';
import '../models/event_model.dart';

class EventDetailScreen extends StatelessWidget {
  final EventModel event;
  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final hasImage = event.imageUrl != null && event.imageUrl!.isNotEmpty;
    Widget image = !hasImage
        ? Container(
            color: const Color(0xFFE7E9FF),
            child: const Center(child: Icon(Icons.event, size: 72)),
          )
        : event.imageUrl!.startsWith('http')
        ? Image.network(event.imageUrl!, fit: BoxFit.cover)
        : Image.file(File(event.imageUrl!), fit: BoxFit.cover);

    return Scaffold(
      appBar: AppBar(title: const Text('Event Details')),
      body: ListView(
        children: [
          Hero(
            tag: 'event-image-${event.id}',
            child: SizedBox(height: 240, width: double.infinity, child: image),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Chip(label: Text(event.category)),
                Text(
                  event.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text(event.description),
                const SizedBox(height: 20),
                Text('Date: ${event.date.formattedDateTime}'),
                Text('Location: ${event.location}'),
                Text('Organizer: ${event.organizer}'),
                Text('${event.attendees.length} students attending'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
