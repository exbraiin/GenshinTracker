import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';

const _wp = 'assets/image/weapon_stat';
const _ep = 'assets/image/element';

extension GsBannerTypeExt on GeBannerType {
  String getWonLabel(BuildContext ctx, int rarity) {
    return this == GeBannerType.weapon && rarity == 5
        ? ctx.labels.won7525()
        : ctx.labels.won5050();
  }

  String getLostLabel(BuildContext ctx, int rarity) {
    return this == GeBannerType.weapon && rarity == 5
        ? ctx.labels.lost7525()
        : ctx.labels.lost5050();
  }
}

extension GeWeaponTypeExt on GeWeaponType {
  String label(BuildContext ctx) {
    return switch (this) {
      GeWeaponType.none => ctx.labels.wsNone(),
      GeWeaponType.bow => ctx.labels.wpBow(),
      GeWeaponType.sword => ctx.labels.wpSword(),
      GeWeaponType.polearm => ctx.labels.wpPolearm(),
      GeWeaponType.catalyst => ctx.labels.wpCatalyst(),
      GeWeaponType.claymore => ctx.labels.wpClaymore(),
    };
  }

  String get assetPath => 'assets/image/weapon_type/$id.png';
}

extension GeWeekdayTypeExt on GeWeekdayType {
  String getLabel(BuildContext ctx) {
    return switch (this) {
      GeWeekdayType.sunday => ctx.labels.weekday7(),
      GeWeekdayType.monday => ctx.labels.weekday1(),
      GeWeekdayType.tuesday => ctx.labels.weekday2(),
      GeWeekdayType.wednesday => ctx.labels.weekday3(),
      GeWeekdayType.thursday => ctx.labels.weekday4(),
      GeWeekdayType.friday => ctx.labels.weekday5(),
      GeWeekdayType.saturday => ctx.labels.weekday6(),
    };
  }
}

extension GeAchievementTypeExt on GeAchievementType {
  String label(BuildContext ctx) {
    return switch (this) {
      GeAchievementType.none => ctx.labels.achTypeNone(),
      GeAchievementType.boss => ctx.labels.achTypeBoss(),
      GeAchievementType.quest => ctx.labels.achTypeQuest(),
      GeAchievementType.commission => ctx.labels.achTypeCommission(),
      GeAchievementType.exploration => ctx.labels.achTypeExploration(),
    };
  }
}

extension GeItemSourceTypeExt on GeItemSourceType {
  String label(BuildContext ctx) {
    return switch (this) {
      GeItemSourceType.none => ctx.labels.wsNone(),
      GeItemSourceType.shop => ctx.labels.wsNone(),
      GeItemSourceType.event => ctx.labels.wsNone(),
      GeItemSourceType.fishing => ctx.labels.wsNone(),
      GeItemSourceType.forging => ctx.labels.wsNone(),
      GeItemSourceType.battlepass => ctx.labels.wsNone(),
      GeItemSourceType.exploration => ctx.labels.wsNone(),
      GeItemSourceType.wishesStandard => ctx.labels.wsNone(),
      GeItemSourceType.wishesWeaponBanner => ctx.labels.wsNone(),
      GeItemSourceType.wishesCharacterBanner => ctx.labels.wsNone(),
    };
  }
}

extension GeArkheTypeExt on GeArkheType {
  Color get color => switch (this) {
        GeArkheType.none => Colors.grey,
        GeArkheType.ousia => const Color(0xFF7F7EDB),
        GeArkheType.pneuma => const Color(0xFFE9DBA5),
        GeArkheType.both => const Color(0xFFB4ADC0),
      };

  String label(BuildContext ctx) {
    return switch (this) {
      GeArkheType.none => ctx.labels.wsNone(),
      GeArkheType.ousia => ctx.labels.arkheOusia(),
      GeArkheType.pneuma => ctx.labels.arkhePneuma(),
      GeArkheType.both => ctx.labels.arkheBoth(),
    };
  }
}

