import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_domain.dart';

extension BuildContextExt on BuildContext {
  String fromLabel(String label, [Object? arg]) {
    final value = Lang.of(this).getValue(label);
    if (arg == null) return value;

    final exp = RegExp(r'{\w+}');
    final match = exp.allMatches(value).firstOrNull;
    if (match == null) return value;

    final name = value.substring(match.start, match.end);
    return value.replaceAll(name, arg.toString());
  }
}

class InfoMaterialGroups {
  static Map<String, String> _infoMaterialGroups = {
    'none': Labels.wsNone,
    'ascension_gems': Labels.matAscensionGems,
    'normal_boss_drops': Labels.matNormalBossDrops,
    'region_materials_mondstadt': Labels.matLocalSpecialtiesMondstadt,
    'region_materials_liyue': Labels.matLocalSpecialtiesLiyue,
    'region_materials_inazuma': Labels.matLocalSpecialtiesInazuma,
    'region_materials_sumeru': Labels.matLocalSpecialtiesSumeru,
    'normal_drops': Labels.matNormalDrops,
    'elite_drops': Labels.matEliteDrops,
    'forging': Labels.matForging,
    'furnishing': Labels.matFurnishing,
    'weapon_materials_mondstadt': Labels.matWeaponMaterialsMondstadt,
    'weapon_materials_liyue': Labels.matWeaponMaterialsLiyue,
    'weapon_materials_inazuma': Labels.matWeaponMaterialsInazuma,
    'weapon_materials_sumeru': Labels.matWeaponMaterialsSumeru,
    'talent_materials_mondstadt': Labels.matTalentMaterialsMondstadt,
    'talent_materials_liyue': Labels.matTalentMaterialsLiyue,
    'talent_materials_inazuma': Labels.matTalentMaterialsInazuma,
    'talent_materials_sumeru': Labels.matTalentMaterialsSumeru,
    'weekly_boss_drops': Labels.matWeeklyBossDrops,
    'talent_materials': Labels.talents,
  };

  static Set<String> get groups => _infoMaterialGroups.keys.toSet();

  static String getLabel(String group) =>
      _infoMaterialGroups[group] ?? Labels.wsNone;
}

extension GsElementExt on GsElement {
  Color getColor() {
    return const [
      Color(0xFF33CCB3),
      Color(0xFFCFA726),
      Color(0xFFD376F0),
      Color(0xFF77AD2D),
      Color(0xFF1C72FD),
      Color(0xFFE2311D),
      Color(0xFF98C8E8),
    ][this.index];
  }

  String getLabel() {
    return const [
      Labels.elAnemo,
      Labels.elGeo,
      Labels.elElectro,
      Labels.elDendro,
      Labels.elHydro,
      Labels.elPyro,
      Labels.elCryo,
    ][this.index];
  }

  String toPrettyString(BuildContext context) {
    return context.fromLabel(getLabel());
  }
}

extension GsRegionExt on GsRegion {
  String getLabel() {
    return const [
      Labels.regionNone,
      Labels.regionMondstadt,
      Labels.regionLiyue,
      Labels.regionInazuma,
      Labels.regionSumeru,
      Labels.regionFontaine,
      Labels.regionNatlan,
      Labels.regionSnezhnaya,
      Labels.regionKhaenriah,
    ][this.index];
  }

  String toPrettyString(BuildContext context) {
    return context.fromLabel(getLabel());
  }
}

extension GsItemExt on GsItem {
  String getLabel() {
    return const {
      GsItem.weapon: Labels.weapon,
      GsItem.character: Labels.character,
    }[this]!;
  }

  String toPrettyString(BuildContext context) {
    return context.fromLabel(getLabel());
  }
}

extension GsSetCategoryExt on GsSetCategory {
  String getLabel() {
    return const {
      GsSetCategory.indoor: Labels.indoor,
      GsSetCategory.outdoor: Labels.outdoor,
    }[this]!;
  }

  String toPrettyString(BuildContext context) {
    return context.fromLabel(getLabel());
  }
}

extension GsWeaponExt on GsWeapon {
  String getLabel() {
    return const {
      GsWeapon.sword: Labels.wpSword,
      GsWeapon.claymore: Labels.wpClaymore,
      GsWeapon.polearm: Labels.wpPolearm,
      GsWeapon.catalyst: Labels.wpCatalyst,
      GsWeapon.bow: Labels.wpBow,
    }[this]!;
  }

  String toPrettyString(BuildContext context) {
    final key = this.getLabel();
    return Lang.of(context).getValue(key);
  }
}

