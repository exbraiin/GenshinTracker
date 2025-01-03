import 'package:gsdatabase/gsdatabase.dart';

export '../../theme/theme.dart';
export './gs_spacing.dart';

class GsStyle {
  GsStyle._();
}

abstract final class GsAssets {
  static const imageAppIcon = 'assets/image/icons/app_icon.png';
  static const imageAppIconSmall = 'assets/image/icons/app_icon_40px.png';

  static const iconMissing = 'assets/image/icons/missing_icon.png';

  static const imageIndoorSet = 'assets/image/icons/icon_indoor_set.png';
  static const imageOutdoorSet = 'assets/image/icons/icon_outdoor_set.png';

  static const spincrystal = 'assets/image/illustrations/spincrystal.png';
  static const fischlEmote = 'assets/image/illustrations/fischl.webp';
  static const imagePrimogem = 'assets/image/icons/3.0x/primogem.png';
  static const atkIcon = 'assets/image/weapon_stat/atk.png';
  static const imageXp = 'assets/image/icons/Companion_xp.png';

  static const menuArtifacts = 'assets/image/icons/menu_icon_artifacts.png';
  static const menuInventory = 'assets/image/icons/menu_icon_bag.png';
  static const menuWish = 'assets/image/icons/menu_icon_wish.png';
  static const menuRecipes = 'assets/image/icons/menu_icon_recipes.png';
  static const menuMaterials = 'assets/image/icons/menu_icon_materials.png';
  static const menuWeapons = 'assets/image/icons/menu_icon_weapons.png';
  static const menuPot = 'assets/image/icons/menu_icon_serenitea_sets.png';
  static const menuQuest = 'assets/image/icons/menu_icon_quest.png';
  static const menuReputation = 'assets/image/icons/menu_icon_reputation.png';
  static const menuCharacters = 'assets/image/icons/menu_icon_characters.png';
  static const menuBook = 'assets/image/icons/menu_icon_book.webp';
  static const menuArchive = 'assets/image/icons/menu_icon_archive.webp';
  static const menuAchvmnt = 'assets/image/icons/menu_icon_achievements.webp';
  static const menuFeedback = 'assets/image/icons/menu_icon_feedback.webp';
  static const menuMap = 'assets/image/icons/menu_icon_map.webp';
  static const menuEchos = 'assets/image/icons/menu_envisaged_echoes.webp';
  static const menuEvent = 'assets/image/icons/menu_icon_event.webp';

  static String iconSetType(GeSereniteaSetType type) {
    return switch (type) {
      GeSereniteaSetType.none => iconMissing,
      GeSereniteaSetType.indoor => imageIndoorSet,
      GeSereniteaSetType.outdoor => imageOutdoorSet,
    };
  }

  static String iconNamecardType(GeNamecardType type) {
    return switch (type) {
      GeNamecardType.none => iconMissing,
      GeNamecardType.defaults => menuWish,
      GeNamecardType.achievement => menuAchvmnt,
      GeNamecardType.battlepass => menuWeapons,
      GeNamecardType.character => menuCharacters,
      GeNamecardType.event => menuFeedback,
      GeNamecardType.offering => menuQuest,
      GeNamecardType.reputation => menuReputation,
    };
  }

  static String iconRegionType(GeRegionType type) {
    return switch (type) {
      GeRegionType.none => iconMissing,
      GeRegionType.mondstadt => 'assets/image/regions/Mondstadt.png',
      GeRegionType.liyue => 'assets/image/regions/Liyue.png',
      GeRegionType.inazuma => 'assets/image/regions/Inazuma.png',
      GeRegionType.sumeru => 'assets/image/regions/Sumeru.png',
      GeRegionType.fontaine => 'assets/image/regions/Fontaine.png',
      GeRegionType.natlan => 'assets/image/regions/Natlan.png',
      GeRegionType.snezhnaya => 'assets/image/regions/Unknown.png',
      GeRegionType.khaenriah => iconMissing,
    };
  }

  static String getRarityBgImage(int rarity) {
    return 'assets/image/rarity/Item_${rarity.clamp(1, 5).toInt()}_Star.png';
  }
}
