import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_domain.dart';

enum GsRecipeBuff implements GsEnum {
  /// No buff
  none(Labels.wsNone),

  /// Recovery Dishes
  /// * Revive buff
  revive(Labels.rbRevive),

  /// Adventurer's Dishes
  adventure(Labels.rbAdventure),

  /// DEF-Boosting Dishes
  defBoost(Labels.rbDef),

  /// ATK-Boosting Dishes
  /// * ATK boost
  atkBoost(Labels.rbAtk),

  /// ATK-Boosting Dishes
  /// * ATK CRIT boost
  atkCritBoost(Labels.rbAtkCrit),

  /// Recovery Dishes
  /// * HP recovery
  recoveryHP(Labels.rbHpRecovery),

  /// Recovery Dishes
  /// * HP recovery and extra
  recoveryHPAll(Labels.rbHpAllRecovery),

  /// Adventurer's Dishes
  /// * Stamina Reduction
  staminaReduction(Labels.rbStaminaReduction),

  /// Adventurer's Dishes
  /// * Stamina Increse
  staminaIncrease(Labels.rbStaminaIncrease);

  @override
  String get id => name;

  final String label;
  const GsRecipeBuff(this.label);
}
