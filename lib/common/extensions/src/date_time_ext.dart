import 'package:flutter/material.dart';
import 'package:tracker/common/lang/lang.dart';

extension DateTimeExt on DateTime {
  String toPrettyDate(BuildContext context) {
    final m = context.fromLabel('month_$month');
    return '$m $day${year != 0 ? ', $year' : ''}';
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
