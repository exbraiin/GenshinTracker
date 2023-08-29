import 'package:dartx/dartx_io.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/domain/enums/gs_weekday.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

/// {@template db_update}
/// Updates db collection
/// {@endtemplate}
final _db = GsDatabase.instance;

class GsUtils {
  GsUtils._();

  static final items = _Items();
  static final cities = _Cities();
  static final wishes = _Wishes();
  static final recipes = _Recipes();
  static final weapons = _Weapons();
  static final versions = _Versions();
  static final materials = _Materials();
  static final characters = _Characters();
  static final achievements = _Achievements();
  static final spincrystals = _Spincrystals();
  static final playerConfigs = _PlayerConfigs();
  static final sereniteaSets = _SereniteaSets();
  static final weaponMaterials = _WeaponMaterials();
  static final remarkableChests = _RemarkableChests();
  static final characterMaterials = _CharactersMaterials();
}

enum WishState { none, won, lost, guaranteed }

class _Items {
  /// Gets a weapon or a character by the given [id].
  ItemData getItemData(String id) {
    return _db.infoWeapons.exists(id)
        ? ItemData.weapon(_db.infoWeapons.getItem(id))
        : ItemData.character(_db.infoCharacters.getItem(id));
  }

  Map<InfoMaterial, List<ItemData>> getItemsByMaterial(GsWeekday weekday) {
    final getMat = _db.infoMaterials.getItem;

    return [
      ..._db.infoCharactersInfo
          .getItems()
          .map((element) => MapEntry(element.id, element.ascension.matTalent)),
      ..._db.infoWeaponsInfo
          .getItems()
          .map((element) => MapEntry(element.id, element.matWeapon)),
    ]
        .groupBy((element) => element.value)
        .entries
        .where((element) => getMat(element.key).weekdays.contains(weekday))
        .toMap(
          (e) => _db.infoMaterials.getItem(e.key),
          (e) => e.value.map((e) => getItemData(e.key)).toList(),
        );
  }
}

class _Cities {
  /// Gets the city max level
  int getCityMaxLevel(String id) =>
      _db.infoCities.getItem(id).reputation.length;

  /// Gets the user saved city current level.
  int getCityLevel(String id) {
    final cities = GsDatabase.instance.infoCities;
    final sRp = getSavedReputation(id);
    return cities.getItem(id).reputation.lastIndexWhere((e) => e <= sRp) + 1;
  }

  /// Gets the previous level max xp value.
  int getCityPreviousXpValue(String id) {
    final cities = GsDatabase.instance.infoCities;
    final sRP = getSavedReputation(id);
    final rep = cities.getItem(id).reputation;
    return rep.lastWhere((e) => e <= sRP, orElse: () => 0);
  }

  /// Gets the current level max xp value.
  int getCityNextXpValue(String id) {
    final cities = GsDatabase.instance.infoCities;
    final sRP = getSavedReputation(id);
    final rep = cities.getItem(id).reputation;
    return rep.firstWhere((e) => e > sRP, orElse: () => -1);
  }

  /// Gets the amount of weeks required to reach the next level based on bounties and quests.
  int getCityNextLevelWeeks(String id) {
    final cities = GsDatabase.instance.infoCities;
    final sRp = getSavedReputation(id);
    final rep = cities.getItem(id).reputation;
    final idx = rep.lastIndexWhere((e) => e <= sRp);
    final next = idx + 1 < rep.length ? rep[idx + 1] : rep.last;
    final xp = next - sRp;
    return (xp / GsDomain.cityXpPerWeek).ceil().coerceAtLeast(0);
  }

  /// Gets the amount of weeks required to reach the max level based on bounties and quests.
  int getCityMaxLevelWeeks(String id) {
    final cities = GsDatabase.instance.infoCities;
    final rep = cities.getItem(id).reputation;
    final xp = rep.last - getSavedReputation(id);
    return (xp / GsDomain.cityXpPerWeek).ceil().coerceAtLeast(0);
  }

  /// Gets the user saved reputation xp
  int getSavedReputation(String id) =>
      _db.saveReputations.getItemOrNull(id)?.reputation ?? 0;

  /// Sets the user saved reputation xp
  ///
  /// {@macro db_update}
  void updateReputation(String id, int reputation) {
    _db.saveReputations
        .insertItem(SaveReputation(id: id, reputation: reputation));
  }
}

class _Wishes {
  /// Gets all released banners by [type]
  List<InfoBanner> geReleasedInfoBannerByType(GsBanner type) {
    final now = DateTime.now();
    final banners = _db.infoBanners;
    return banners
        .getItems()
        .where((e) => e.type == type && e.dateStart.isBefore(now))
        .toList();
  }

