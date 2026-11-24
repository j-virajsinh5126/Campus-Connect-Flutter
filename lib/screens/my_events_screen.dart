import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/event_provider.dart';
import '../widgets/event_card.dart';

class MyEventsScreen extends StatelessWidget {
  const MyEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, provider, _) {
        final events = provider.myEvents;
        if (events.isEmpty) {
          return const Center(
            child: Text('You have not RSVP’d to any events yet.'),
          );
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: events
              .map(
                (event) => EventCard(
                  event: event,
                  isRsvped: true,
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/event-details',
                    arguments: event,
                  ),
                  onRsvp: () =>
                      provider.toggleRsvp(event.id, 'current_student'),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
