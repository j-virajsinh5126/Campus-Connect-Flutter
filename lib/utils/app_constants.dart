class AppConstants {
  AppConstants._();

  static const String appName = 'CampusConnect';

  static const String appTagline = 'Your campus life, connected.';

  static const String appDescription =
      'Discover campus events, save personal notes and '
      'stay connected with your college community.';

  static const Duration simulatedNetworkDelay = Duration(seconds: 2);

  static const List<String> eventCategories = [
    'All',
    'Technology',
    'Cultural',
    'Sports',
    'Workshop',
    'Academic',
    'Other',
  ];
}
