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
  String toPrettyDate() {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[month - 1]} $day${year != 0 ? ', $year' : ''}';
  }

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
