/// Date utility extensions for formatting and comparison
extension DateTimeExtensions on DateTime {
  /// Compares calendar dates ignoring time
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Checks if this date is yesterday
  bool isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(yesterday);
  }

  /// Checks if this date is today
  bool isToday() {
    return isSameDay(DateTime.now());
  }

  /// Calculates difference in calendar days, not 24-hour periods
  int daysDifferenceTo(DateTime other) {
    final thisDateOnly = DateTime(year, month, day);
    final otherDateOnly = DateTime(other.year, other.month, other.day);
    return otherDateOnly.difference(thisDateOnly).inDays;
  }

  /// Formats a past date as relative time (e.g., "today", "2d ago", "3w ago", "2mo ago")
  String formatRelativeTime() {
    final now = DateTime.now();
    final daysDiff = daysDifferenceTo(now);

    if (isToday()) {
      return 'today';
    } else if (isYesterday()) {
      return 'yesterday';
    } else if (daysDiff < 7) {
      return '${daysDiff}d ago';
    } else {
      final months = (daysDiff / 30).floor();
      if (months == 0) {
        final weeks = (daysDiff / 7).floor();
        return '${weeks}w ago';
      } else if (months == 1) {
        return '1mo ago';
      } else {
        return '${months}mo ago';
      }
    }
  }
}
