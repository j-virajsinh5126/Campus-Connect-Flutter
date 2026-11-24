extension StringExtensions on String {
  String get capitalized {
    if (trim().isEmpty) return this;

    final value = trim();
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }

  String get titleCase {
    return trim()
        .split(RegExp(r'\s+'))
        .map((word) => word.capitalized)
        .join(' ');
  }

  bool containsQuery(String query) {
    return toLowerCase().contains(query.trim().toLowerCase());
  }

  bool get isValidEmail {
    return RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$').hasMatch(trim());
  }

  String get initials {
    final words = trim().split(RegExp(r'\s+'));

    if (words.isEmpty || words.first.isEmpty) return '';

    if (words.length == 1) {
      return words.first.substring(0, 1).toUpperCase();
    }

    return '${words.first[0]}${words[1][0]}'.toUpperCase();
  }
}
