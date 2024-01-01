import 'package:flutter/material.dart';
import 'package:tracker/common/lang/lang.dart';

extension DurationExt on Duration {
  String toShortTime(BuildContext context) {
    late final days = inDays.abs();
    late final years = days ~/ 365;
    late final hours = inHours.abs();

    if (years > 0) return context.fromLabel(Labels.shortYear, years);
    if (days > 0) return context.fromLabel(Labels.shortDay, days);
    return context.fromLabel(Labels.shortHour, hours);
  }

  String endOrEndedIn(BuildContext context) {
    final value = toShortTime(context);
    final label = isNegative ? Labels.bannerEnded : Labels.bannerEnds;
    return context.fromLabel(label, value);
  }

  String startOrStartedIn(BuildContext context) {
    final value = toShortTime(context);
    final label = isNegative ? Labels.bannerStarted : Labels.bannerStarts;
    return context.fromLabel(label, value);
  }
}