  /// Gets the pity of the given wish in the given wishes list.
  int countPity(List<SaveWish> wishes, SaveWish wish) {
    final item = GsUtils.items.getItemData(wish.itemId);
    final rarity = item.rarity;
    if (rarity < 4) return 1;
    final getItem = GsUtils.items.getItemData;
    final list = wishes.skipWhile((value) => value != wish).skip(1).toList();
    final last = list.indexWhere((e) => getItem(e.itemId).rarity == rarity);
    return last != -1 ? (last + 1).coerceAtLeast(1) : list.length + 1;
  }

  SaveWish? _getLastWish(Iterable<SaveWish> wishes, [int rarity = 5]) {
    final getItem = GsUtils.items.getItemData;
    return wishes.firstOrNullWhere((e) => getItem(e.itemId).rarity == rarity);
  }

  /// Checks if the next wish is a guaranteed one in the given wishes list.
  bool isNextGaranteed(List<SaveWish> wishes) {
    final last = _getLastWish(wishes);
    if (last == null) return false;
    final banner = _db.infoBanners.getItem(last.bannerId);
    return !banner.feature5.contains(last.itemId);
  }

  /// Gets the wish state.
  WishState getWishState(List<SaveWish> wishes, SaveWish wish) {
    final item = GsUtils.items.getItemData(wish.itemId);
    final rt = item.rarity;
    if (rt != 5 && rt != 4) return WishState.none;

    late final banner = _db.infoBanners.getItem(wish.bannerId);
    late final featured = rt == 5 ? banner.feature5 : banner.feature4;
    late final contained = featured.contains(wish.itemId);

    wishes = wishes.skipWhile((value) => value != wish).skip(1).toList();
    final lastWish = _getLastWish(wishes, rt);
    if (lastWish == null) return contained ? WishState.won : WishState.lost;

    final lastBanner = _db.infoBanners.getItem(lastWish.bannerId);
    final lastFeatured = rt == 5 ? lastBanner.feature5 : lastBanner.feature4;
    final lastBannerContains = lastFeatured.contains(lastWish.itemId);

    if (lastBannerContains && contained) return WishState.won;
    if (lastBannerContains && !contained) return WishState.lost;
    if (!lastBannerContains && contained) return WishState.guaranteed;
    return WishState.none;
  }

  /// Gets a list of [ItemData] that can be obtained in banners.
  Iterable<ItemData> getBannerItemsData(InfoBanner banner) {
    bool filterWp(InfoWeapon info) {
      late final isStandard = info.source == GsItemSource.wishesStandard;
      late final isFeatured = banner.feature5.contains(info.id);
      late final isChar = banner.type == GsBanner.character && info.rarity == 5;
      late final isBegn = banner.type == GsBanner.beginner && info.rarity > 3;
      return (isStandard || isFeatured) && !isChar && !isBegn;
    }

    bool filterCh(InfoCharacter info) {
      late final isStandard = info.source == GsItemSource.wishesStandard;
      late final isFeatured = banner.feature5.contains(info.id);
      late final isWeap = banner.type == GsBanner.weapon && info.rarity == 5;
      return (isStandard || isFeatured) && !isWeap;
    }

    return [
      ..._db.infoWeapons.getItems().where(filterWp).map(ItemData.weapon),
      ..._db.infoCharacters.getItems().where(filterCh).map(ItemData.character),
    ];
  }

  /// Gets all wishes for the given [banner].
  List<SaveWish> getBannerWishes(String banner) =>
      _db.saveWishes.getItems().where((e) => e.bannerId == banner).toList();

  /// Gets all saved wishes for a banner [type].
  List<SaveWish> getSaveWishesByBannerType(GsBanner type) {
    final banners = GsUtils.wishes.geReleasedInfoBannerByType(type);
    final bannerIds = banners.map((e) => e.id);
    return _db.saveWishes
        .getItems()
        .where((e) => bannerIds.contains(e.bannerId))
        .toList();
  }

  /// Whether the [banner] has wishes.
  bool bannerHasWishes(String banner) =>
      _db.saveWishes.getItems().any((e) => e.bannerId == banner);

  /// Counts the [banner] wishes.
  int countBannerWishes(String banner) =>
      _db.saveWishes.getItems().count((e) => e.bannerId == banner);

  /// Counts the obtained amount of [itemId].
  int countItem(String itemId) =>
      _db.saveWishes.getItems().count((e) => e.itemId == itemId);

  /// Whether the [itemId] was obtained.
  bool hasItem(String itemId) =>
      _db.saveWishes.getItems().any((e) => e.itemId == itemId);

