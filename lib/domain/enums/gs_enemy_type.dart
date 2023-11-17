import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_domain.dart';

enum GsEnemyType implements GsEnum {
  none('none', Labels.wsNone),
  common('common', Labels.etCommon),
  elite('elite', Labels.etElite),
  normalBoss('normal_boss', Labels.etNormalBoss),
  weeklyBoss('weekly_boss', Labels.etWeeklyBoss);

  @override
  final String id;
  final String label;
  const GsEnemyType(this.id, this.label);
}
