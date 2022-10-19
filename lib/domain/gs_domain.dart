export 'enums/gs_artifact_piece.dart';
export 'enums/gs_attribute_stat.dart';
export 'enums/gs_banner.dart';
export 'enums/gs_element.dart';
export 'enums/gs_item.dart';
export 'enums/gs_recipe_buff.dart';
export 'enums/gs_region.dart';
export 'enums/gs_set_category.dart';
export 'enums/gs_weapon.dart';
export 'models/info_artifact.dart';
export 'models/info_banner.dart';
export 'models/info_character.dart';
export 'models/info_character.dart';
export 'models/info_city.dart';
export 'models/info_data.dart';
export 'models/info_material.dart';
export 'models/info_recipe.dart';
export 'models/info_serenitea_set.dart';
export 'models/info_spincrystal.dart';
export 'models/info_weapon.dart';
export 'models/save_character.dart';
export 'models/save_material.dart';
export 'models/save_recipe.dart';
export 'models/save_reputation.dart';
export 'models/save_serenitea_set.dart';
export 'models/save_spincrystal.dart';
export 'models/save_wish.dart';

extension ListEnumExt<T extends Enum> on List<T> {
  T fromName(String name, [T? defaultValue]) {
    return firstWhere(
      (e) => e.name == name,
      orElse: () => defaultValue ?? first,
    );
  }
}