  /// Removes the [bannerId] last wish
  ///
  /// {@macro db_update}
  void removeLastWish(String bannerId) {
    final db = GsDatabase.instance.saveWishes;
    final list = GsUtils.wishes.getBannerWishes(bannerId);
    if (list.isEmpty) return;
    db.deleteItem(list.sorted().last.id);
  }

  /// Updates the given [wish] date.
  ///
  /// {@macro db_update}
  void updateWishDate(SaveWish wish, DateTime date) {
    final db = GsDatabase.instance.saveWishes;
    if (!db.exists(wish.id)) return;
    final newWish = wish.copyWith(date: date);
    db.insertItem(newWish);
  }

  /// Adds the items with the given [ids] to the given [bannerId].
  ///
  /// {@macro db_update}
  void addWishes({
    required Iterable<String> ids,
    required DateTime date,
    required String bannerId,
  }) async {
    final db = GsDatabase.instance.saveWishes;
    final type = GsDatabase.instance.infoBanners.getItem(bannerId).type;
    final lastRoll = GsUtils.wishes.countBannerWishes(bannerId);
    final wishes = GsUtils.wishes.getSaveWishesByBannerType(type);
    final sorted = wishes.sortedDescending();

    final getItem = GsUtils.items.getItemData;
    var w4 = sorted.takeWhile((e) => getItem(e.itemId).rarity != 4).length;
    var w5 = sorted.takeWhile((e) => getItem(e.itemId).rarity != 5).length;

    var i = 0;
    for (var id in ids) {
      final item = getItem(id);
      final number = lastRoll + 1 + i++;

      w4++;
      w5++;
      var pity = 1;
      if (item.rarity == 4) {
        pity = w4;
        w4 = 0;
      } else if (item.rarity == 5) {
        pity = w5;
        w5 = 0;
      }

      final wish = SaveWish(
        id: '${bannerId}_$number',
        pity: pity,
        date: date,
        itemId: id,
        number: number,
        bannerId: bannerId,
      );
      db.insertItem(wish);
    }
  }
}

class _Recipes {
  /// Updates the recipe as [own] or the recipe [proficiency].
  ///
  /// {@macro db_update}
  void update(
    String id, {
    bool? own,
    int? proficiency,
  }) {
    if (own != null) {
      final contains = _db.saveRecipes.exists(id);
      if (own && !contains) {
        _db.saveRecipes.insertItem(SaveRecipe(id: id, proficiency: 0));
      } else if (!own && contains) {
        _db.saveRecipes.deleteItem(id);
      }
    }

    if (proficiency != null) {
      _db.saveRecipes.insertItem(SaveRecipe(id: id, proficiency: proficiency));
    }
  }
}

class _Weapons {
  bool hasWeapon(String id) {
    return _db.saveWishes.getItems().any((e) => e.itemId == id);
  }
}

class _Versions {
  bool isCurrentVersion(String version) {
    final now = DateTime.now();
    final versions = _db.infoVersion.getItems();
    final current = versions
        .sorted()
        .lastOrNullWhere((element) => !element.releaseDate.isAfter(now));
    return current?.id == version;
  }

  bool isUpcomingVersion(String version) {
    final now = DateTime.now();
    final versions = _db.infoVersion.getItems();
    final upcoming = versions.sorted().where((e) => e.releaseDate.isAfter(now));
    return upcoming.any((element) => element.id == version);
  }

  InfoVersion? getCurrentVersion() {
    final now = DateTime.now();
    final versions = _db.infoVersion.getItems();
    final current = versions
        .sorted()
        .lastOrNullWhere((element) => !element.releaseDate.isAfter(now));
    return current;
  }
}

class _Materials {
  Iterable<InfoMaterial> getGroupMaterials(InfoMaterial material) {
    return _db.infoMaterials.getItems().where((element) {
      return element.group == material.group &&
          element.region == material.region &&
          element.subgroup == material.subgroup;
    });
  }

  Iterable<InfoMaterial> getGroupMaterialsById(String id) {
    final material = _db.infoMaterials.getItemOrNull(id);
    if (material == null) return [];
    return getGroupMaterials(material);
  }
}

class _Characters {
  /// Whether the user has this character or not.
  bool hasCaracter(String id) {
    final owned = _db.saveCharacters.getItemOrNull(id)?.owned ?? 0;
    return owned > 0 || _db.saveWishes.getItems().any((e) => e.itemId == id);
  }

  /// Whether the character with the given [id] has outfits or not.
  bool hasOutfits(String id) {
    return _db.infoCharactersOutfit
        .getItems()
        .any((element) => element.character == id);
  }

  int getCharFriendship(String id) {
    final char = _db.saveCharacters.getItemOrNull(id);
    return char?.friendship.coerceAtLeast(1) ?? 1;
  }

