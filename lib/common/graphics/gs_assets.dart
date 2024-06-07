import 'package:flutter/material.dart';

const imageAppIcon = 'assets/image/icons/app_icon.png';
const imageAppIconSmall = 'assets/image/icons/app_icon_40px.png';

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
const menuIconEnemies = 'assets/image/icons/menu_icon_enemies.webp';
const menuIconEvent = 'assets/image/icons/menu_icon_event.webp';
const iconMissing = 'assets/image/icons/missing_icon.png';

const imagePrimogem = 'assets/image/icons/3.0x/primogem.png';
const imageXp = 'assets/image/icons/Companion_xp.png';

const spincrystalAsset = 'assets/image/illustrations/spincrystal.png';
const fischlEmote = 'assets/image/illustrations/fischl.webp';

const atkIcon = 'assets/image/weapon_stat/atk.png';

const kMainBgDecoration = BoxDecoration();

String getRarityBgImage(int rarity) =>
    'assets/image/rarity/Item_${rarity.clamp(1, 5).toInt()}_Star.png';
