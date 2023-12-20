import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';

extension GsBannerTypeExt on GeBannerType {
  String getWonLabel(int rarity) {
    return this == GeBannerType.weapon && rarity == 5
        ? Labels.won7525
        : Labels.won5050;
  }

  String getLostLabel(int rarity) {
    return this == GeBannerType.weapon && rarity == 5
        ? Labels.lost7525
        : Labels.lost5050;
  }
}

extension GeWeaponTypeExt on GeWeaponType {
  String get label => switch (this) {
        GeWeaponType.bow => Labels.wpBow,
        GeWeaponType.sword => Labels.wpSword,
        GeWeaponType.polearm => Labels.wpPolearm,
        GeWeaponType.catalyst => Labels.wpCatalyst,
        GeWeaponType.claymore => Labels.wpClaymore,
      };

  String get assetPath => 'assets/image/weapon_type/$id.png';
}

extension GeWeekdayTypeExt on GeWeekdayType {
  String getLabel(BuildContext context) =>
      context.fromLabel('weekday_${index + 1}');
}

extension GeAchievementTypeExt on GeAchievementType {
  String get label => switch (this) {
        GeAchievementType.none => Labels.achTypeNone,
        GeAchievementType.boss => Labels.achTypeBoss,
        GeAchievementType.quest => Labels.achTypeQuest,
        GeAchievementType.commission => Labels.achTypeCommission,
        GeAchievementType.exploration => Labels.achTypeExploration,
      };
}

extension GeItemSourceTypeExt on GeItemSourceType {
  String get label => switch (this) {
        GeItemSourceType.shop => Labels.wsNone,
        GeItemSourceType.event => Labels.wsNone,
        GeItemSourceType.fishing => Labels.wsNone,
        GeItemSourceType.forging => Labels.wsNone,
        GeItemSourceType.battlepass => Labels.wsNone,
        GeItemSourceType.exploration => Labels.wsNone,
        GeItemSourceType.wishesStandard => Labels.wsNone,
        GeItemSourceType.wishesWeaponBanner => Labels.wsNone,
        GeItemSourceType.wishesCharacterBanner => Labels.wsNone,
      };
}

extension GeElementTypeExt on GeElementType {
  Color get color => switch (this) {
        GeElementType.anemo => const Color(0xFF33CCB3),
        GeElementType.geo => const Color(0xFFCFA726),
        GeElementType.electro => const Color(0xFFD376F0),
        GeElementType.dendro => const Color(0xFF77AD2D),
        GeElementType.hydro => const Color(0xFF1C72FD),
        GeElementType.pyro => const Color(0xFFE2311D),
        GeElementType.cryo => const Color(0xFF98C8E8),
      };

  String get label => switch (this) {
        GeElementType.anemo => Labels.elAnemo,
        GeElementType.geo => Labels.elGeo,
        GeElementType.electro => Labels.elElectro,
        GeElementType.dendro => Labels.elDendro,
        GeElementType.hydro => Labels.elHydro,
        GeElementType.pyro => Labels.elPyro,
        GeElementType.cryo => Labels.elCryo,
      };

  String get assetPath => 'assets/image/element/$id.png';
  String get assetBgPath => 'assets/image/backgrounds/$id.gif';
}

const _wp = 'assets/image/weapon_stat';
const _ep = 'assets/image/element';

extension GeCharacterAscStatTypeExt on GeCharacterAscStatType {
  String get label => switch (this) {
        GeCharacterAscStatType.anemoDmgBonus => Labels.wsAnemoDmg,
        GeCharacterAscStatType.geoDmgBonus => Labels.wsGeoBonus,
        GeCharacterAscStatType.electroDmgBonus => Labels.wsElectroBonus,
        GeCharacterAscStatType.dendroDmgBonus => Labels.wsDendroBonus,
        GeCharacterAscStatType.hydroDmgBonus => Labels.wsHydroBonus,
        GeCharacterAscStatType.pyroDmgBonus => Labels.wsPyroBonus,
        GeCharacterAscStatType.cryoDmgBonus => Labels.wsCryoBonus,
        GeCharacterAscStatType.hpPercent => Labels.wsHpPercent,
        GeCharacterAscStatType.atkPercent => Labels.wsAtkPercent,
        GeCharacterAscStatType.defPercent => Labels.wsDefPercent,
        GeCharacterAscStatType.critDmg => Labels.wsCritdmg,
        GeCharacterAscStatType.critRate => Labels.wsCritrate,
        GeCharacterAscStatType.healing => Labels.wsHealing,
        GeCharacterAscStatType.physicalDmg => Labels.wsPhysicaldmg,
        GeCharacterAscStatType.energyRecharge => Labels.wsEnergyrecharge,
        GeCharacterAscStatType.elementalMastery => Labels.wsElementalmastery,
      };

