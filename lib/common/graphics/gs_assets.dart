import 'package:tracker/domain/gs_domain.dart';

const imageAppIcon = 'assets/image/icons/app_icon.png';

const imageIndoorSet = 'assets/image/icons/icon_indoor_set.png';
const imageOutdoorSet = 'assets/image/icons/icon_outdoor_set.png';

const menuIconArtifacts = 'assets/image/icons/menu_icon_artifacts.png';
const menuIconInventory = 'assets/image/icons/menu_icon_bag.png';
const menuIconWish = 'assets/image/icons/menu_icon_wish.png';
const menuIconRecipes = 'assets/image/icons/menu_icon_recipes.png';
const menuIconMaterials = 'assets/image/icons/menu_icon_materials.png';
const menuIconWeapons = 'assets/image/icons/menu_icon_weapons.png';
const menuIconSereniteaPot = 'assets/image/icons/menu_icon_serenitea_sets.png';
const menuIconQuest = 'assets/image/icons/menu_icon_quest.png';
const menuIconReputation = 'assets/image/icons/menu_icon_reputation.png';
const menuIconCharacters = 'assets/image/icons/menu_icon_characters.png';
const menuIconBook = 'assets/image/icons/menu_icon_book.webp';
const menuIconArchive = 'assets/image/icons/menu_icon_archive.webp';
const menuIconAchievements = 'assets/image/icons/menu_icon_achievements.webp';
const menuIconFeedback = 'assets/image/icons/menu_icon_feedback.webp';
const menuIconMap = 'assets/image/icons/menu_icon_map.webp';
const iconMissing = 'assets/image/icons/missing_icon.webp';

const imagePrimogem = 'assets/image/icons/3.0x/primogem.png';
const imageXp = 'assets/image/icons/Companion_xp.png';

const spincrystalAsset = 'assets/image/illustrations/spincrystal.png';

String getRarityBgImage(int r) => 'assets/image/rarity/Item_${r}_Star.png';

String getElementBgImage(GsElement e) =>
    'assets/image/backgrounds/${e.name}.gif';

extension GsElementExt on GsElement {
  String get assetPath => 'assets/image/element/$name.png';
}

extension GsWeaponExt on GsWeapon {
  String get assetPath => 'assets/image/weapon_type/$name.png';
}

extension GsWeaponStatExt on GsAttributeStat {
  String get assetPath {
    if (this == GsAttributeStat.none) return '';
    return 'assets/image/weapon_stat/$name.png';
  }
}

extension GsRecipeBuffExt on GsRecipeBuff {
  String get assetPath {
    if (this == GsRecipeBuff.none) return '';
    return 'assets/image/recipe_buff/$name.png';
  }
}
