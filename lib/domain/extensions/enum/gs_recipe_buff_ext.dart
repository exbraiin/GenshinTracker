import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/enums/gs_recipe_buff.dart';

extension GsRecipeBuffExt on GsRecipeBuff {
  String get label => const [
        Labels.wsNone,
        Labels.rbRevive,
        Labels.rbAdventure,
        Labels.rbDef,
        Labels.rbAtk,
        Labels.rbAtkCrit,
        Labels.rbHpRecovery,
        Labels.rbHpAllRecovery,
        Labels.rbStaminaReduction,
        Labels.rbStaminaIncrease,
      ][index];
}
