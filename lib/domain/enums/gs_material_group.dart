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
  weeklyBossDrops(
    'weekly_boss_drops',
    Labels.matWeeklyBossDrops,
  ),
  regionMaterials(
    'region_materials',
    Labels.matLocalSpecialties,
  ),
  weaponMaterials(
    'weapon_materials',
    Labels.matWeaponMaterials,
  ),
  talentMaterials(
    'talent_materials',
    Labels.matTalentMaterials,
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