extension GeElementTypeExt on GeElementType {
  Color get color => switch (this) {
        GeElementType.none => Colors.grey,
        GeElementType.anemo => const Color(0xFF33CCB3),
        GeElementType.geo => const Color(0xFFCFA726),
        GeElementType.electro => const Color(0xFFD376F0),
        GeElementType.dendro => const Color(0xFF77AD2D),
        GeElementType.hydro => const Color(0xFF1C72FD),
        GeElementType.pyro => const Color(0xFFE2311D),
        GeElementType.cryo => const Color(0xFF98C8E8),
      };

  String label(BuildContext ctx) {
    return switch (this) {
      GeElementType.none => ctx.labels.wsNone(),
      GeElementType.anemo => ctx.labels.elAnemo(),
      GeElementType.geo => ctx.labels.elGeo(),
      GeElementType.electro => ctx.labels.elElectro(),
      GeElementType.dendro => ctx.labels.elDendro(),
      GeElementType.hydro => ctx.labels.elHydro(),
      GeElementType.pyro => ctx.labels.elPyro(),
      GeElementType.cryo => ctx.labels.elCryo(),
    };
  }

  String get assetPath => 'assets/image/element/$id.png';
  String get assetBgPath => 'assets/image/backgrounds/$id.gif';
}

extension GeCharacterAscStatTypeExt on GeCharacterAscStatType {
  String label(BuildContext ctx) {
    return switch (this) {
      GeCharacterAscStatType.none => ctx.labels.wsNone(),
      GeCharacterAscStatType.anemoDmgBonus => ctx.labels.wsAnemoDmg(),
      GeCharacterAscStatType.geoDmgBonus => ctx.labels.wsGeoBonus(),
      GeCharacterAscStatType.electroDmgBonus => ctx.labels.wsElectroBonus(),
      GeCharacterAscStatType.dendroDmgBonus => ctx.labels.wsDendroBonus(),
      GeCharacterAscStatType.hydroDmgBonus => ctx.labels.wsHydroBonus(),
      GeCharacterAscStatType.pyroDmgBonus => ctx.labels.wsPyroBonus(),
      GeCharacterAscStatType.cryoDmgBonus => ctx.labels.wsCryoBonus(),
      GeCharacterAscStatType.hpPercent => ctx.labels.wsHpPercent(),
      GeCharacterAscStatType.atkPercent => ctx.labels.wsAtkPercent(),
      GeCharacterAscStatType.defPercent => ctx.labels.wsDefPercent(),
      GeCharacterAscStatType.critDmg => ctx.labels.wsCritdmg(),
      GeCharacterAscStatType.critRate => ctx.labels.wsCritrate(),
      GeCharacterAscStatType.healing => ctx.labels.wsHealing(),
      GeCharacterAscStatType.physicalDmg => ctx.labels.wsPhysicaldmg(),
      GeCharacterAscStatType.energyRecharge => ctx.labels.wsEnergyrecharge(),
      GeCharacterAscStatType.elementalMastery =>
        ctx.labels.wsElementalmastery(),
    };
  }

