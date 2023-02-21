import 'package:dartx/dartx.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/lang/lang.dart';

enum GsAttributeStat {
  none(Labels.wsNone),
  hp(Labels.wsHp),
  atk(Labels.wsAtk),
  def(Labels.wsDef),
  critDmg(Labels.wsCritdmg),
  critRate(Labels.wsCritrate),
  physicalDmg(Labels.wsPhysicaldmg),
  elementalMastery(Labels.wsElementalmastery),
  energyRecharge(Labels.wsEnergyrecharge),
  healing(Labels.wsHealing),
  hpPercent(Labels.wsHp),
  atkPercent(Labels.wsAtk),
  defPercent(Labels.wsDef),
  anemoDmgBonus(Labels.wsAnemoDmg),
  geoDmgBonus(Labels.wsGeoBonus),
  electroDmgBonus(Labels.wsElectroBonus),
  dendroDmgBonus(Labels.wsDendroBonus),
  hydroDmgBonus(Labels.wsHydroBonus),
  pyroDmgBonus(Labels.wsPyroBonus),
  cryoDmgBonus(Labels.wsCryoBonus);

  final String label;
  const GsAttributeStat(this.label);

  String toIntOrPercentage(double value, {bool format = true}) {
    final percentage = GsAttributeStat.values.except({
      GsAttributeStat.none,
      GsAttributeStat.hp,
      GsAttributeStat.atk,
      GsAttributeStat.def,
      GsAttributeStat.elementalMastery,
    });

    late final dc = value.toStringAsFixed(1).split('.').last;
    final str = format
        ? '${value.toInt().format()}${dc != '0' ? '.$dc' : ''}'
        : value.toStringAsFixed(value == value.toInt() ? 0 : 1);
    return !percentage.contains(this) ? str : '$str%';
  }

  static Set<GsAttributeStat> get weaponStats {
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

  static Set<GsAttributeStat> get characterStats {
    return GsAttributeStat.values.except([
      GsAttributeStat.hp,
      GsAttributeStat.atk,
      GsAttributeStat.def,
    ]).toSet();
  }
}
