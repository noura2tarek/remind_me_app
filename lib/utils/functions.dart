import 'package:intl/intl.dart';

// global date format
DateFormat dateFormat = DateFormat('d MMM'); // format shows date in text field

// format reminder  -- save reminder with this format in database

String formatReminder(DateTime reminderDate) {
  final now = DateTime.now();
  final difference = reminderDate.difference(now);

  // Past reminder
  if (difference.isNegative) {
    return DateFormat('d MMM, h:mm a').format(reminderDate);
  }

  // Less than one hour
  if (difference.inHours < 1) {
    if (difference.inMinutes <= 1) {
      return 'In 1 minute';
    }
    return 'In ${difference.inMinutes} minutes';
  }

  // equal one hour
  if (difference.inHours == 1) {
    return 'In 1 hour';
  }
  // Less than 24 hours but today
  if (_isSameDay(reminderDate, now)) {
    return 'Today, ${DateFormat('h:mm a').format(reminderDate)}';
  }

  // Tomorrow
  final tomorrow = now.add(const Duration(days: 1));
  if (_isSameDay(reminderDate, tomorrow)) {
    return 'Tomorrow, ${DateFormat('h:mm a').format(reminderDate)}';
  }

  // Other days
  return DateFormat('d MMM, h:mm a').format(reminderDate);
}

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
