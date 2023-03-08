extension DateTimeExt on DateTime {
  String toPrettyDate() {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[month - 1]} $day${year != 0 ? ', $year' : ''}';
  }

  String format({bool showHour = true}) {
    final str = toString().split('.').first;
    if (showHour) return str;
    return str.split(' ').first.toString();
  }

  String toBirthday() {
    final d = day.toString().padLeft(2, '0');
    final m = month.toString().padLeft(2, '0');
    return '$m/$d';
  }
}
