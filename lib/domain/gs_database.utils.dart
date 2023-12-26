import 'package:dartx/dartx_io.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/domain/gs_database.dart';

/// {@template db_update}
/// Updates db collection
/// {@endtemplate}
final _db = Database.instance;
final _ifAchievements = _db.infoOf<GsAchievement>();
final _ifSereniteas = _db.infoOf<GsSereniteaSet>();
final _ifBanners = _db.infoOf<GsBanner>();
final _idWeapons = _db.infoOf<GsWeapon>();
final _ifRegions = _db.infoOf<GsRegion>();
final _ifCharacters = _db.infoOf<GsCharacter>();
final _ifMaterials = _db.infoOf<GsMaterial>();
final _ifVersions = _db.infoOf<GsVersion>();
final _ifCharactersSkin = _db.infoOf<GsCharacterSkin>();
final _ifWeapons = _db.infoOf<GsWeapon>();
final _svAchievement = _db.saveOf<GiAchievement>();
final _svWish = _db.saveOf<GiWish>();
final _svRecipe = _db.saveOf<GiRecipe>();
final _svFurnitureChest = _db.saveOf<GiFurnitureChest>();
final _svCharacter = _db.saveOf<GiCharacter>();
final _svReputation = _db.saveOf<GiReputation>();
final _svSereniteaSet = _db.saveOf<GiSereniteaSet>();
final _svFurnishing = _db.saveOf<GiFurnishing>();
final _svSpincrystal = _db.saveOf<GiSpincrystal>();
final _svPlayerInfo = _db.saveOf<GiPlayerInfo>();

class GsUtils {
  GsUtils._();

  static final items = _Items();
  static final cities = _Cities();
  static final wishes = _Wishes();
  static final details = _Details();
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
  GsWish getItemData(String id) {
    final weapon = _idWeapons.getItem(id);
    return weapon != null
        ? GsWish.fromWeapon(weapon)
        : GsWish.fromCharacter(_ifCharacters.getItem(id));
  }

  /// Gets a weapon or a character by the given [id].
  GsWish? getItemDataOrNull(String id) {
    final weapon = _idWeapons.getItem(id);
    if (weapon != null) return GsWish.fromWeapon(weapon);
    final character = _ifCharacters.getItem(id);
    if (character != null) return GsWish.fromCharacter(character);
    return null;
  }

  Map<GsMaterial, List<GsWish>> getItemsByMaterial(GeWeekdayType weekday) {
    final getMat = _ifMaterials.getItem;

    return [
      ..._ifCharacters.items
          .map((element) => MapEntry(element.id, element.talentMaterial)),
      ..._ifWeapons.items
          .map((element) => MapEntry(element.id, element.matWeapon)),
    ]
        .groupBy((element) => element.value)
        .entries
        .where((element) => getMat(element.key)!.weekdays.contains(weekday))
        .toMap(
          (e) => _ifMaterials.getItem(e.key)!,
          (e) => e.value.map((e) => getItemData(e.key)).toList(),
        );
  }
}

class _Cities {
  /// Gets the city max level
  int getCityMaxLevel(String id) =>
      _ifRegions.getItem(id)?.reputation.length ?? 0;

  /// Gets the user saved city current level.
  int getCityLevel(String id) {
    final sRp = getSavedReputation(id);
    final rep = _ifRegions.getItem(id)?.reputation ?? [];
    return rep.lastIndexWhere((e) => e <= sRp) + 1;
  }

  /// Gets the previous level max xp value.
  int getCityPreviousXpValue(String id) {
    final sRP = getSavedReputation(id);
    final rep = _ifRegions.getItem(id)?.reputation ?? [];
    return rep.lastWhere((e) => e <= sRP, orElse: () => 0);
  }

  /// Gets the current level max xp value.
  int getCityNextXpValue(String id) {
    final sRP = getSavedReputation(id);
    final rep = _ifRegions.getItem(id)?.reputation ?? [];
    return rep.firstWhere((e) => e > sRP, orElse: () => -1);
  }

  /// Gets the amount of weeks required to reach the next level based on bounties and quests.
  int getCityNextLevelWeeks(String id) {
    final sRp = getSavedReputation(id);
    final rep = _ifRegions.getItem(id)?.reputation ?? [];
    final idx = rep.lastIndexWhere((e) => e <= sRp);
    final next = idx + 1 < rep.length ? rep[idx + 1] : rep.last;
    final xp = next - sRp;
    return (xp / GsUtils.details.cityXpPerWeek).ceil().coerceAtLeast(0);
  }

