export 'enums/gs_banner.dart';
export 'enums/gs_element.dart';
export 'enums/gs_item.dart';
export 'enums/gs_recipe_buff.dart';
export 'enums/gs_region.dart';
export 'enums/gs_set_category.dart';
export 'enums/gs_weapon.dart';
export 'enums/gs_weapon_stat.dart';
export 'models/info_artifact.dart';
export 'models/info_banner.dart';
export 'models/info_character.dart';
export 'models/info_character_details.dart';
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

const kEnableAchievements = false;
const kEnableCharacterDetails = false;

class GsUtils {
  GsUtils._();

  static List<String> parseIds(String? value, [String separator = ',']) {
    if (value == null) return [];
    return value
        .split(separator)
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  static List<int> parseWeekdays(String? value, [String separator = ',']) {
    const values = {
      'mo': DateTime.monday,
      'tu': DateTime.tuesday,
      'we': DateTime.wednesday,
      'th': DateTime.thursday,
      'fr': DateTime.friday,
      'sa': DateTime.saturday,
      'su': DateTime.sunday,
    };
    return parseIds(value, separator)
        .map((e) => values[e])
        .whereType<int>()
        .toList();
  }
}