  String get assetPath => switch (this) {
        GeCharacterAscStatType.anemoDmgBonus => '$_ep/anemo.png',
        GeCharacterAscStatType.geoDmgBonus => '$_ep/geo.png',
        GeCharacterAscStatType.electroDmgBonus => '$_ep/electro.png',
        GeCharacterAscStatType.dendroDmgBonus => '$_ep/dendro.png',
        GeCharacterAscStatType.hydroDmgBonus => '$_ep/hydro.png',
        GeCharacterAscStatType.pyroDmgBonus => '$_ep/pyro.png',
        GeCharacterAscStatType.cryoDmgBonus => '$_ep/cryo.png',
        GeCharacterAscStatType.hpPercent => '$_wp/hpPercent.png',
        GeCharacterAscStatType.atkPercent => '$_wp/atkPercent.png',
        GeCharacterAscStatType.defPercent => '$_wp/defPercent.png',
        GeCharacterAscStatType.critDmg => '$_wp/critDmg.png',
        GeCharacterAscStatType.critRate => '$_wp/critRate.png',
        GeCharacterAscStatType.healing => '$_wp/healing.png',
        GeCharacterAscStatType.physicalDmg => '$_wp/physicalDmg.png',
        GeCharacterAscStatType.energyRecharge => '$_wp/energyRecharge.png',
        GeCharacterAscStatType.elementalMastery => '$_wp/elementalMastery.png',
      };
}

extension GeEnemyFamilyTypeExt on GeEnemyFamilyType {
  String get label => switch (this) {
        GeEnemyFamilyType.none => Labels.wsNone,
        GeEnemyFamilyType.elemetalLifeform => Labels.efElementalLifeform,
        GeEnemyFamilyType.hilichurl => Labels.efHilichurl,
        GeEnemyFamilyType.abyss => Labels.efAbyss,
        GeEnemyFamilyType.fatui => Labels.efFatui,
        GeEnemyFamilyType.automaton => Labels.efAutomaton,
        GeEnemyFamilyType.humanFaction => Labels.efHumanFaction,
        GeEnemyFamilyType.mysticalBeast => Labels.efMysticalBeast,
        GeEnemyFamilyType.weeklyBoss => Labels.efWeeklyBoss,
      };
}

extension GeRecipeTypeExt on GeRecipeType {
  String get label => switch (this) {
        GeRecipeType.event => Labels.recipeEvent,
        GeRecipeType.permanent => Labels.recipePermanent,
      };
}

extension GeSereniteaSetTypeExt on GeSereniteaSetType {
  Color get color => switch (this) {
        GeSereniteaSetType.indoor => const Color(0xFFA01F2E),
        GeSereniteaSetType.outdoor => const Color(0xFF303671),
      };

  String get label => switch (this) {
        GeSereniteaSetType.indoor => Labels.indoor,
        GeSereniteaSetType.outdoor => Labels.outdoor,
      };

  String get asset => switch (this) {
        GeSereniteaSetType.indoor => imageIndoorSet,
        GeSereniteaSetType.outdoor => imageOutdoorSet,
      };
}

extension GeMaterialTypeExt on GeMaterialType {
  String get label => switch (this) {
        GeMaterialType.none => Labels.wsNone,
        GeMaterialType.ascensionGems => Labels.matAscensionGems,
        GeMaterialType.normalBossDrops => Labels.matNormalBossDrops,
        GeMaterialType.normalDrops => Labels.matNormalDrops,
        GeMaterialType.eliteDrops => Labels.matEliteDrops,
        GeMaterialType.forging => Labels.matForging,
        GeMaterialType.furnishing => Labels.matFurnishing,
        GeMaterialType.weeklyBossDrops => Labels.matWeeklyBossDrops,
        GeMaterialType.regionMaterials => Labels.matLocalSpecialties,
        GeMaterialType.weaponMaterials => Labels.matWeaponMaterials,
        GeMaterialType.talentMaterials => Labels.matTalentMaterials,
      };
}

extension GeNamecardTypeExt on GeNamecardType {
  String get label => switch (this) {
        GeNamecardType.defaults => Labels.namecardDefault,
        GeNamecardType.achievement => Labels.namecardAchievement,
        GeNamecardType.battlepass => Labels.namecardBattlepass,
        GeNamecardType.character => Labels.namecardCharacter,
        GeNamecardType.event => Labels.namecardEvent,
        GeNamecardType.offering => Labels.namecardOffering,
        GeNamecardType.reputation => Labels.namecardReputation,
      };

  String get asset => switch (this) {
        GeNamecardType.defaults => menuIconWish,
        GeNamecardType.achievement => menuIconAchievements,
        GeNamecardType.battlepass => menuIconWeapons,
        GeNamecardType.character => menuIconCharacters,
        GeNamecardType.event => menuIconFeedback,
        GeNamecardType.offering => menuIconQuest,
        GeNamecardType.reputation => menuIconReputation,
      };
}

