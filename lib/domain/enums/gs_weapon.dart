import 'package:tracker/common/lang/lang.dart';

enum GsWeapon {
  sword(Labels.wpSword),
  claymore(Labels.wpClaymore),
  polearm(Labels.wpPolearm),
  catalyst(Labels.wpCatalyst),
  bow(Labels.wpBow);

  final String label;
  const GsWeapon(this.label);
}