  /// Gets the amount of weeks required to reach the max level based on bounties and quests.
  int getCityMaxLevelWeeks(String id) {
    final rep = _ifRegions.getItem(id)?.reputation ?? [];
    final xp = rep.last - getSavedReputation(id);
    return (xp / GsUtils.details.cityXpPerWeek).ceil().coerceAtLeast(0);
  }

  /// Gets the user saved reputation xp
  int getSavedReputation(String id) =>
      _svReputation.getItem(id)?.reputation ?? 0;

  /// Sets the user saved reputation xp
  ///
  /// {@macro db_update}
  void updateReputation(String id, int reputation) {
    final item = GiReputation(id: id, reputation: reputation);
    _svReputation.setItem(item);
  }
}

class _Wishes {
  /// Gets all released banners by [type]
  Iterable<GsBanner> geReleasedInfoBannerByType(GeBannerType type) {
    final now = DateTime.now();
    return _ifBanners.items
        .where((e) => e.type == type && e.dateStart.isBefore(now));
  }

  /// Gets the pity of the given wish in the given wishes list.
  int countPity(List<GiWish> wishes, GiWish wish) {
    final item = GsUtils.items.getItemData(wish.itemId);
    final rarity = item.rarity;
    if (rarity < 4) return 1;
    final getItem = GsUtils.items.getItemData;
    final list = wishes.skipWhile((value) => value != wish).skip(1).toList();
    final last = list.indexWhere((e) => getItem(e.itemId).rarity == rarity);
    return last != -1 ? (last + 1).coerceAtLeast(1) : list.length + 1;
  }

  GiWish? _getLastWish(Iterable<GiWish> wishes, [int rarity = 5]) {
    final getItem = GsUtils.items.getItemData;
    return wishes.firstOrNullWhere((e) => getItem(e.itemId).rarity == rarity);
  }

  /// Checks if the next wish is a guaranteed one in the given wishes list.
  bool isNextGaranteed(List<GiWish> wishes) {
    final last = _getLastWish(wishes);
    if (last == null) return false;
    final banner = _ifBanners.getItem(last.bannerId);
    if (banner == null) return false;
    return !banner.feature5.contains(last.itemId);
  }

  /// Gets the wish state.
  WishState getWishState(List<GiWish> wishes, GiWish wish) {
    final item = GsUtils.items.getItemData(wish.itemId);
    final rt = item.rarity;
    if (rt != 5 && rt != 4) return WishState.none;

    late final banner = _ifBanners.getItem(wish.bannerId)!;
    late final featured = rt == 5 ? banner.feature5 : banner.feature4;
    late final contained = featured.contains(wish.itemId);

    wishes = wishes.skipWhile((value) => value != wish).skip(1).toList();
    final lastWish = _getLastWish(wishes, rt);
    if (lastWish == null) return contained ? WishState.won : WishState.lost;

    final lastBanner = _ifBanners.getItem(lastWish.bannerId)!;
    final lastFeatured = rt == 5 ? lastBanner.feature5 : lastBanner.feature4;
    final lastBannerContains = lastFeatured.contains(lastWish.itemId);

    if (lastBannerContains && contained) return WishState.won;
    if (lastBannerContains && !contained) return WishState.lost;
    if (!lastBannerContains && contained) return WishState.guaranteed;
    return WishState.none;
  }

  /// Gets a list of [ItemData] that can be obtained in banners.
  Iterable<GsWish> getBannerItemsData(GsBanner banner) {
    bool filterWp(GsWeapon info) {
      late final isStandard = info.source == GeItemSourceType.wishesStandard;
      late final isFeatured = banner.feature5.contains(info.id);
      late final isChar =
          banner.type == GeBannerType.character && info.rarity == 5;
      late final isBegn =
          banner.type == GeBannerType.beginner && info.rarity > 3;
      return (isStandard || isFeatured) && !isChar && !isBegn;
    }

    bool filterCh(GsCharacter info) {
      late final isStandard = info.source == GeItemSourceType.wishesStandard;
      late final isFeatured = banner.feature5.contains(info.id);
      late final isWeap =
          banner.type == GeBannerType.weapon && info.rarity == 5;
      return (isStandard || isFeatured) && !isWeap;
    }

    return [
      ..._idWeapons.items.where(filterWp).map(GsWish.fromWeapon),
      ..._ifCharacters.items.where(filterCh).map(GsWish.fromCharacter),
    ];
  }