  /// Gets the character ascension level.
  int getCharAscension(String id) {
    final char = _db.saveCharacters.getItemOrNull(id);
    return char?.ascension ?? 0;
  }

  /// Whether the character is fully ascended or not.
  bool isCharMaxAscended(String id) {
    return !(getCharAscension(id) < 6);
  }

  /// Gets the character current constellations amount or null.
  int? getCharConstellations(String id) {
    return getTotalCharConstellations(id)?.clamp(0, 6);
  }

  /// Gets the character total constellations amount or null.
  int? getTotalCharConstellations(String id) {
    final char = _db.saveCharacters.getItemOrNull(id);
    final total = GsUtils.wishes.countItem(id);
    final sum = total + (char?.owned ?? 0);
    return sum > 0 ? (sum - 1) : null;
  }

  String getImage(String id) {
    final outfit = _db.saveCharacters.getItemOrNull(id)?.outfit ?? '';
    final url = _db.infoCharactersOutfit.getItemOrNull(outfit)?.image ?? '';
    late final charImg = _db.infoCharacters.getItemOrNull(id)?.image ?? '';
    return url.isNotEmpty ? url : charImg;
  }

  String getFullImage(String id) {
    final outfit = _db.saveCharacters.getItemOrNull(id)?.outfit ?? '';
    final url = _db.infoCharactersOutfit.getItemOrNull(outfit)?.fullImage ?? '';
    late final charImg = _db.infoCharacters.getItemOrNull(id)?.fullImage ?? '';
    return url.isNotEmpty ? url : charImg;
  }

  /// Sets the character outfit
  ///
  /// {@macro db_update}
  void setCharOutfit(String id, String outfit) {
    final char = _db.saveCharacters.getItemOrNull(id);
    final item = (char ?? SaveCharacter(id: id)).copyWith(outfit: outfit);
    if (item.outfit != char?.outfit) _db.saveCharacters.insertItem(item);
  }

  /// Sets the character friendship
  ///
  /// {@macro db_update}
  void setCharFriendship(String id, int friendship) {
    final char = _db.saveCharacters.getItemOrNull(id);
    final friend = friendship.clamp(1, 10);
    final item = (char ?? SaveCharacter(id: id)).copyWith(friendship: friend);
    if (item.friendship != char?.friendship) {
      _db.saveCharacters.insertItem(item);
    }
  }

  /// Increases the amount of owned characters
  ///
  /// {@macro db_update}
  void increaseOwnedCharacter(String id) {
    final char = _db.saveCharacters.getItemOrNull(id);
    final wishes = GsUtils.wishes.countItem(id);

    var cOwned = char?.owned ?? 0;
    cOwned = cOwned + 1 + wishes > 7 ? 0 : cOwned + 1;
    final item = (char ?? SaveCharacter(id: id)).copyWith(owned: cOwned);
    _db.saveCharacters.insertItem(item);
  }

  /// Increases the character friendship
  ///
  /// {@macro db_update}
  void increaseFriendshipCharacter(String id) {
    final char = _db.saveCharacters.getItemOrNull(id);
    var cFriendship = char?.friendship ?? 1;
    cFriendship = ((cFriendship + 1) % 11).coerceAtLeast(1);

    final item =
        (char ?? SaveCharacter(id: id)).copyWith(friendship: cFriendship);
    _db.saveCharacters.insertItem(item);
  }

  /// Increases the character ascension
  ///
  /// {@macro db_update}
  void increaseAscension(String id) {
    final char = _db.saveCharacters.getItemOrNull(id);
    var cAscension = char?.ascension ?? 0;
    cAscension = (cAscension + 1) % 7;
    final item =
        (char ?? SaveCharacter(id: id)).copyWith(ascension: cAscension);
    _db.saveCharacters.insertItem(item);
  }
}

class _Achievements {
  int countTotal([bool Function(InfoAchievement)? test]) {
    var items = _db.infoAchievements.getItems();
    if (test != null) items = items.where(test);
    return items.sumBy((e) => e.phases.length).toInt();
  }

  int countTotalRewards([bool Function(InfoAchievement)? test]) {
    var items = _db.infoAchievements.getItems();
    if (test != null) items = items.where(test);
    return items.sumBy((e) => e.phases.sumBy((e) => e.reward)).toInt();
  }

  /// Updates the achievement obtained phase
  ///
  /// {@macro db_update}
  void update(String id, {required int obtained}) {
    final saved = _db.saveAchievements.getItemOrNull(id)?.obtained ?? 0;
    if (saved >= obtained) obtained -= 1;
    if (obtained > 0) {
      final item = SaveAchievement(id: id, obtained: obtained);
      _db.saveAchievements.insertItem(item);
    } else {
      _db.saveAchievements.deleteItem(id);
    }
  }

