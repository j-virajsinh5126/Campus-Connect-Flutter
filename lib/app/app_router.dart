import 'package:flutter/material.dart';

import '../models/event_model.dart';
import '../screens/event_detail_screen.dart';
import '../screens/home_shell_screen.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return _fadeRoute(const HomeShellScreen(), settings);
      case '/event-details':
        final event = settings.arguments;
        if (event is! EventModel) {
          return MaterialPageRoute(
            builder: (_) => const _RouteErrorScreen(
              message: 'Event details require a valid EventModel argument.',
            ),
            settings: settings,
          );
        }
        return _slideRoute(EventDetailScreen(event: event), settings);
      default:
        return MaterialPageRoute(
          builder: (_) => const _RouteErrorScreen(
            message: 'The requested page could not be found.',
          ),
          settings: settings,
        );
    }
  }

  static PageRouteBuilder<dynamic> _fadeRoute(
    Widget page,
    RouteSettings settings,
  ) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
    );
  }

  static PageRouteBuilder<dynamic> _slideRoute(
    Widget page,
    RouteSettings settings,
  ) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween<Offset>(
          begin: const Offset(0.12, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}

class _RouteErrorScreen extends StatelessWidget {
  final String message;
  const _RouteErrorScreen({required this.message});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Navigation error')),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(message, textAlign: TextAlign.center),
      ),
    ),
  );
}
