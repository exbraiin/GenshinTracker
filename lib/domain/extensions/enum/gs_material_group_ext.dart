import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_domain.dart';

extension GsMaterialGroupExt on GsMaterialGroup {
  String get label => [
        Labels.wsNone,
        Labels.matAscensionGems,
        Labels.matNormalBossDrops,
        Labels.matLocalSpecialtiesMondstadt,
        Labels.matLocalSpecialtiesLiyue,
        Labels.matLocalSpecialtiesInazuma,
        Labels.matLocalSpecialtiesSumeru,
        Labels.matNormalDrops,
        Labels.matEliteDrops,
        Labels.matForging,
        Labels.matFurnishing,
        Labels.matWeaponMaterialsMondstadt,
        Labels.matWeaponMaterialsLiyue,
        Labels.matWeaponMaterialsInazuma,
        Labels.matWeaponMaterialsSumeru,
        Labels.matTalentMaterialsMondstadt,
        Labels.matTalentMaterialsLiyue,
        Labels.matTalentMaterialsInazuma,
        Labels.matTalentMaterialsSumeru,
        Labels.matWeeklyBossDrops,
        Labels.talents,
      ][index];
}
