import 'package:flutter/material.dart';
import 'package:tracker/common/lang/lang.dart';

abstract final class DateLabels {
  static String humanizedWeekday(BuildContext context, int weekday) {
    return switch (weekday) {
      DateTime.monday => context.labels.weekday1(),
      DateTime.tuesday => context.labels.weekday2(),
      DateTime.wednesday => context.labels.weekday3(),
      DateTime.thursday => context.labels.weekday4(),
      DateTime.friday => context.labels.weekday5(),
      DateTime.saturday => context.labels.weekday6(),
      DateTime.sunday => context.labels.weekday7(),
      _ => throw IndexError.withLength(weekday, 12),
    };
  }

  static String humanizedMonth(BuildContext context, int month) {
    return switch (month) {
      DateTime.january => context.labels.month1(),
      DateTime.february => context.labels.month2(),
      DateTime.march => context.labels.month3(),
      DateTime.april => context.labels.month4(),
      DateTime.may => context.labels.month5(),
      DateTime.june => context.labels.month6(),
      DateTime.july => context.labels.month7(),
      DateTime.august => context.labels.month8(),
      DateTime.september => context.labels.month9(),
      DateTime.october => context.labels.month10(),
      DateTime.november => context.labels.month11(),
      DateTime.december => context.labels.month12(),
      _ => throw IndexError.withLength(month, 12),
    };
  }
}

extension DateTimeExt on DateTime {
  String toPrettyDate(BuildContext context) {
    final m = DateLabels.humanizedMonth(context, month);
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

abstract class DateTimeUtils {
  static String format(BuildContext context, DateTime from, DateTime to) {
    String formatDate(DateTime date, {bool showYear = false}) {
      final m = DateLabels.humanizedMonth(context, date.month);
      final f = '${date.day.toString().padLeft(2, '0')} ${m.substring(0, 3)}';
      return '$f${showYear ? ' ${date.year.toString().padLeft(4, '0')}' : ''}';
    }

    final showYear = from.year != to.year;
    return '${formatDate(from, showYear: showYear)} - ${formatDate(to, showYear: true)}';
  }
}
