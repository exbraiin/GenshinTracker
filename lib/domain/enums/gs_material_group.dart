import 'package:dartx/dartx.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_domain.dart';

enum GsMaterialGroup implements GsEnum {
  none(
    'none',
    Labels.wsNone,
  ),
  ascensionGems(
    'ascension_gems',
    Labels.matAscensionGems,
  ),
  normalBossDrops(
    'normal_boss_drops',
    Labels.matNormalBossDrops,
  ),
  regionMaterialsMondstadt(
    'region_materials_mondstadt',
    Labels.matLocalSpecialtiesMondstadt,
  ),
  regionMaterialsLiyue(
    'region_materials_liyue',
    Labels.matLocalSpecialtiesLiyue,
  ),
  regionMaterialsInazuma(
    'region_materials_inazuma',
    Labels.matLocalSpecialtiesInazuma,
  ),
  regionMaterialsSumeru(
    'region_materials_sumeru',
    Labels.matLocalSpecialtiesSumeru,
  ),
  normalDrops(
    'normal_drops',
    Labels.matNormalDrops,
  ),
  eliteDrops(
    'elite_drops',
    Labels.matEliteDrops,
  ),
  forging(
    'forging',
    Labels.matForging,
  ),
  furnishing(
    'furnishing',
    Labels.matFurnishing,
  ),
  weaponMaterialsMondstadt(
    'weapon_materials_mondstadt',
    Labels.matWeaponMaterialsMondstadt,
  ),
  weaponMaterialsLiyue(
    'weapon_materials_liyue',
    Labels.matWeaponMaterialsLiyue,
  ),
  weaponMaterialsInazuma(
    'weapon_materials_inazuma',
    Labels.matWeaponMaterialsInazuma,
  ),
  weaponMaterialsSumeru(
    'weapon_materials_sumeru',
    Labels.matWeaponMaterialsSumeru,
  ),
  talentMaterialsMondstadt(
    'talent_materials_mondstadt',
    Labels.matTalentMaterialsMondstadt,
  ),
  talentMaterialsLiyue(
    'talent_materials_liyue',
    Labels.matTalentMaterialsLiyue,
  ),
  talentMaterialsInazuma(
    'talent_materials_inazuma',
    Labels.matTalentMaterialsInazuma,
  ),
  talentMaterialsSumeru(
    'talent_materials_sumeru',
    Labels.matTalentMaterialsSumeru,
  ),
  weeklyBossDrops(
    'weekly_boss_drops',
    Labels.matWeeklyBossDrops,
  ),
  talentMaterials(
    'talent_materials',
    Labels.talents,
  );

  @override
  final String id;
  final String label;
  const GsMaterialGroup(this.id, this.label);

  static GsMaterialGroup fromId(String id) {
    return GsMaterialGroup.values.firstOrNullWhere((e) => e.id == id) ??
        GsMaterialGroup.none;
  }
}
