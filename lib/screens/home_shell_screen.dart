import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/locale_provider.dart';
import '../utils/app_localizations.dart';
import 'events_screen.dart';
import 'my_events_screen.dart';
import 'notes_screen.dart';
import 'settings_screen.dart';

class HomeShellScreen extends StatelessWidget {
  const HomeShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return DefaultTabController(
      length: 3,
      child: Builder(
        builder: (tabContext) {
          final tabController = DefaultTabController.of(tabContext);
          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.text('app_name')),
              bottom: TabBar(
                controller: tabController,
                tabs: [
                  Tab(
                    text: l10n.text('upcoming'),
                    icon: const Icon(Icons.explore),
                  ),
                  Tab(
                    text: l10n.text('my_events'),
                    icon: const Icon(Icons.event_available),
                  ),
                  Tab(
                    text: l10n.text('notes'),
                    icon: const Icon(Icons.note_alt),
                  ),
                ],
              ),
            ),
            drawer: Drawer(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const UserAccountsDrawerHeader(
                      accountName: Text('CampusConnect Student'),
                      accountEmail: Text('Welcome to your campus hub'),
                      currentAccountPicture: CircleAvatar(
                        child: Icon(Icons.school_rounded, size: 32),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.explore),
                      title: Text(l10n.text('upcoming')),
                      onTap: () => _selectTab(tabContext, tabController, 0),
                    ),
                    ListTile(
                      leading: const Icon(Icons.event_available),
                      title: Text(l10n.text('my_events')),
                      onTap: () => _selectTab(tabContext, tabController, 1),
                    ),
                    ListTile(
                      leading: const Icon(Icons.notes),
                      title: Text(l10n.text('notes')),
                      onTap: () => _selectTab(tabContext, tabController, 2),
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings_outlined),
                      title: const Text('Profile & Settings'),
                      onTap: () {
                        Navigator.pop(tabContext);
                        Navigator.push(
                          tabContext,
                          MaterialPageRoute(
                            builder: (_) => const SettingsScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(l10n.text('language')),
                    ),
                    ListTile(
                      title: Text(l10n.text('english')),
                      trailing: const Text('EN'),
                      onTap: () {
                        context.read<LocaleProvider>().setLocale(
                          const Locale('en'),
                        );
                        Navigator.pop(tabContext);
                      },
                    ),
                    ListTile(
                      title: Text(l10n.text('gujarati')),
                      trailing: const Text('ગુ'),
                      onTap: () {
                        context.read<LocaleProvider>().setLocale(
                          const Locale('gu'),
                        );
                        Navigator.pop(tabContext);
                      },
                    ),
                  ],
                ),
              ),
            ),
            body: const TabBarView(
              children: [EventsScreen(), MyEventsScreen(), NotesScreen()],
            ),
          );
        },
      ),
    );
  }

  void _selectTab(BuildContext context, TabController controller, int index) {
    Navigator.pop(context);
    controller.animateTo(index);
  }
}