extension InfoCharacterAscensionExt on InfoCharacterAscension {
  String toAscensionStat(GsAttributeStat stat) {
    final after = valuesAfter[stat];
    final before = valuesBefore[stat];
    if (after == null && before == null) return stat.toIntOrPercentage(0);
    if (after == null && before != null) return stat.toIntOrPercentage(before);
    if (after != null && before == null) return stat.toIntOrPercentage(after);
    if (after == before) return stat.toIntOrPercentage(after!);
    return '${stat.toIntOrPercentage(before!)} → ${stat.toIntOrPercentage(after!)}';
  }
}

extension GsWeaponStatListExt on List<GsAttributeStat> {
  Set<GsAttributeStat> get weaponStats {
    return {
      GsAttributeStat.none,
      GsAttributeStat.hpPercent,
      GsAttributeStat.atkPercent,
      GsAttributeStat.defPercent,
      GsAttributeStat.critDmg,
      GsAttributeStat.critRate,
      GsAttributeStat.physicalDmg,
      GsAttributeStat.energyRecharge,
      GsAttributeStat.elementalMastery,
    };
  }

  Set<GsAttributeStat> get characterStats {
    return GsAttributeStat.values.except([
      GsAttributeStat.hp,
      GsAttributeStat.atk,
      GsAttributeStat.def,
    ]).toSet();
  }
}

extension GsWeaponStatExt on GsAttributeStat {
  String toPrettyString(BuildContext context) {
    final key = const {
      GsAttributeStat.none: Labels.wsNone,
      GsAttributeStat.hp: Labels.wsHp,
      GsAttributeStat.atk: Labels.wsAtk,
      GsAttributeStat.def: Labels.wsDef,
      GsAttributeStat.critDmg: Labels.wsCritdmg,
      GsAttributeStat.critRate: Labels.wsCritrate,
      GsAttributeStat.physicalDmg: Labels.wsPhysicaldmg,
      GsAttributeStat.elementalMastery: Labels.wsElementalmastery,
      GsAttributeStat.energyRecharge: Labels.wsEnergyrecharge,
      GsAttributeStat.healing: Labels.wsHealing,
      GsAttributeStat.hpPercent: Labels.wsHp,
      GsAttributeStat.atkPercent: Labels.wsAtk,
      GsAttributeStat.defPercent: Labels.wsDef,
      GsAttributeStat.anemoDmgBonus: Labels.wsAnemoDmg,
      GsAttributeStat.geoDmgBonus: Labels.wsGeoBonus,
      GsAttributeStat.electroDmgBonus: Labels.wsElectroBonus,
      GsAttributeStat.dendroDmgBonus: Labels.wsDendroBonus,
      GsAttributeStat.hydroDmgBonus: Labels.wsHydroBonus,
      GsAttributeStat.pyroDmgBonus: Labels.wsPyroBonus,
      GsAttributeStat.cryoDmgBonus: Labels.wsCryoBonus,
    }[this]!;
    return Lang.of(context).getValue(key);
  }

  String toIntOrPercentage(double value, [bool format = true]) {
    final percentage = GsAttributeStat.values.except({
      GsAttributeStat.none,
      GsAttributeStat.hp,
      GsAttributeStat.atk,
      GsAttributeStat.def,
      GsAttributeStat.elementalMastery,
    });

    late final String str;
    if (format) {
      final dc = value.toStringAsFixed(1).split('.').last;
      str = '${value.toInt().format()}${dc != '0' ? '.$dc' : ''}';
    } else {
      str = value.toStringAsFixed(value == value.toInt() ? 0 : 1);
    }

    if (!percentage.contains(this)) return str;
    return '$str%';
  }
}

extension GsRecipeBuffExt on GsRecipeBuff {
  String get label {
    final map = const {
      GsRecipeBuff.revive: Labels.rbRevive,
      GsRecipeBuff.adventure: Labels.rbAdventure,
      GsRecipeBuff.defBoost: Labels.rbDef,
      GsRecipeBuff.atkBoost: Labels.rbAtk,
      GsRecipeBuff.atkCritBoost: Labels.rbAtkCrit,
      GsRecipeBuff.recoveryHP: Labels.rbHpRecovery,
      GsRecipeBuff.recoveryHPAll: Labels.rbHpAllRecovery,
      GsRecipeBuff.staminaIncrease: Labels.rbStaminaIncrease,
      GsRecipeBuff.staminaReduction: Labels.rbStaminaReduction,
    };
    return map[this] ?? Labels.wsNone;
  }
}
