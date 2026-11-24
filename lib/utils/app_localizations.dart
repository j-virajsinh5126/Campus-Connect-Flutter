import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  const AppLocalizations(this.locale);

  static const supportedLocales = [Locale('en'), Locale('gu')];

  static const _values = {
    'en': {
      'app_title': 'CampusConnect',
      'upcoming': 'Upcoming',
      'my_events': 'My Events',
      'notes': 'Notes',
      'create_event': 'Create Event',
      'settings': 'Settings',
      'language': 'Language',
      'english': 'English',
      'gujarati': 'Gujarati',
      'events': 'Campus Events',
      'no_events': 'No events found.',
    },
    'gu': {
      'app_title': 'કેમ્પસ કનેક્ટ',
      'upcoming': 'આગામી',
      'my_events': 'મારા ઇવેન્ટ્સ',
      'notes': 'નોંધો',
      'create_event': 'ઇવેન્ટ બનાવો',
      'settings': 'સેટિંગ્સ',
      'language': 'ભાષા',
      'english': 'અંગ્રેજી',
      'gujarati': 'ગુજરાતી',
      'events': 'કેમ્પસ ઇવેન્ટ્સ',
      'no_events': 'કોઈ ઇવેન્ટ મળી નથી.',
    },
  };

  String text(String key) =>
      _values[locale.languageCode]?[key] ?? _values['en']![key] ?? key;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.any(
    (supported) => supported.languageCode == locale.languageCode,
  );

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
