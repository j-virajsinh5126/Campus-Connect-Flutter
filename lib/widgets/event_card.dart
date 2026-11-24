import 'dart:io';

import 'package:flutter/material.dart';

import '../extensions/date_extensions.dart';
import '../models/event_model.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final bool isRsvped;
  final VoidCallback? onTap;
  final VoidCallback? onRsvp;

  const EventCard({
    super.key,
    required this.event,
    this.isRsvped = false,
    this.onTap,
    this.onRsvp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = event.imageUrl != null && event.imageUrl!.isNotEmpty;
    Widget image;
    if (!hasImage) {
      image = _fallback();
    } else if (event.imageUrl!.startsWith('http')) {
      image = Image.network(
        event.imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    } else {
      image = Image.file(
        File(event.imageUrl!),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'event-image-${event.id}',
              child: SizedBox(
                height: 150,
                width: double.infinity,
                child: image,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Chip(
                        label: Text(event.category),
                        visualDensity: VisualDensity.compact,
                      ),
                      const Spacer(),
                      Text(
                        event.date.relativeDate,
                        style: theme.textTheme.labelMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    event.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 17),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text('${event.attendees.length} attending'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: onRsvp,
                      icon: Icon(
                        isRsvped ? Icons.check_circle : Icons.event_available,
                      ),
                      label: Text(isRsvped ? 'Going' : 'RSVP'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fallback() => Container(
    color: const Color(0xFFE7E9FF),
    child: const Center(
      child: Icon(Icons.event, size: 58, color: Color(0xFF536DFE)),
    ),
  );
}