extension GeRecipeEffectTypeExt on GeRecipeEffectType {
  String get label => switch (this) {
        GeRecipeEffectType.revive => Labels.rbRevive,
        GeRecipeEffectType.adventure => Labels.rbAdventure,
        GeRecipeEffectType.defBoost => Labels.rbDef,
        GeRecipeEffectType.atkBoost => Labels.rbAtk,
        GeRecipeEffectType.atkCritBoost => Labels.rbAtkCrit,
        GeRecipeEffectType.recoveryHP => Labels.rbHpRecovery,
        GeRecipeEffectType.recoveryHPAll => Labels.rbHpAllRecovery,
        GeRecipeEffectType.staminaReduction => Labels.rbStaminaReduction,
        GeRecipeEffectType.staminaIncrease => Labels.rbStaminaIncrease,
      };

  String get assetPath => 'assets/image/recipe_buff/$id.png';
}

extension GeWeaponAscStatTypeExt on GeWeaponAscStatType {
  String get label => switch (this) {
        GeWeaponAscStatType.none => Labels.wsNone,
        GeWeaponAscStatType.critDmg => Labels.wsCritdmg,
        GeWeaponAscStatType.critRate => Labels.wsCritrate,
        GeWeaponAscStatType.physicalDmg => Labels.wsPhysicaldmg,
        GeWeaponAscStatType.elementalMastery => Labels.wsElementalmastery,
        GeWeaponAscStatType.energyRecharge => Labels.wsEnergyrecharge,
        GeWeaponAscStatType.hpPercent => Labels.wsHpPercent,
        GeWeaponAscStatType.atkPercent => Labels.wsAtkPercent,
        GeWeaponAscStatType.defPercent => Labels.wsDefPercent,
      };

  String get assetPath => switch (this) {
        GeWeaponAscStatType.none => '',
        GeWeaponAscStatType.critDmg => '$_wp/critDmg.png',
        GeWeaponAscStatType.critRate => '$_wp/critRate.png',
        GeWeaponAscStatType.physicalDmg => '$_wp/physicalDmg.png',
        GeWeaponAscStatType.elementalMastery => '$_wp/elementalMastery.png',
        GeWeaponAscStatType.energyRecharge => '$_wp/energyRecharge.png',
        GeWeaponAscStatType.hpPercent => '$_wp/hpPercent.png',
        GeWeaponAscStatType.atkPercent => '$_wp/atkPercent.png',
        GeWeaponAscStatType.defPercent => '$_wp/defPercent.png',
      };

  String toIntOrPercentage(double value, {bool format = true}) {
    final percentage = GeWeaponAscStatType.values.except({
      GeWeaponAscStatType.none,
      GeWeaponAscStatType.elementalMastery,
    });

    late final dc = value.toStringAsFixed(1).split('.').last;
    final str = format
        ? '${value.toInt().format()}${dc != '0' ? '.$dc' : ''}'
        : value.toStringAsFixed(value == value.toInt() ? 0 : 1);
    return !percentage.contains(this) ? str : '$str%';
  }

  static Set<GeWeaponAscStatType> get weaponStats {
    return {
      GeWeaponAscStatType.none,
      GeWeaponAscStatType.hpPercent,
      GeWeaponAscStatType.atkPercent,
      GeWeaponAscStatType.defPercent,
      GeWeaponAscStatType.critDmg,
      GeWeaponAscStatType.critRate,
      GeWeaponAscStatType.physicalDmg,
      GeWeaponAscStatType.energyRecharge,
      GeWeaponAscStatType.elementalMastery,
    };
  }
}

extension GeRegionTypeExt on GeRegionType {
  String get label => switch (this) {
        GeRegionType.none => Labels.regionNone,
        GeRegionType.mondstadt => Labels.regionMondstadt,
        GeRegionType.liyue => Labels.regionLiyue,
        GeRegionType.inazuma => Labels.regionInazuma,
        GeRegionType.sumeru => Labels.regionSumeru,
        GeRegionType.fontaine => Labels.regionFontaine,
        GeRegionType.natlan => Labels.regionNatlan,
        GeRegionType.snezhnaya => Labels.regionSnezhnaya,
        GeRegionType.khaenriah => Labels.regionKhaenriah,
      };
}

extension GeEnemyTypeExt on GeEnemyType {
  String get label => switch (this) {
        GeEnemyType.none => Labels.wsNone,
        GeEnemyType.common => Labels.etCommon,
        GeEnemyType.elite => Labels.etElite,
        GeEnemyType.normalBoss => Labels.etNormalBoss,
        GeEnemyType.weeklyBoss => Labels.etWeeklyBoss,
      };
}
