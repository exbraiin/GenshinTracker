import 'package:dartx/dartx.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_domain.dart';

const _wp = 'assets/image/weapon_stat';
const _ep = 'assets/image/element';

enum GsAttributeStat implements GsEnum {
  none(Labels.wsNone, ''),
  hp(Labels.wsHp, '$_wp/hp.png'),
  atk(Labels.wsAtk, '$_wp/atk.png'),
  def(Labels.wsDef, '$_wp/def.png'),
  critDmg(Labels.wsCritdmg, '$_wp/critDmg.png'),
  critRate(Labels.wsCritrate, '$_wp/critRate.png'),
  physicalDmg(Labels.wsPhysicaldmg, '$_wp/physicalDmg.png'),
  elementalMastery(Labels.wsElementalmastery, '$_wp/elementalMastery.png'),
  energyRecharge(Labels.wsEnergyrecharge, '$_wp/energyRecharge.png'),
  healing(Labels.wsHealing, '$_wp/healing.png'),
  hpPercent(Labels.wsHpPercent, '$_wp/hpPercent.png'),
  atkPercent(Labels.wsAtkPercent, '$_wp/atkPercent.png'),
  defPercent(Labels.wsDefPercent, '$_wp/defPercent.png'),
  anemoDmgBonus(Labels.wsAnemoDmg, '$_ep/anemo.png'),
  geoDmgBonus(Labels.wsGeoBonus, '$_ep/geo.png'),
  electroDmgBonus(Labels.wsElectroBonus, '$_ep/electro.png'),
  dendroDmgBonus(Labels.wsDendroBonus, '$_ep/dendro.png'),
  hydroDmgBonus(Labels.wsHydroBonus, '$_ep/hydro.png'),
  pyroDmgBonus(Labels.wsPyroBonus, '$_ep/pyro.png'),
  cryoDmgBonus(Labels.wsCryoBonus, '$_ep/cryo.png');

  @override
  String get id => name;

  final String label;
  final String assetPath;
  const GsAttributeStat(this.label, this.assetPath);

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
