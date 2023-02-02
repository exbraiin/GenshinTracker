import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:tracker/domain/gs_domain.dart';

export 'enums/gs_artifact_piece.dart';
export 'enums/gs_attribute_stat.dart';
export 'enums/gs_banner.dart';
export 'enums/gs_element.dart';
export 'enums/gs_item.dart';
export 'enums/gs_item_source.dart';
export 'enums/gs_material_group.dart';
export 'enums/gs_recipe_buff.dart';
export 'enums/gs_region.dart';
export 'enums/gs_set_category.dart';
export 'enums/gs_weapon.dart';
export 'extensions/enum/gs_attribute_stat_ext.dart';
export 'extensions/enum/gs_element_ext.dart';
export 'extensions/enum/gs_item_ext.dart';
export 'extensions/enum/gs_material_group_ext.dart';
export 'extensions/enum/gs_recipe_buff_ext.dart';
export 'extensions/enum/gs_region_ext.dart';
export 'extensions/enum/gs_set_category_ext.dart';
export 'extensions/enum/gs_weapon_ext.dart';
export 'models/info_artifact.dart';
export 'models/info_banner.dart';
export 'models/info_character.dart';
export 'models/info_character_info.dart';
export 'models/info_character_outfit.dart';
export 'models/info_city.dart';
export 'models/info_data.dart';
export 'models/info_details.dart';
export 'models/info_ingredient.dart';
export 'models/info_material.dart';
export 'models/info_namecard.dart';
export 'models/info_recipe.dart';
export 'models/info_remarkable_chest.dart';
export 'models/info_serenitea_set.dart';
export 'models/info_spincrystal.dart';
export 'models/info_version.dart';
export 'models/info_weapon.dart';
export 'models/info_weapon_info.dart';
export 'models/save_character.dart';
export 'models/save_material.dart';
export 'models/save_recipe.dart';
export 'models/save_remarkable_chest.dart';
export 'models/save_reputation.dart';
export 'models/save_serenitea_set.dart';
export 'models/save_spincrystal.dart';
export 'models/save_wish.dart';

class GsDomain {
  GsDomain._();

  /// Tests if the domain has all labels.
  static bool testLabels() {
    try {
      GsAttributeStat.values.map((e) => e.label).toList();
      GsElement.values.map((e) => e.label).toList();
      GsItem.values.map((e) => e.label).toList();
      GsMaterialGroup.values.map((e) => e.label).toList();
      GsRecipeBuff.values.map((e) => e.label).toList();
      GsRegion.values.map((e) => e.label).toList();
      GsSetCategory.values.map((e) => e.label).toList();
      GsWeapon.values.map((e) => e.label).toList();
      if (kDebugMode) print('\x1b[31mValid Labels!');
      return true;
    } catch (error) {
      if (kDebugMode) print('\x1b[31m$error');
      return false;
    }
  }
}

extension ListEnumExt<T extends Enum> on List<T> {
  T fromName(String name, [T? defaultValue]) {
    return firstWhere(
      (e) => e.name == name,
      orElse: () => defaultValue ?? first,
    );
  }
}

extension JsonMapExt on Map<String, dynamic> {
  List<String> getAsStringList(String key) {
    final value = this[key] as String? ?? '';
    final trimmed = value.split(',').map((e) => e.trim());
    return trimmed.where((e) => e.isNotBlank).toList();
  }
}