  bool isObtainable(String id) {
    final saved = _db.saveAchievements.getItemOrNull(id);
    if (saved == null) return true;
    final item = _db.infoAchievements.getItemOrNull(id);
    return (item?.phases.length ?? 0) > saved.obtained;
  }

  int countSaved([bool Function(InfoAchievement)? test]) {
    var items = _db.infoAchievements.getItems();
    if (test != null) items = items.where(test);
    return items
        .sumBy((e) => _db.saveAchievements.getItemOrNull(e.id)?.obtained ?? 0)
        .toInt();
  }

  int countSavedRewards([bool Function(InfoAchievement)? test]) {
    var items = _db.infoAchievements.getItems();
    if (test != null) items = items.where(test);
    return items.sumBy((e) {
      final i = _db.saveAchievements.getItemOrNull(e.id)?.obtained ?? 0;
      return e.phases.take(i).sumBy((element) => element.reward);
    }).toInt();
  }
}

class _Spincrystals {
  /// Updates the spincrystal as owned or not.
  ///
  /// {@macro db_update}
  void update(int number, {required bool obtained}) {
    final id = number.toString();
    if (obtained) {
      final spin = SaveSpincrystal(id: id, obtained: obtained);
      _db.saveSpincrystals.insertItem(spin);
    } else {
      _db.saveSpincrystals.deleteItem(id);
    }
  }
}

class _PlayerConfigs {
  SavePlayerInfo? getPlayerInfo() {
    return _db.saveUserConfigs.getItemOrNull(SaveConfig.kPlayerInfo)
        as SavePlayerInfo?;
  }

  void deletePlayerInfo() {
    _db.saveUserConfigs.deleteItem(SaveConfig.kPlayerInfo);
  }
}

class _SereniteaSets {
  bool isObtainable(String set) {
    final item = _db.infoSereniteaSets.getItem(set);
    final saved = _db.saveSereniteaSets.getItemOrNull(set);
    final chars = saved?.chars ?? [];
    bool hasChar(String id) => GsUtils.characters.hasCaracter(id);
    return item.chars.any((c) => !chars.contains(c) && hasChar(c));
  }

  /// Sets the serenitea character as obtained or not.
  ///
  /// {@macro db_update}
  void setSetCharacter(String set, String char, {required bool owned}) {
    final sv = _db.saveSereniteaSets.getItemOrNull(set) ??
        SaveSereniteaSet(id: set, chars: []);
    final hasCharacter = sv.chars.contains(char);
    if (owned && !hasCharacter) {
      sv.chars.add(char);
    } else if (!owned && hasCharacter) {
      sv.chars.remove(char);
    }
    _db.saveSereniteaSets.insertItem(sv);
  }
}

class _WeaponMaterials {
  List<WeaponAsc> weaponAscension(int r) => WeaponAsc.values[r - 1];

  /// Gets all weapon ascension materials at level.
  Map<String, int> getAscensionMaterials(String id, [int? level]) {
    final item = _db.infoWeapons.getItemOrNull(id);
    final info = _db.infoWeaponsInfo.getItemOrNull(id);
    if (item == null || info == null) return const {};

    return _getMaterials<WeaponAsc>(
      WeaponAsc.values[item.rarity - 1],
      {
        'mora': (i) => i.moraAmount,
        info.matElite: (i) => i.eliteAmount,
        info.matCommon: (i) => i.commonAmount,
        info.matWeapon: (i) => i.weaponAmount,
      },
      {
        info.matElite: (i) => i.eliteIndex,
        info.matCommon: (i) => i.commonIndex,
        info.matWeapon: (i) => i.weaponIndex,
      },
      level,
    );
  }
}

class _RemarkableChests {
  /// Updates the remarkable chest as obtained or not.
  ///
  /// {@macro db_update}
  void update(String id, {required bool obtained}) {
    if (obtained) {
      _db.saveRemarkableChests
          .insertItem(SaveRemarkableChest(id: id, obtained: obtained));
    } else {
      _db.saveRemarkableChests.deleteItem(id);
    }
  }
}

class _CharactersMaterials {
  List<CharacterTal> characterTalents() => CharacterTal.values;
  List<CharacterAsc> characterAscension() => CharacterAsc.values;

  List<MapEntry<InfoMaterial?, int>> getCharNextAscensionMats(String id) {
    final max = GsUtils.characters.isCharMaxAscended(id);
    if (max) return const [];
    final db = GsDatabase.instance.infoMaterials;
    final ascension = GsUtils.characters.getCharAscension(id);
    return getAscensionMaterials(id, ascension + 1)
        .entries
        .map((e) => MapEntry(db.getItemOrNull(e.key), e.value))
        .toList();
  }