  String get assetPath => switch (this) {
        GeCharacterAscStatType.none => iconMissing,
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
  String label(BuildContext ctx) {
    return switch (this) {
      GeEnemyFamilyType.none => ctx.labels.wsNone(),
      GeEnemyFamilyType.elemetalLifeform => ctx.labels.efElementalLifeform(),
      GeEnemyFamilyType.hilichurl => ctx.labels.efHilichurl(),
      GeEnemyFamilyType.abyss => ctx.labels.efAbyss(),
      GeEnemyFamilyType.fatui => ctx.labels.efFatui(),
      GeEnemyFamilyType.automaton => ctx.labels.efAutomaton(),
      GeEnemyFamilyType.humanFaction => ctx.labels.efHumanFaction(),
      GeEnemyFamilyType.mysticalBeast => ctx.labels.efMysticalBeast(),
      GeEnemyFamilyType.weeklyBoss => ctx.labels.efWeeklyBoss(),
    };
  }
}

extension GeEventTypeExt on GeEventType {
  String label(BuildContext ctx) {
    return switch (this) {
      GeEventType.none => ctx.labels.wsNone(),
      GeEventType.quest => ctx.labels.eventQuest(),
      GeEventType.event => ctx.labels.eventNormal(),
      GeEventType.login => ctx.labels.eventLogin(),
      GeEventType.flagship => ctx.labels.eventFlagship(),
      GeEventType.permanent => ctx.labels.eventPermanent(),
    };
  }
}

extension GeRecipeTypeExt on GeRecipeType {
  String label(BuildContext ctx) {
    return switch (this) {
      GeRecipeType.none => ctx.labels.wsNone(),
      GeRecipeType.event => ctx.labels.recipeEvent(),
      GeRecipeType.permanent => ctx.labels.recipePermanent(),
    };
  }
}

extension GeSereniteaSetTypeExt on GeSereniteaSetType {
  Color get color => switch (this) {
        GeSereniteaSetType.none => Colors.grey,
        GeSereniteaSetType.indoor => const Color(0xFFA01F2E),
        GeSereniteaSetType.outdoor => const Color(0xFF303671),
      };

  String label(BuildContext ctx) {
    return switch (this) {
      GeSereniteaSetType.none => ctx.labels.wsNone(),
      GeSereniteaSetType.indoor => ctx.labels.indoor(),
      GeSereniteaSetType.outdoor => ctx.labels.outdoor(),
    };
  }

  String get asset => switch (this) {
        GeSereniteaSetType.none => iconMissing,
        GeSereniteaSetType.indoor => imageIndoorSet,
        GeSereniteaSetType.outdoor => imageOutdoorSet,
      };
}

extension GeMaterialTypeExt on GeMaterialType {
  String label(BuildContext ctx) {
    return switch (this) {
      GeMaterialType.none => ctx.labels.wsNone(),
      GeMaterialType.oculi => ctx.labels.matOculi(),
      GeMaterialType.ascensionGems => ctx.labels.matAscensionGems(),
      GeMaterialType.normalBossDrops => ctx.labels.matNormalBossDrops(),
      GeMaterialType.normalDrops => ctx.labels.matNormalDrops(),
      GeMaterialType.eliteDrops => ctx.labels.matEliteDrops(),
      GeMaterialType.forging => ctx.labels.matForging(),
      GeMaterialType.furnishing => ctx.labels.matFurnishing(),
      GeMaterialType.weeklyBossDrops => ctx.labels.matWeeklyBossDrops(),
      GeMaterialType.regionMaterials => ctx.labels.matLocalSpecialties(),
      GeMaterialType.weaponMaterials => ctx.labels.matWeaponMaterials(),
      GeMaterialType.talentMaterials => ctx.labels.matTalentMaterials(),
    };
  }
}

extension GeNamecardTypeExt on GeNamecardType {
  String label(BuildContext ctx) {
    return switch (this) {
      GeNamecardType.none => ctx.labels.wsNone(),
      GeNamecardType.defaults => ctx.labels.namecardDefault(),
      GeNamecardType.achievement => ctx.labels.namecardAchievement(),
      GeNamecardType.battlepass => ctx.labels.namecardBattlepass(),
      GeNamecardType.character => ctx.labels.namecardCharacter(),
      GeNamecardType.event => ctx.labels.namecardEvent(),
      GeNamecardType.offering => ctx.labels.namecardOffering(),
      GeNamecardType.reputation => ctx.labels.namecardReputation(),
    };
  }

