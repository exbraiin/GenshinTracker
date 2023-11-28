import 'package:flutter/material.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/abstraction/info_data.dart';

enum GsWeekday implements GsEnum {
  monday('Monday'),
  tuesday('Tuesday'),
  wednesday('Wednesday'),
  thursday('Thursday'),
  friday('Friday'),
  saturday('Saturday'),
  sunday('Sunday');

  @override
  final String id;
  const GsWeekday(this.id);

  String getLabel(BuildContext context) =>
      context.fromLabel('weekday_${index + 1}');
}