  /// Gets all character ascension materials at level.
  Map<String, int> getAscensionMaterials(String id, [int? level]) {
    final info = _db.infoCharactersInfo.getItemOrNull(id);
    if (info == null) return const {};

    return _getMaterials<CharacterAsc>(
      CharacterAsc.values,
      {
        'mora': (i) => i.moraAmount,
        info.ascension.matGem: (i) => i.gemAmount,
        info.ascension.matBoss: (i) => i.bossAmount,
        info.ascension.matRegion: (i) => i.regionAmount,
        info.ascension.matCommon: (i) => i.commonAmount,
      },
      {
        info.ascension.matGem: (i) => i.gemIndex,
        info.ascension.matCommon: (i) => i.commonIndex,
      },
      level,
    );
  }

  /// Gets all character talent materials at level.
  /// * Returns materials for all 3 talents.
  Map<String, int> getTalentMaterials(String id, [int? level]) {
    final info = _db.infoCharactersInfo.getItemOrNull(id);
    if (info == null) return const {};

    return _getMaterials<CharacterTal>(
      CharacterTal.values,
      {
        'mora': (i) => i.moraAmount,
        'crown_of_insight': (i) => i.crownAmount,
        info.ascension.matCommon: (i) => i.commonAmount,
        info.ascension.matTalent: (i) => i.talentAmount,
        info.ascension.matWeekly: (i) => i.weeklyAmount,
      },
      {
        info.ascension.matCommon: (i) => i.commonIndex,
        info.ascension.matTalent: (i) => i.talentIndex,
      },
      level,
    ).map((key, value) => MapEntry(key, value * 3));
  }

  /// Gets all character ascension and talent materials.
  Map<String, int> getAllMaterials(String id) {
    return {...getTalentMaterials(id), ...getAscensionMaterials(id)}
        .entries
        .groupBy((e) => e.key)
        .map((k, v) => MapEntry(k, v.sumBy((e) => e.value).toInt()));
  }
}

// === MATERIALS ===

class CharacterAsc {
  static const values = [
    CharacterAsc(1, 0, 0, 0, 0, 0, 0, 0),
    CharacterAsc(20, 1, 0, 3, 3, 20000, 0, 0),
    CharacterAsc(40, 3, 2, 15, 10, 40000, 1, 0),
    CharacterAsc(50, 6, 4, 12, 20, 60000, 1, 1),
    CharacterAsc(60, 3, 8, 18, 30, 80000, 2, 1),
    CharacterAsc(70, 6, 12, 12, 45, 100000, 2, 2),
    CharacterAsc(80, 6, 20, 24, 60, 120000, 3, 2),
    CharacterAsc(90, 0, 0, 0, 0, 0, 0, 0),
  ];

  final int level;
  final int gemAmount;
  final int bossAmount;
  final int commonAmount;
  final int regionAmount;
  final int moraAmount;

  final int gemIndex;
  final int commonIndex;

  const CharacterAsc(
    this.level,
    this.gemAmount,
    this.bossAmount,
    this.commonAmount,
    this.regionAmount,
    this.moraAmount,
    this.gemIndex,
    this.commonIndex,
  );
}

class CharacterTal {
  static const values = [
    CharacterTal(0, 6, 3, 0, 0, 12500, 0, 0),
    CharacterTal(0, 3, 2, 0, 0, 17500, 1, 1),
    CharacterTal(0, 4, 4, 0, 0, 25000, 1, 1),
    CharacterTal(0, 6, 6, 0, 0, 30000, 1, 1),
    CharacterTal(0, 9, 9, 0, 0, 37500, 1, 1),
    CharacterTal(0, 4, 4, 1, 0, 120000, 2, 2),
    CharacterTal(0, 6, 6, 1, 0, 260000, 2, 2),
    CharacterTal(0, 9, 12, 2, 0, 450000, 2, 2),
    CharacterTal(0, 12, 16, 2, 1, 700000, 2, 2),
  ];

  final int level;
  final int commonAmount;
  final int talentAmount;
  final int weeklyAmount;
  final int crownAmount;
  final int moraAmount;

  final int commonIndex;
  final int talentIndex;

  const CharacterTal(
    this.level,
    this.commonAmount,
    this.talentAmount,
    this.weeklyAmount,
    this.crownAmount,
    this.moraAmount,
    this.commonIndex,
    this.talentIndex,
  );
}