  /// Gets all wishes for the given [banner].
  List<GiWish> getBannerWishes(String banner) =>
      _svWish.items.where((e) => e.bannerId == banner).toList();

  /// Gets all saved wishes for a banner [type].
  List<GiWish> getSaveWishesByBannerType(GeBannerType type) {
    final banners = GsUtils.wishes.geReleasedInfoBannerByType(type);
    final bannerIds = banners.map((e) => e.id);
    return _db
        .saveOf<GiWish>()
        .items
        .where((e) => bannerIds.contains(e.bannerId))
        .toList();
  }

  /// Whether the [banner] has wishes.
  bool bannerHasWishes(String banner) =>
      _svWish.items.any((e) => e.bannerId == banner);

  /// Counts the [banner] wishes.
  int countBannerWishes(String banner) =>
      _svWish.items.count((e) => e.bannerId == banner);

  /// Counts the obtained amount of [itemId].
  int countItem(String itemId) =>
      _svWish.items.count((e) => e.itemId == itemId);

  /// Whether the [itemId] was obtained.
  bool hasItem(String itemId) => _svWish.items.any((e) => e.itemId == itemId);

  /// Removes the [bannerId] last wish
  ///
  /// {@macro db_update}
  void removeLastWish(String bannerId) {
    final list = GsUtils.wishes.getBannerWishes(bannerId).sorted();
    if (list.isEmpty) return;
    _svWish.removeItem(list.last.id);
  }

  /// Updates the given [wish] date.
  ///
  /// {@macro db_update}
  void updateWishDate(GiWish wish, DateTime date) {
    if (!_svWish.exists(wish.id)) return;
    final newWish = wish.copyWith(date: date);
    _svWish.setItem(newWish);
  }

  /// Adds the items with the given [ids] to the given [bannerId].
  ///
  /// {@macro db_update}
  void addWishes({
    required Iterable<String> ids,
    required DateTime date,
    required String bannerId,
  }) async {
    final db = Database.instance.saveOf<GiWish>();
    final lastRoll = GsUtils.wishes.countBannerWishes(bannerId);
    final wishes = ids.mapIndexed((i, id) {
      final number = lastRoll + i + 1;
      return GiWish(
        id: '${bannerId}_$number',
        number: number,
        itemId: id,
        bannerId: bannerId,
        date: date,
      );
    });
    wishes.forEach(db.setItem);
  }
}

class _Details {
  final cityXpPerWeek = 420;
  final primogemsPerWish = 160;
  final primogemsPerCharSet = 20;
  final ascHerosWit = const [0, 6, 28, 29, 42, 59, 80, 0];
  final imgUnknown =
      'https://static.wikia.nocookie.net/gensin-impact/images/4/4a/Item_Unknown.png';
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
      final contains = _svRecipe.exists(id);
      if (own && !contains) {
        _svRecipe.setItem(GiRecipe(id: id, proficiency: 0));
      } else if (!own && contains) {
        _svRecipe.removeItem(id);
      }
    }
    if (proficiency != null) {
      _svRecipe.setItem(GiRecipe(id: id, proficiency: proficiency));
    }
  }
}

class _Weapons {
  bool hasWeapon(String id) {
    return _svWish.items.any((e) => e.itemId == id);
  }
}

class _Versions {
  bool isCurrentVersion(String version) {
    final now = DateTime.now();
    final current = _ifVersions.items
        .sorted()
        .lastOrNullWhere((element) => !element.releaseDate.isAfter(now));
    return current?.id == version;
  }

  bool isUpcomingVersion(String version) {
    final now = DateTime.now();
    final upcoming = _ifVersions.items
        .sorted()
        .where((version) => version.releaseDate.isAfter(now));
    return upcoming.any((element) => element.id == version);
  }

  GsVersion? getCurrentVersion() {
    final now = DateTime.now();
    final current = _ifVersions.items
        .sorted()
        .lastOrNullWhere((version) => !version.releaseDate.isAfter(now));
    return current;
  }
}

