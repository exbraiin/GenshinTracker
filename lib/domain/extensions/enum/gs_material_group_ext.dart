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

extension GsMaterialGroupListExt on List<GsMaterialGroup> {
  GsMaterialGroup fromId(String id) {
    const map = {
      'none': GsMaterialGroup.none,
      'ascension_gems': GsMaterialGroup.ascensionGems,
      'normal_boss_drops': GsMaterialGroup.normalBossDrops,
      'region_materials_mondstadt': GsMaterialGroup.regionMaterialsMondstadt,
      'region_materials_liyue': GsMaterialGroup.regionMaterialsLiyue,
      'region_materials_inazuma': GsMaterialGroup.regionMaterialsInazuma,
      'region_materials_sumeru': GsMaterialGroup.regionMaterialsSumeru,
      'normal_drops': GsMaterialGroup.normalDrops,
      'elite_drops': GsMaterialGroup.eliteDrops,
      'forging': GsMaterialGroup.forging,
      'furnishing': GsMaterialGroup.furnishing,
      'weapon_materials_mondstadt': GsMaterialGroup.weaponMaterialsMondstadt,
      'weapon_materials_liyue': GsMaterialGroup.weaponMaterialsLiyue,
      'weapon_materials_inazuma': GsMaterialGroup.weaponMaterialsInazuma,
      'weapon_materials_sumeru': GsMaterialGroup.weaponMaterialsSumeru,
      'talent_materials_mondstadt': GsMaterialGroup.talentMaterialsMondstadt,
      'talent_materials_liyue': GsMaterialGroup.talentMaterialsLiyue,
      'talent_materials_inazuma': GsMaterialGroup.talentMaterialsInazuma,
      'talent_materials_sumeru': GsMaterialGroup.talentMaterialsSumeru,
      'weekly_boss_drops': GsMaterialGroup.weeklyBossDrops,
      'talent_materials': GsMaterialGroup.talentMaterials,
    };
    return map[id] ?? GsMaterialGroup.none;
  }
}
