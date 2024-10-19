import 'package:flutter/material.dart';
import 'package:tracker/common/lang/lang.dart';

extension DurationExt on Duration {
  String toShortTime(BuildContext context) {
    late final days = inDays.abs();
    late final years = days ~/ 365;
    late final hours = inHours.abs();

    if (years > 0) return context.labels.shortYear(years);
    if (days > 0) return context.labels.shortDay(days);
    return context.labels.shortHour(hours);
  }

  String endOrEndedIn(BuildContext context) {
    final value = toShortTime(context);
    if (isNegative) return context.labels.bannerEnded(value);
    return context.labels.bannerEnds(value);
  }

  String startOrStartedIn(BuildContext context) {
    final value = toShortTime(context);
    if (isNegative) context.labels.bannerStarted(value);
    return context.labels.bannerStarts(value);
  }
}
