import 'package:dartx/dartx.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_domain.dart';

enum GsItemSource implements GsEnum {
  none('none', Labels.wsNone),
  shop('shop', Labels.wsNone),
  event('event', Labels.wsNone),
  fishing('fishing', Labels.wsNone),
  forging('forging', Labels.wsNone),
  battlepass('battlepass', Labels.wsNone),
  exploration('exploration', Labels.wsNone),
  wishesStandard('wishes_standard', Labels.wsNone),
  wishesWeaponBanner('wishes_weapon_banner', Labels.wsNone),
  wishesCharacterBanner('wishes_character_banner', Labels.wsNone);

  @override
  final String id;
  final String label;
  const GsItemSource(this.id, this.label);

  static GsItemSource fromId(String? id) =>
      GsItemSource.values.firstOrNullWhere((e) => e.id == id) ??
      GsItemSource.none;
}
