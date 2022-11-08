import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/enums/gs_weapon.dart';

extension GsWeaponExt on GsWeapon {
  String get label => [
        Labels.wpSword,
        Labels.wpClaymore,
        Labels.wpPolearm,
        Labels.wpCatalyst,
        Labels.wpBow,
      ][index];
}