class _Materials {
  Iterable<GsMaterial> getGroupMaterials(GsMaterial material) {
    return _ifMaterials.items.where((element) {
      return element.group == material.group &&
          element.region == material.region &&
          element.subgroup == material.subgroup;
    });
  }

  Iterable<GsMaterial> getGroupMaterialsById(String id) {
    final material = _ifMaterials.getItem(id);
    if (material == null) return [];
    return getGroupMaterials(material);
  }
}

class _Characters {
  static GiCharacter _fallChar(String id) =>
      GiCharacter(id: id, owned: 0, outfit: '', ascension: 0, friendship: 1);

  /// Whether the user has this character or not.
  bool hasCaracter(String id) {
    final owned = _svCharacter.getItem(id)?.owned ?? 0;
    return owned > 0 || _svWish.items.any((e) => e.itemId == id);
  }

  /// Whether the character with the given [id] has outfits or not.
  bool hasOutfits(String id) {
    return _ifCharactersSkin.items.any((element) => element.character == id);
  }

  int getCharFriendship(String id) {
    final char = _svCharacter.getItem(id);
    return char?.friendship.coerceAtLeast(1) ?? 1;
  }

  /// Gets the character ascension level.
  int getCharAscension(String id) {
    final char = _svCharacter.getItem(id);
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
    final char = _svCharacter.getItem(id);
    final total = GsUtils.wishes.countItem(id);
    final sum = total + (char?.owned ?? 0);
    return sum > 0 ? (sum - 1) : null;
  }

  String getImage(String id) {
    final outfit = _svCharacter.getItem(id)?.outfit ?? '';
    final url = _ifCharactersSkin.getItem(outfit)?.image ?? '';
    late final charImg = _ifCharacters.getItem(id)?.image ?? '';
    return url.isNotEmpty ? url : charImg;
  }

  String getFullImage(String id) {
    final outfit = _svCharacter.getItem(id)?.outfit ?? '';
    final url = _ifCharactersSkin.getItem(outfit)?.fullImage ?? '';
    late final charImg = _ifCharacters.getItem(id)?.fullImage ?? '';
    return url.isNotEmpty ? url : charImg;
  }

  /// Sets the character outfit
  ///
  /// {@macro db_update}
  void setCharOutfit(String id, String outfit) {
    final char = _svCharacter.getItem(id);
    final item = (char ?? _fallChar(id)).copyWith(outfit: outfit);
    if (item.outfit != char?.outfit) _svCharacter.setItem(item);
  }

  /// Sets the character friendship
  ///
  /// {@macro db_update}
  void setCharFriendship(String id, int friendship) {
    final char = _svCharacter.getItem(id);
    final friend = friendship.clamp(1, 10);
    final item = (char ?? _fallChar(id)).copyWith(friendship: friend);
    if (item.friendship != char?.friendship) {
      _svCharacter.setItem(item);
    }
  }

  /// Increases the amount of owned characters
  ///
  /// {@macro db_update}
  void increaseOwnedCharacter(String id) {
    final char = _svCharacter.getItem(id);
    final wishes = GsUtils.wishes.countItem(id);
    var cOwned = char?.owned ?? 0;
    cOwned = cOwned + 1 + wishes > 7 ? 0 : cOwned + 1;
    final item = (char ?? _fallChar(id)).copyWith(owned: cOwned);
    _svCharacter.setItem(item);
  }

  /// Increases the character friendship
  ///
  /// {@macro db_update}
  void increaseFriendshipCharacter(String id) {
    final char = _svCharacter.getItem(id);
    var cFriendship = char?.friendship ?? 1;
    cFriendship = ((cFriendship + 1) % 11).coerceAtLeast(1);
    final item = (char ?? _fallChar(id)).copyWith(friendship: cFriendship);
    _svCharacter.setItem(item);
  }

  /// Increases the character ascension
  ///
  /// {@macro db_update}
  void increaseAscension(String id) {
    final char = _svCharacter.getItem(id);
    var cAscension = char?.ascension ?? 0;
    cAscension = (cAscension + 1) % 7;
    final item = (char ?? _fallChar(id)).copyWith(ascension: cAscension);
    _svCharacter.setItem(item);
  }
}