class WeaponAsc {
  static const values = [
    [
      WeaponAsc(1, 0, 0, 0, 0, 0, 0, 0),
      WeaponAsc(20, 0, 1, 1, 1, 0, 0, 0),
      WeaponAsc(40, 5000, 2, 4, 1, 0, 0, 1),
      WeaponAsc(50, 5000, 2, 2, 2, 1, 1, 1),
      WeaponAsc(60, 10000, 3, 4, 1, 1, 1, 2),
      WeaponAsc(70, 0, 0, 0, 0, 0, 0, 0),
    ],
    [
      WeaponAsc(1, 0, 0, 0, 0, 0, 0, 0),
      WeaponAsc(20, 5000, 1, 1, 1, 0, 0, 0),
      WeaponAsc(40, 5000, 4, 5, 1, 0, 0, 1),
      WeaponAsc(50, 10000, 3, 3, 3, 1, 1, 1),
      WeaponAsc(60, 15000, 4, 5, 1, 1, 1, 2),
      WeaponAsc(70, 0, 0, 0, 0, 0, 0, 0),
    ],
    [
      WeaponAsc(1, 0, 0, 0, 0, 0, 0, 0),
      WeaponAsc(20, 5000, 1, 2, 2, 0, 0, 0),
      WeaponAsc(40, 10000, 5, 8, 2, 0, 0, 1),
      WeaponAsc(50, 15000, 4, 4, 4, 1, 1, 1),
      WeaponAsc(60, 20000, 6, 8, 2, 1, 1, 2),
      WeaponAsc(70, 25000, 4, 6, 4, 2, 2, 2),
      WeaponAsc(80, 30000, 8, 12, 3, 2, 2, 3),
      WeaponAsc(90, 0, 0, 0, 0, 0, 0, 0),
    ],
    [
      WeaponAsc(1, 0, 0, 0, 0, 0, 0, 0),
      WeaponAsc(20, 5000, 2, 3, 3, 0, 0, 0),
      WeaponAsc(40, 15000, 8, 12, 3, 0, 0, 1),
      WeaponAsc(50, 20000, 6, 6, 6, 1, 1, 1),
      WeaponAsc(60, 30000, 9, 12, 3, 1, 1, 2),
      WeaponAsc(70, 35000, 6, 9, 6, 2, 2, 2),
      WeaponAsc(80, 45000, 12, 18, 4, 2, 2, 3),
      WeaponAsc(90, 0, 0, 0, 0, 0, 0, 0),
    ],
    [
      WeaponAsc(1, 0, 0, 0, 0, 0, 0, 0),
      WeaponAsc(20, 10000, 3, 5, 5, 0, 0, 0),
      WeaponAsc(40, 20000, 12, 18, 5, 0, 0, 1),
      WeaponAsc(50, 30000, 9, 9, 9, 1, 1, 1),
      WeaponAsc(60, 45000, 14, 18, 5, 1, 1, 2),
      WeaponAsc(70, 55000, 9, 14, 9, 2, 2, 2),
      WeaponAsc(80, 65000, 18, 27, 6, 2, 2, 3),
      WeaponAsc(90, 0, 0, 0, 0, 0, 0, 0),
    ]
  ];
  final int level;
  final int moraAmount;
  final int commonAmount;
  final int eliteAmount;
  final int weaponAmount;

  final int commonIndex;
  final int eliteIndex;
  final int weaponIndex;

  const WeaponAsc(
    this.level,
    this.moraAmount,
    this.commonAmount,
    this.eliteAmount,
    this.weaponAmount,
    this.eliteIndex,
    this.commonIndex,
    this.weaponIndex,
  );
}

Map<String, int> _getMaterials<T>(
  List<T> items,
  Map<String, int Function(T i)> amounts,
  Map<String, int Function(T i)> indexes, [
  int? level,
]) {
  if (level != null) {
    final temp = items.elementAtOrNull(level);
    items = temp != null ? [temp] : [];
  }

  final materials = amounts
      .map((k, v) => MapEntry(k, GsUtils.materials.getGroupMaterialsById(k)));

  final total = <String, int>{};
  for (var item in items) {
    for (var entry in materials.entries) {
      final index = indexes[entry.key]?.call(item) ?? 0;
      final material = index == 0
          ? entry.value.firstOrNullWhere((e) => e.id == entry.key)
          : entry.value.elementAtOrNull(index);
      if (material == null) continue;
      final amount = amounts[entry.key]?.call(item) ?? 0;
      total[material.id] = (total[material.id] ?? 0) + amount;
    }
  }
  return total..removeWhere((key, value) => value == 0);
}

// === OLD ===

class ItemData extends IdData<ItemData> {
  final InfoWeapon? weapon;
  final InfoCharacter? character;

