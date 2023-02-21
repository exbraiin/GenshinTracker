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
  String get id => label;

  final String label;
  const GsWeekday(this.label);
}