class _Achievements {
  int countTotal([bool Function(GsAchievement)? test]) {
    var items = _ifAchievements.items;
    if (test != null) items = items.where(test);
    return items.sumBy((e) => e.phases.length).toInt();
  }

  int countTotalRewards([bool Function(GsAchievement)? test]) {
    var items = _ifAchievements.items;
    if (test != null) items = items.where(test);
    return items.sumBy((e) => e.phases.sumBy((e) => e.reward)).toInt();
  }

  /// Updates the achievement obtained phase
  ///
  /// {@macro db_update}
  void update(String id, {required int obtained}) {
    final saved = _svAchievement.getItem(id)?.obtained ?? 0;
    if (saved >= obtained) obtained -= 1;
    if (obtained > 0) {
      final item = GiAchievement(id: id, obtained: obtained);
      _svAchievement.setItem(item);
    } else {
      _svAchievement.removeItem(id);
    }
  }

  bool isObtainable(String id) {
    final saved = _svAchievement.getItem(id);
    if (saved == null) return true;
    final item = _ifAchievements.getItem(id);
    return (item?.phases.length ?? 0) > saved.obtained;
  }

  int countSaved([bool Function(GsAchievement)? test]) {
    var items = _ifAchievements.items;
    if (test != null) items = items.where(test);
    return items
        .sumBy((e) => _svAchievement.getItem(e.id)?.obtained ?? 0)
        .toInt();
  }

  int countSavedRewards([bool Function(GsAchievement)? test]) {
    var items = _ifAchievements.items;
    if (test != null) items = items.where(test);
    return items.sumBy((e) {
      final i = _svAchievement.getItem(e.id)?.obtained ?? 0;
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
      final spin = GiSpincrystal(id: id, obtained: obtained);
      _svSpincrystal.setItem(spin);
    } else {
      _svSpincrystal.removeItem(id);
    }
  }
}

class _PlayerConfigs {
  final kPlayerInfo = 'player_info';
  GiPlayerInfo? getPlayerInfo() {
    return _svPlayerInfo.getItem(kPlayerInfo);
  }

  void deletePlayerInfo() {
    _svPlayerInfo.removeItem(kPlayerInfo);
  }
}

class _SereniteaSets {
  bool isObtainable(String set) {
    final item = _ifSereniteas.getItem(set);
    if (item == null) return false;
    final saved = _svSereniteaSet.getItem(set);
    final chars = saved?.chars ?? [];
    bool hasChar(String id) => GsUtils.characters.hasCaracter(id);
    return item.chars.any((c) => !chars.contains(c) && hasChar(c));
  }

  int getFurnishingAmount(String id) {
    return _svFurnishing.getItem(id)?.amount ?? 0;
  }

  void increaseFurnishingAmount(String id) {
    _svFurnishing.editItem(id, (item) {
      final amount = (item.amount + 1).coerceAtMost(999);
      return item.copyWith(amount: amount);
    });
  }

  void decreaseFurnishingAmount(String id) {
    _svFurnishing.editItem(id, (item) {
      final amount = (item.amount - 1).coerceAtLeast(0);
      if (amount == 0) return null;
      return item.copyWith(amount: amount);
    });
  }

  /// Sets the serenitea character as obtained or not.
  ///
  /// {@macro db_update}
  void setSetCharacter(String set, String char, {required bool owned}) {
    late final item = GiSereniteaSet(id: set, chars: []);
    final sv = _svSereniteaSet.getItem(set) ?? item;
    final hasCharacter = sv.chars.contains(char);
    if (owned && !hasCharacter) {
      sv.chars.add(char);
    } else if (!owned && hasCharacter) {
      sv.chars.remove(char);
    }
    _svSereniteaSet.setItem(sv);
  }

  bool isCraftable(String id) {
    final item = _ifSereniteas.getItem(id);
    if (item == null) return false;
    int getAmount(String id) => _svFurnishing.getItem(id)?.amount ?? 0;
    return item.furnishing.all((e) => getAmount(e.id) >= e.amount);
  }
}

class _WeaponMaterials {
  List<WeaponAsc> weaponAscension(int r) => WeaponAsc.values[r - 1];