  @override
  String get id => weapon?.id ?? character?.id ?? '';
  String get name => weapon?.name ?? character?.name ?? '';
  String get image => weapon?.image ?? character?.image ?? '';
  GsItem get type => weapon != null ? GsItem.weapon : GsItem.character;
  int get rarity => weapon?.rarity ?? character?.rarity ?? 0;

  ItemData.weapon(this.weapon) : character = null;
  ItemData.character(this.character) : weapon = null;

  @override
  List<Comparator<ItemData>> get comparators => [
        (a, b) => a.rarity.compareTo(b.rarity),
        (a, b) => a.type.index.compareTo(b.type.index),
        (a, b) => a.name.compareTo(b.name),
      ];
}

List<Widget> getSized(Iterable<Widget> widgets) {
  final sizes = <double>[100, 44, 0, 20, 64, 84, 56];
  return List.generate(
    sizes.length,
    (i) => sizes[i] == 0
        ? Expanded(child: Row(children: [widgets.elementAt(i)]))
        : SizedBox(
            width: sizes[i],
            child: Center(child: widgets.elementAt(i)),
          ),
  );
}

class PrimogemIcon extends StatelessWidget {
  final double size;
  final Offset offset;

  const PrimogemIcon({
    super.key,
    this.size = 20,
    this.offset = const Offset(0, 3),
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset,
      child: Padding(
        padding: const EdgeInsets.only(right: 4),
        child: Image.asset(
          imagePrimogem,
          width: size,
          height: size,
          fit: BoxFit.fitHeight,
          cacheWidth: size.toInt(),
          cacheHeight: size.toInt(),
        ),
      ),
    );
  }
}

class WishesSummary {
  final WishInfo wishesInfo4;
  final WishInfo wishesInfo5;
  final WishInfo wishesInfo4Weapon;
  final WishInfo wishesInfo4Character;
  final WishInfo wishesInfo5Weapon;
  final WishInfo wishesInfo5Character;

  int get last4 => wishesInfo4.last;
  int get last5 => wishesInfo5.last;
  int get total4 => wishesInfo4.total;
  int get total5 => wishesInfo5.total;
  double get average4 => wishesInfo4.average;
  double get average5 => wishesInfo5.average;
  double get percentage4 => wishesInfo4.percentage;
  double get percentage5 => wishesInfo5.percentage;
  List<SaveWish> get wishes4 => wishesInfo4.wishes;
  List<SaveWish> get wishes5 => wishesInfo5.wishes;

  WishesSummary({
    required this.wishesInfo4,
    required this.wishesInfo5,
    required this.wishesInfo4Weapon,
    required this.wishesInfo4Character,
    required this.wishesInfo5Weapon,
    required this.wishesInfo5Character,
  });

  factory WishesSummary.fromList(List<SaveWish> wishes) {
    return WishesSummary(
      wishesInfo4: WishInfo.fromSelector(
        wishes,
        (item) => item.rarity == 4,
      ),
      wishesInfo5: WishInfo.fromSelector(
        wishes,
        (item) => item.rarity == 5,
      ),
      wishesInfo4Weapon: WishInfo.fromSelector(
        wishes,
        (item) => item.rarity == 4 && item.type == GsItem.weapon,
      ),
      wishesInfo4Character: WishInfo.fromSelector(
        wishes,
        (item) => item.rarity == 4 && item.type == GsItem.character,
      ),
      wishesInfo5Weapon: WishInfo.fromSelector(
        wishes,
        (item) => item.rarity == 5 && item.type == GsItem.weapon,
      ),
      wishesInfo5Character: WishInfo.fromSelector(
        wishes,
        (item) => item.rarity == 5 && item.type == GsItem.character,
      ),
    );
  }
}

class WishInfo {
  final int last;
  final int total;
  final double average;
  final double percentage;
  final List<SaveWish> wishes;

  WishInfo({
    required this.last,
    required this.total,
    required this.average,
    required this.percentage,
    required this.wishes,
  });

  factory WishInfo.fromSelector(
    List<SaveWish> wishes,
    bool Function(ItemData item) selector,
  ) {
    final getItem = GsUtils.items.getItemData;
    final g = wishes.where((e) => selector(getItem(e.itemId)));
    final lst = wishes.takeWhile((e) => !selector(getItem(e.itemId))).length;
    final avg = g.isNotEmpty ? g.averageBy((e) => e.pity) : 0.0;
    final per = g.length * 100 / wishes.length.coerceAtLeast(1);
    return WishInfo(
      last: lst,
      total: g.length,
      average: avg,
      percentage: per,
      wishes: g.toList(),
    );
  }
}
