import 'package:intl/intl.dart';

extension DateExtensions on DateTime {
  String get formattedDate => DateFormat('dd MMM yyyy').format(this);

  String get formattedTime => DateFormat('hh:mm a').format(this);

  String get formattedDateTime =>
      DateFormat('dd MMM yyyy, hh:mm a').format(this);

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isUpcoming => isAfter(DateTime.now());

  bool get isPast => isBefore(DateTime.now());

  String get relativeDate {
    if (isToday) return 'Today';

    final tomorrow = DateTime.now().add(const Duration(days: 1));

    if (year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day) {
      return 'Tomorrow';
    }

    return formattedDate;
  }
}