  /// Gets all weapon ascension materials at level.
  Map<String, int> getAscensionMaterials(String id, [int? level]) {
    final item = _idWeapons.getItem(id);
    final info = _ifWeapons.getItem(id);
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
      final item = GiFurnitureChest(id: id, obtained: obtained);
      _svFurnitureChest.setItem(item);
    } else {
      _svFurnitureChest.removeItem(id);
    }
  }
}

class _CharactersMaterials {
  List<CharacterTal> characterTalents() => CharacterTal.values;
  List<CharacterAsc> characterAscension() => CharacterAsc.values;

  List<MapEntry<GsMaterial?, int>> getCharNextAscensionMats(String id) {
    final max = GsUtils.characters.isCharMaxAscended(id);
    if (max) return const [];
    final ascension = GsUtils.characters.getCharAscension(id);
    return getAscensionMaterials(id, ascension + 1)
        .entries
        .map((e) => MapEntry(_ifMaterials.getItem(e.key), e.value))
        .toList();
  }

  /// Gets all character ascension materials at level.
  Map<String, int> getAscensionMaterials(String id, [int? level]) {
    final info = _ifCharacters.getItem(id);
    if (info == null) return const {};

    return _getMaterials<CharacterAsc>(
      CharacterAsc.values,
      {
        'mora': (i) => i.moraAmount,
        info.gemMaterial: (i) => i.gemAmount,
        info.bossMaterial: (i) => i.bossAmount,
        info.regionMaterial: (i) => i.regionAmount,
        info.commonMaterial: (i) => i.commonAmount,
      },
      {
        info.gemMaterial: (i) => i.gemIndex,
        info.commonMaterial: (i) => i.commonIndex,
      },
      level,
    );
  }

  /// Gets all character talent materials at level.
  /// * Returns materials for all 3 talents.
  Map<String, int> getTalentMaterials(String id, [int? level]) {
    final info = _ifCharacters.getItem(id);
    if (info == null) return const {};

    return _getMaterials<CharacterTal>(
      CharacterTal.values,
      {
        'mora': (i) => i.moraAmount,
        'crown_of_insight': (i) => i.crownAmount,
        info.commonMaterial: (i) => i.commonAmount,
        info.talentMaterial: (i) => i.talentAmount,
        info.weeklyMaterial: (i) => i.weeklyAmount,
      },
      {
        info.commonMaterial: (i) => i.commonIndex,
        info.talentMaterial: (i) => i.talentIndex,
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

class WishesSummary {
  final WishInfo info4;
  final WishInfo info5;
  final WishInfo info4Weapon;
  final WishInfo info4Character;
  final WishInfo info5Weapon;
  final WishInfo info5Character;

  WishesSummary({
    required this.info4,
    required this.info5,
    required this.info4Weapon,
    required this.info4Character,
    required this.info5Weapon,
    required this.info5Character,
  });

  factory WishesSummary.fromList(List<GiWish> wishes) {
    return WishesSummary(
      info4: WishInfo.fromSelector(
        wishes,
        (item) => item.rarity == 4,
      ),
      info5: WishInfo.fromSelector(
        wishes,
        (item) => item.rarity == 5,
      ),
      info4Weapon: WishInfo.fromSelector(
        wishes,
        (item) => item.rarity == 4 && item.isWeapon,
      ),
      info4Character: WishInfo.fromSelector(
        wishes,
        (item) => item.rarity == 4 && item.isCharacter,
      ),
      info5Weapon: WishInfo.fromSelector(
        wishes,
        (item) => item.rarity == 5 && item.isWeapon,
      ),
      info5Character: WishInfo.fromSelector(
        wishes,
        (item) => item.rarity == 5 && item.isCharacter,
      ),
    );
  }
}

class WishInfo {
  final int last;
  final int total;
  final double average;
  final double percentage;
  final List<GiWish> wishes;

  WishInfo({
    required this.last,
    required this.total,
    required this.average,
    required this.percentage,
    required this.wishes,
  });

  factory WishInfo.fromSelector(
    List<GiWish> wishes,
    bool Function(GsWish item) selector,
  ) {
    final pity = GsUtils.wishes.countPity;
    final getItem = GsUtils.items.getItemData;
    final g = wishes.where((e) => selector(getItem(e.itemId)));
    final lst = wishes.takeWhile((e) => !selector(getItem(e.itemId))).length;
    final avg = g.isNotEmpty ? g.averageBy((e) => pity(wishes, e)) : 0.0;
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