  String get asset => switch (this) {
        GeNamecardType.none => iconMissing,
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
  String label(BuildContext ctx) {
    return switch (this) {
      GeRecipeEffectType.none => ctx.labels.wsNone(),
      GeRecipeEffectType.revive => ctx.labels.rbRevive(),
      GeRecipeEffectType.adventure => ctx.labels.rbAdventure(),
      GeRecipeEffectType.defBoost => ctx.labels.rbDef(),
      GeRecipeEffectType.atkBoost => ctx.labels.rbAtk(),
      GeRecipeEffectType.atkCritBoost => ctx.labels.rbAtkCrit(),
      GeRecipeEffectType.recoveryHP => ctx.labels.rbHpRecovery(),
      GeRecipeEffectType.recoveryHPAll => ctx.labels.rbHpAllRecovery(),
      GeRecipeEffectType.staminaReduction => ctx.labels.rbStaminaReduction(),
      GeRecipeEffectType.staminaIncrease => ctx.labels.rbStaminaIncrease(),
      GeRecipeEffectType.special => ctx.labels.rbSpecial(),
    };
  }

  String get assetPath => 'assets/image/recipe_buff/$id.png';
}

extension GeWeaponAscStatTypeExt on GeWeaponAscStatType {
  String label(BuildContext ctx) {
    return switch (this) {
      GeWeaponAscStatType.none => ctx.labels.wsNone(),
      GeWeaponAscStatType.critDmg => ctx.labels.wsCritdmg(),
      GeWeaponAscStatType.critRate => ctx.labels.wsCritrate(),
      GeWeaponAscStatType.physicalDmg => ctx.labels.wsPhysicaldmg(),
      GeWeaponAscStatType.elementalMastery => ctx.labels.wsElementalmastery(),
      GeWeaponAscStatType.energyRecharge => ctx.labels.wsEnergyrecharge(),
      GeWeaponAscStatType.hpPercent => ctx.labels.wsHpPercent(),
      GeWeaponAscStatType.atkPercent => ctx.labels.wsAtkPercent(),
      GeWeaponAscStatType.defPercent => ctx.labels.wsDefPercent(),
    };
  }

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
}

extension GeRegionTypeExt on GeRegionType {
  String label(BuildContext ctx) {
    return switch (this) {
      GeRegionType.none => ctx.labels.regionNone(),
      GeRegionType.mondstadt => ctx.labels.regionMondstadt(),
      GeRegionType.liyue => ctx.labels.regionLiyue(),
      GeRegionType.inazuma => ctx.labels.regionInazuma(),
      GeRegionType.sumeru => ctx.labels.regionSumeru(),
      GeRegionType.fontaine => ctx.labels.regionFontaine(),
      GeRegionType.natlan => ctx.labels.regionNatlan(),
      GeRegionType.snezhnaya => ctx.labels.regionSnezhnaya(),
      GeRegionType.khaenriah => ctx.labels.regionKhaenriah(),
    };
  }
}

extension GeEnemyTypeExt on GeEnemyType {
  String label(BuildContext ctx) {
    return switch (this) {
      GeEnemyType.none => ctx.labels.wsNone(),
      GeEnemyType.common => ctx.labels.etCommon(),
      GeEnemyType.elite => ctx.labels.etElite(),
      GeEnemyType.normalBoss => ctx.labels.etNormalBoss(),
      GeEnemyType.weeklyBoss => ctx.labels.etWeeklyBoss(),
    };
  }
}

extension GeCharTalentTypeExt on GeCharTalentType {
  String label(BuildContext ctx) {
    return switch (this) {
      GeCharTalentType.normalAttack => ctx.labels.charTalNa(),
      GeCharTalentType.elementalSkill => ctx.labels.charTalEs(),
      GeCharTalentType.elementalBurst => ctx.labels.charTalEb(),
      GeCharTalentType.alternateSprint => ctx.labels.charTalAs(),
      GeCharTalentType.ascension1stPassive => ctx.labels.charTal1a(),
      GeCharTalentType.ascension4thPassive => ctx.labels.charTal4a(),
      GeCharTalentType.nightRealmPassive => ctx.labels.charTalNr(),
      GeCharTalentType.utilityPassive => ctx.labels.charTalUp(),
    };
  }
}
