import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_domain.dart';

class GsConsts {
  GsConsts._();
  static const kTrue = 'true';
  static const kFalse = 'false';

  static String fromBool(bool value) => value ? kTrue : kFalse;
  static bool toBool(String value) => value == kTrue;
}

extension DateTimeExt on DateTime {
  String format([bool showHour = true]) {
    final str = toString().split('.').first;
    if (showHour) return str;
    return str.split(' ').first.toString();
  }
}

extension DurationExt on Duration {
  String toShortTime() {
    final days = this.inDays.abs();
    final years = days ~/ 365;
    return years > 0
        ? '${years}y'
        : days > 0
            ? '${days}d'
            : '${this.inHours.abs()}h';
  }

  String endOrEndedIn() {
    final val = toShortTime();
    return this.isNegative ? 'Ended $val ago' : 'Ends in $val';
  }

  String startOrStartedIn() {
    final val = toShortTime();
    return this.isNegative ? 'Started $val ago' : 'Starts in $val';
  }
}

extension IterableExt<E> on Iterable<E> {
  Iterable<E> separate(E separator) sync* {
    final it = iterator;
    it.moveNext();
    yield it.current;
    while (it.moveNext()) {
      yield separator;
      yield it.current;
    }
  }
}

extension IntExt on int {
  String format([String separator = ',']) {
    final list = toString().characters.reversed;
    return Iterable.generate(
      (list.length / 3).ceil(),
      (i) => list.skip(i * 3).take(3).reversed.join(),
    ).reversed.join(separator);
  }
}

extension BuildContextExt on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

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
    'crown': Labels.matCrown,
  };

  static Set<String> get groups => _infoMaterialGroups.keys.toSet();

  static String getLabel(String group) =>
      _infoMaterialGroups[group] ?? Labels.wsNone;
}

extension GsElementExt on GsElement {
  Color getColor() {
    return const [
      Colors.lightGreen,
      Colors.amber,
      Colors.purple,
      Colors.green,
      Colors.blue,
      Colors.red,
      Colors.cyan,
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
      GsSetCategory.indoorSet: Labels.indoor,
      GsSetCategory.outdoorSet: Labels.outdoor,
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

extension GsWeaponStatListExt on List<GsWeaponStat> {
  Set<GsWeaponStat> get weaponStats {
    return {
      GsWeaponStat.none,
      GsWeaponStat.hpPercent,
      GsWeaponStat.atkPercent,
      GsWeaponStat.defPercent,
      GsWeaponStat.critDmg,
      GsWeaponStat.critRate,
      GsWeaponStat.physicalDmg,
      GsWeaponStat.energyRecharge,
      GsWeaponStat.elementalMastery,
    };
  }
}

extension GsWeaponStatExt on GsWeaponStat {
  String toPrettyString(BuildContext context) {
    final key = const {
      GsWeaponStat.none: Labels.wsNone,
      GsWeaponStat.hp: Labels.wsHp,
      GsWeaponStat.atk: Labels.wsAtk,
      GsWeaponStat.def: Labels.wsDef,
      GsWeaponStat.critDmg: Labels.wsCritdmg,
      GsWeaponStat.critRate: Labels.wsCritrate,
      GsWeaponStat.physicalDmg: Labels.wsPhysicaldmg,
      GsWeaponStat.elementalMastery: Labels.wsElementalmastery,
      GsWeaponStat.energyRecharge: Labels.wsEnergyrecharge,
      GsWeaponStat.healing: Labels.wsHealing,
      GsWeaponStat.hpPercent: Labels.wsHp,
      GsWeaponStat.atkPercent: Labels.wsAtk,
      GsWeaponStat.defPercent: Labels.wsDef,
      GsWeaponStat.anemoDmgBonus: Labels.wsAnemoDmg,
      GsWeaponStat.geoDmgBonus: Labels.wsGeoBonus,
      GsWeaponStat.electroDmgBonus: Labels.wsElectroBonus,
      GsWeaponStat.dendroDmgBonus: Labels.wsDendroBonus,
      GsWeaponStat.hydroDmgBonus: Labels.wsHydroBonus,
      GsWeaponStat.pyroDmgBonus: Labels.wsPyroBonus,
      GsWeaponStat.cryoDmgBonus: Labels.wsCryoBonus,
    }[this]!;
    return Lang.of(context).getValue(key);
  }

  String toIntOrPercentage(double value) {
    final percentage = {
      GsWeaponStat.critDmg,
      GsWeaponStat.critRate,
      GsWeaponStat.hpPercent,
      GsWeaponStat.atkPercent,
      GsWeaponStat.defPercent,
      GsWeaponStat.energyRecharge,
      GsWeaponStat.physicalDmg,
      GsWeaponStat.anemoDmgBonus,
      GsWeaponStat.geoDmgBonus,
      GsWeaponStat.electroDmgBonus,
      GsWeaponStat.dendroDmgBonus,
      GsWeaponStat.hydroDmgBonus,
      GsWeaponStat.pyroDmgBonus,
      GsWeaponStat.cryoDmgBonus,
    };
    if (!percentage.contains(this)) return '${value.toInt()}';
    if (value == value.toInt()) return '${value.toInt()}%';
    return '${value.toStringAsFixed(1)}%';
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
