import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_domain.dart';

enum GsEnemyFamily implements GsEnum {
  none('none', Labels.wsNone),
  elemetalLifeform('elemental_lifeform', Labels.efElementalLifeform),
  hilichurl('hilichurl', Labels.efHilichurl),
  abyss('abyss', Labels.efAbyss),
  fatui('fatui', Labels.efFatui),
  automaton('automaton', Labels.efAutomaton),
  humanFaction('human_faction', Labels.efHumanFaction),
  mysticalBeast('mystical_beast', Labels.efMysticalBeast),
  weeklyBoss('weekly_boss', Labels.efWeeklyBoss);

  @override
  final String id;
  final String label;
  const GsEnemyFamily(this.id, this.label);
}
