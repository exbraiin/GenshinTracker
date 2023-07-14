import 'package:dartx/dartx.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_domain.dart';

/// The achievement type
enum GsAchievementType implements GsEnum {
  /// None
  none('', Labels.achTypeNone),

  /// Boss
  boss('boss', Labels.achTypeBoss),

  /// Quest
  quest('quest', Labels.achTypeQuest),

  /// Commission
  commission('commission', Labels.achTypeCommission),

  /// Exploration
  exploration('exploration', Labels.achTypeExploration);

  @override
  final String id;
  final String label;
  const GsAchievementType(this.id, this.label);

  static GsAchievementType fromId(String id) =>
      GsAchievementType.values.firstOrNullWhere((e) => e.id == id) ??
      GsAchievementType.none;
}
