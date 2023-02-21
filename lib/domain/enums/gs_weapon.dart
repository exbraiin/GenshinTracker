import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_domain.dart';

enum GsWeapon implements GsEnum {
  sword(Labels.wpSword),
  claymore(Labels.wpClaymore),
  polearm(Labels.wpPolearm),
  catalyst(Labels.wpCatalyst),
  bow(Labels.wpBow);

  @override
  String get id => name;

  final String label;
  const GsWeapon(this.label);
}
