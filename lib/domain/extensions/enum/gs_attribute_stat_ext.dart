import 'package:dartx/dartx.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_domain.dart';

extension GsAttributeStatExt on GsAttributeStat {
  String get label => const [
        Labels.wsNone,
        Labels.wsHp,
        Labels.wsAtk,
        Labels.wsDef,
        Labels.wsCritdmg,
        Labels.wsCritrate,
        Labels.wsPhysicaldmg,
        Labels.wsElementalmastery,
        Labels.wsEnergyrecharge,
        Labels.wsHealing,
        Labels.wsHp,
        Labels.wsAtk,
        Labels.wsDef,
        Labels.wsAnemoDmg,
        Labels.wsGeoBonus,
        Labels.wsElectroBonus,
        Labels.wsDendroBonus,
        Labels.wsHydroBonus,
        Labels.wsPyroBonus,
        Labels.wsCryoBonus,
      ][index];

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
