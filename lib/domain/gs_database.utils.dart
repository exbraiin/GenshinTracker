import 'package:dartx/dartx_io.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/domain/gs_database.dart';

/// {@template db_update}
/// Updates db collection
/// {@endtemplate}
final _db = Database.instance;
//
final _ifAchievements = _db.infoOf<GsAchievement>();
final _ifSereniteas = _db.infoOf<GsSereniteaSet>();
final _ifBanners = _db.infoOf<GsBanner>();
final _idWeapons = _db.infoOf<GsWeapon>();
final _ifCharacters = _db.infoOf<GsCharacter>();
final _ifMaterials = _db.infoOf<GsMaterial>();
final _ifVersions = _db.infoOf<GsVersion>();
final _ifCharactersSkin = _db.infoOf<GsCharacterSkin>();
final _ifWeapons = _db.infoOf<GsWeapon>();
final _ifEvents = _db.infoOf<GsEvent>();
//
final _svAchievement = _db.saveOf<GiAchievement>();
final _svEchoes = _db.saveOf<GiEnvisagedEcho>();
final _svWish = _db.saveOf<GiWish>();
final _svRecipe = _db.saveOf<GiRecipe>();
final _svFurnitureChest = _db.saveOf<GiFurnitureChest>();
final _svCharacter = _db.saveOf<GiCharacter>();
final _svSereniteaSet = _db.saveOf<GiSereniteaSet>();
final _svFurnishing = _db.saveOf<GiFurnishing>();
final _svSpincrystal = _db.saveOf<GiSpincrystal>();
final _svPlayerInfo = _db.saveOf<GiPlayerInfo>();
final _svAccountInfo = _db.saveOf<GiAccountInfo>();
final _svEvents = _db.saveOf<GiEventRewards>();

class GsUtils {
  GsUtils._();

  static const items = _Items();
  static const echos = _Echoes();
  static const wishes = _Wishes();
  static const events = _Events();
  static const details = _Details();
  static const recipes = _Recipes();
  static const weapons = _Weapons();
  static const versions = _Versions();
  static const materials = _Materials();
  static const characters = _Characters();
  static const achievements = _Achievements();
  static const spincrystals = _Spincrystals();
  static const playerConfigs = _PlayerConfigs();
  static const sereniteaSets = _SereniteaSets();
  static const weaponMaterials = _WeaponMaterials();
  static const remarkableChests = _RemarkableChests();
  static const characterMaterials = _CharactersMaterials();
}

enum WishState { none, won, lost, guaranteed }

class _Items {
  const _Items();

  /// Gets a weapon or a character by the given [id].
  GsWish getItemData(String id) {
    final weapon = _idWeapons.getItem(id);
    return weapon != null
        ? GsWish.fromWeapon(weapon)
        : GsWish.fromCharacter(_ifCharacters.getItem(id));
  }

  /// Gets a weapon or a character by the given [id].
  GsWish? getItemDataOrNull(String? id) {
    if (id == null) return null;
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

class _Echoes {
  const _Echoes();

  int get owned {
    final info = _db.infoOf<GsEnvisagedEcho>();
    final save = _db.saveOf<GiEnvisagedEcho>();
    return info.items.count((e) => save.exists(e.id));
  }

  int get total {
    final info = _db.infoOf<GsEnvisagedEcho>();
    return info.length;
  }

  /// Whether the item exists or not.
  bool hasItem(String id) {
    return _svEchoes.exists(id);
  }

  /// Updates the echo as [own].
  ///
  /// {@macro db_update}
  void update(String id, bool own) {
    if (own) {
      _svEchoes.setItem(GiEnvisagedEcho(id: id));
    } else {
      _svEchoes.removeItem(id);
    }
  }
}

typedef WishSummary = ({GsWish item, GiWish wish, int pity, WishState state});

class _Wishes {
  const _Wishes();

  /// Gets all released banners by [type]
  Iterable<GsBanner> getReleasedInfoBannerByType(GeBannerType type) {
    final now = DateTime.now();
    return _ifBanners.items
        .where((e) => e.type == type && e.dateStart.isBefore(now));
  }

  /// Gets all released banners by [types]
  Iterable<GsBanner> getReleasedInfoBannerByTypes(
    Set<GeBannerType> types,
  ) sync* {
    for (final type in types) {
      yield* getReleasedInfoBannerByType(type);
    }
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

  /// Gets all saved wishes summary for a banner [type] in ascending order.
  Iterable<WishSummary> getSaveWishesSummaryByBannerType(GeBannerType type) {
    final l = GsUtils.wishes.getReleasedInfoBannerByType(type).map((e) => e.id);
    final wishes = _svWish.items.where((e) => l.contains(e.bannerId)).sorted();

    WishState getWishState(
      String itemId,
      WishState lastState,
      Iterable<String>? featured,
    ) {
      if (type.isPermanent || featured == null) return WishState.none;
      final isFeatured = featured.contains(itemId);
      if (!isFeatured) return WishState.lost;
      if (lastState == WishState.lost) return WishState.guaranteed;
      return WishState.won;
    }

    var l4 = 0, l5 = 0;
    var s4 = WishState.none, s5 = WishState.none;
    final list = <WishSummary>[];
    for (final wish in wishes) {
      l4++;
      l5++;
      final item = GsUtils.items.getItemData(wish.itemId);
      late final banner = _db.infoOf<GsBanner>().getItem(wish.bannerId);

      if (item.rarity == 5) {
        final state = getWishState(wish.itemId, s5, banner?.feature5);
        final tuple = (item: item, wish: wish, state: state, pity: l5);
        list.add(tuple);
        l5 = 0;
        s5 = state;
      } else if (item.rarity == 4) {
        final state = getWishState(wish.itemId, s4, banner?.feature4);
        final tuple = (item: item, wish: wish, state: state, pity: l4);
        list.add(tuple);
        l4 = 0;
        s4 = state;
      } else {
        final tuple = (item: item, wish: wish, state: WishState.none, pity: 1);
        list.add(tuple);
      }
    }

    return list;
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

class _Events {
  const _Events();

  /// Gets the event characters
  List<GsCharacter> getEventCharacters(String id) {
    final list = _ifEvents.getItem(id)?.rewardsCharacters;
    if (list == null) return const [];
    return list.map(_ifCharacters.getItem).whereNotNull().toList();
  }

  /// Gets the event weapons
  List<GsWeapon> getEventWeapons(String id) {
    final list = _ifEvents.getItem(id)?.rewardsWeapons;
    if (list == null) return const [];
    return list.map(_ifWeapons.getItem).whereNotNull().toList();
  }

  /// Whether the user collected the [eventId] weapon or not.
  bool ownsWeapon(String eventId, String id) {
    return _svEvents.getItem(eventId)?.obtainedWeapons.contains(id) ?? false;
  }

  /// Whether the user collected the [eventId] character or not.
  bool ownsCharacter(String eventId, String id) {
    return _svEvents.getItem(eventId)?.obtainedCharacters.contains(id) ?? false;
  }

  /// Adds or removes the given [id] from the given [eventId].
  ///
  /// {@macro db_update}
  void toggleObtainedtWeapon(String eventId, String id) {
    final saved =
        _svEvents.getItem(eventId) ?? GiEventRewards.fromJson({'id': eventId});
    final list = saved.obtainedWeapons.toList();
    if (list.contains(id)) {
      list.remove(id);
    } else {
      list.add(id);
    }
    _svEvents.setItem(saved.copyWith(obtainedWeapons: list));
  }

  /// Adds or removes the given [id] from the given [eventId].
  ///
  /// {@macro db_update}
  void toggleObtainedCharacter(String eventId, String id) {
    final saved =
        _svEvents.getItem(eventId) ?? GiEventRewards.fromJson({'id': eventId});
    final list = saved.obtainedCharacters.toList();
    if (list.contains(id)) {
      list.remove(id);
    } else {
      list.add(id);
    }
    _svEvents.setItem(saved.copyWith(obtainedCharacters: list));
  }
}

class _Details {
  const _Details();
  final cityXpPerWeek = 420;
  final primogemsPerWish = 160;
  final primogemsPerCharSet = 20;
  final ascHerosWit = const [0, 6, 28, 29, 42, 59, 80, 0];
  final standardChar = 'keqing';
  final beginnerChar = 'noelle';
  final imgUnknown =
      'https://static.wikia.nocookie.net/gensin-impact/images/4/4a/Item_Unknown.png';
}

class _Recipes {
  const _Recipes();

  int get owned {
    final info = _db.infoOf<GsRecipe>();
    final save = _db.saveOf<GiRecipe>();
    return info.items.count(
      (e) =>
          e.baseRecipe.isEmpty &&
          e.type == GeRecipeType.permanent &&
          save.getItem(e.id) != null,
    );
  }

  int get mastered {
    final info = _db.infoOf<GsRecipe>();
    final save = _db.saveOf<GiRecipe>();
    return info.items.count(
      (e) =>
          e.baseRecipe.isEmpty &&
          e.type == GeRecipeType.permanent &&
          (save.getItem(e.id)?.proficiency ?? 0) >= e.maxProficiency,
    );
  }

  int get total {
    final info = _db.infoOf<GsRecipe>();
    return info.items
        .count((e) => e.baseRecipe.isEmpty && e.type == GeRecipeType.permanent);
  }

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
  const _Weapons();
  bool hasWeapon(String id) {
    return _svWish.items.any((e) => e.itemId == id) || eventWeapons(id) > 0;
  }

  int eventWeapons(String id) {
    return _svEvents.items.count((e) => e.obtainedWeapons.contains(id));
  }
}

class _Versions {
  const _Versions();
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
  const _Materials();
  Iterable<GsMaterial> getGroupMaterials(GsMaterial material) {
    return _ifMaterials.items.where((element) {
      return element.group == material.group &&
          element.region == material.region &&
          element.subgroup == material.subgroup;
    }).sortedBy((element) => element.rarity);
  }

  Iterable<GsMaterial> getGroupMaterialsById(String id) {
    final material = _ifMaterials.getItem(id);
    if (material == null) return [];
    return getGroupMaterials(material);
  }
}

class CharInfo {
  final bool isOwned;
  final bool hasOutfit;
  final int ascension;
  final int friendship;
  final int totalConstellations;
  final String iconImage;
  final String wishImage;
  final int _talent1, _talent2, _talent3;

  bool get isMaxAscension => ascension >= 6;
  bool get isAscendable => isOwned && !isMaxAscension;
  int get constellations => totalConstellations.clamp(0, 6);
  int get extraConstellations => totalConstellations - constellations;

  int? get talent1 => isOwned ? _talent1 : null;
  int? get talent2 => isOwned ? _talent2 : null;
  int? get talent3 => isOwned ? _talent3 : null;
  int? get talents => isOwned ? (_talent1 + _talent2 + _talent3) : null;

  CharInfo._({
    required this.isOwned,
    required this.hasOutfit,
    required this.ascension,
    required this.friendship,
    required this.totalConstellations,
    required this.iconImage,
    required this.wishImage,
    required int talent1,
    required int talent2,
    required int talent3,
  })  : _talent1 = talent1.clamp(1, 10),
        _talent2 = talent2.clamp(1, 13),
        _talent3 = talent3.clamp(1, 13);
}

class _Characters {
  const _Characters();

  /// Whether the user has this character or not.
  bool hasCaracter(String id) {
    final owned = eventCharacters(id);
    return owned > 0 || _svWish.items.any((e) => e.itemId == id);
  }

  int eventCharacters(String id) {
    return _svEvents.items.count((e) => e.obtainedCharacters.contains(id));
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

  /// Whether the character is owned and not fully ascended.
  bool isCharAscendable(GsCharacter char) {
    return hasCaracter(char.id) && !isCharMaxAscended(char.id);
  }

  /// Gets the character current constellations amount or null.
  int? getCharConstellations(String id) {
    return getTotalCharConstellations(id)?.clamp(0, 6);
  }

  /// Gets the character total constellations amount or null.
  int? getTotalCharConstellations(String id) {
    final total = GsUtils.wishes.countItem(id);
    final sum = total + eventCharacters(id);
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

  CharInfo getCharInfo(String id) {
    final info = _svCharacter.getItem(id) ?? GiCharacter(id: id);

    final wishes = GsUtils.wishes.countItem(id);
    final owned = wishes + eventCharacters(id);
    final constellations = owned > 0 ? (owned - 1) : 0;
    final iconImage = getImage(id);
    final wishImage = getFullImage(id);

    return CharInfo._(
      isOwned: owned > 0,
      hasOutfit: _ifCharactersSkin.items.any((e) => e.character == id),
      ascension: info.ascension.clamp(0, 6),
      friendship: info.friendship.clamp(1, 10),
      totalConstellations: constellations,
      iconImage: iconImage,
      wishImage: wishImage,
      talent1: info.talent1,
      talent2: info.talent2,
      talent3: info.talent3,
    );
  }

  /// Sets the character outfit
  ///
  /// {@macro db_update}
  void setCharOutfit(String id, String outfit) {
    final char = _svCharacter.getItem(id);
    final item = (char ?? GiCharacter(id: id)).copyWith(outfit: outfit);
    if (item.outfit != char?.outfit) _svCharacter.setItem(item);
  }

  /// Sets the character friendship
  ///
  /// {@macro db_update}
  void setCharFriendship(String id, int friendship) {
    final char = _svCharacter.getItem(id);
    final friend = friendship.clamp(1, 10);
    final item = (char ?? GiCharacter(id: id)).copyWith(friendship: friend);
    if (item.friendship != char?.friendship) {
      _svCharacter.setItem(item);
    }
  }

  /// Increases the character friendship
  ///
  /// {@macro db_update}
  void increaseFriendshipCharacter(String id) {
    final char = _svCharacter.getItem(id);
    var cFriendship = char?.friendship ?? 1;
    cFriendship = ((cFriendship + 1) % 11).coerceAtLeast(1);
    final item =
        (char ?? GiCharacter(id: id)).copyWith(friendship: cFriendship);
    _svCharacter.setItem(item);
  }

  /// Increases the character ascension
  ///
  /// {@macro db_update}
  void increaseAscension(String id) {
    final char = _svCharacter.getItem(id);
    var cAscension = char?.ascension ?? 0;
    cAscension = (cAscension + 1) % 7;
    final item = (char ?? GiCharacter(id: id)).copyWith(ascension: cAscension);
    _svCharacter.setItem(item);
  }

  void _increaseTalent(
    String id, {
    int cap = 13,
    required int Function(GiCharacter char) getTalent,
    required GiCharacter Function(GiCharacter char, int tal) setTalent,
  }) {
    final char = _svCharacter.getItem(id) ?? GiCharacter(id: id);
    final cTalent = ((getTalent(char) + 1) % (cap + 1)).coerceAtLeast(1);
    _svCharacter.setItem(setTalent(char, cTalent));
  }

  /// Increases the character 1st talent
  ///
  /// {@macro db_update}
  void increaseTalent1(String id) {
    _increaseTalent(
      id,
      cap: 10,
      getTalent: (char) => char.talent1,
      setTalent: (char, tal) => char.copyWith(talent1: tal),
    );
  }

  /// Increases the character 2nd talent
  ///
  /// {@macro db_update}
  void increaseTalent2(String id) {
    _increaseTalent(
      id,
      getTalent: (char) => char.talent2,
      setTalent: (char, tal) => char.copyWith(talent2: tal),
    );
  }

  /// Increases the character 3rd talent
  ///
  /// {@macro db_update}
  void increaseTalent3(String id) {
    _increaseTalent(
      id,
      getTalent: (char) => char.talent3,
      setTalent: (char, tal) => char.copyWith(talent3: tal),
    );
  }
}

class _Achievements {
  const _Achievements();
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
  const _Spincrystals();

  int get owned {
    final info = _db.infoOf<GsSpincrystal>();
    final save = _db.saveOf<GiSpincrystal>();
    return info.items.count((e) => save.exists(e.id));
  }

  int get total {
    final info = _db.infoOf<GsSpincrystal>();
    return info.length;
  }

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
  const _PlayerConfigs();
  final kPlayerInfo = 'player_info';
  final kAccountInfo = 'account_info';

  GiPlayerInfo? getPlayerInfo() {
    return _svPlayerInfo.getItem(kPlayerInfo);
  }

  void deletePlayerInfo() {
    _svPlayerInfo.removeItem(kPlayerInfo);
  }

  GiAccountInfo getAccountInfo() {
    return _svAccountInfo.getItem(kAccountInfo) ??
        GiAccountInfo(id: kAccountInfo);
  }

  void deleteAccountInfo() {
    _svAccountInfo.removeItem(kAccountInfo);
  }

  void setAccountChar(GeWeekdayType day, String charId) {
    final info = getAccountInfo();
    switch (day) {
      case GeWeekdayType.monday:
      case GeWeekdayType.thursday:
        final nInfo = info.copyWith(monThuChar: charId);
        _svAccountInfo.setItem(nInfo);
        break;
      case GeWeekdayType.tuesday:
      case GeWeekdayType.friday:
        final nInfo = info.copyWith(tueFriChar: charId);
        _svAccountInfo.setItem(nInfo);
      case GeWeekdayType.wednesday:
      case GeWeekdayType.saturday:
        final nInfo = info.copyWith(wedSatChar: charId);
        _svAccountInfo.setItem(nInfo);
      default:
        break;
    }
  }
}

class _SereniteaSets {
  const _SereniteaSets();

  int get owned {
    final info = _db.infoOf<GsSereniteaSet>();
    final save = _db.saveOf<GiSereniteaSet>();
    return info.items.expand((e) {
      final saved = save.getItem(e.id);
      return e.chars.where((c) => saved?.chars.contains(c) ?? false);
    }).length;
  }

  int get total {
    final info = _db.infoOf<GsSereniteaSet>();
    final hasChar = GsUtils.characters.hasCaracter;
    return info.items.expand((e) => e.chars.where(hasChar)).length;
  }

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
  const _WeaponMaterials();
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
  const _RemarkableChests();

  int get owned {
    final info = _db.infoOf<GsFurnitureChest>();
    final save = _db.saveOf<GiFurnitureChest>();
    return info.items.count((e) => save.exists(e.id));
  }

  int get total {
    final info = _db.infoOf<GsFurnitureChest>();
    return info.length;
  }

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
  const _CharactersMaterials();
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

typedef WishesInfo = ({
  int last,
  int total,
  double average,
  double percentage,
  List<WishSummary> wishes,
});

class WishesSummary {
  final int total;
  final bool isNext4Guaranteed;
  final bool isNext5Guaranteed;
  final WishesInfo info4;
  final WishesInfo info5;
  final WishesInfo info4Weapon;
  final WishesInfo info4Character;
  final WishesInfo info5Weapon;
  final WishesInfo info5Character;

  WishesSummary({
    required this.total,
    required this.isNext4Guaranteed,
    required this.isNext5Guaranteed,
    required this.info4,
    required this.info5,
    required this.info4Weapon,
    required this.info4Character,
    required this.info5Weapon,
    required this.info5Character,
  });

  factory WishesSummary.fromBannerType(GeBannerType type) {
    final wishes = GsUtils.wishes
        .getSaveWishesSummaryByBannerType(type)
        .sortedByDescending((e) => e.wish);

    final info4 = <WishSummary>[];
    final info4Weapon = <WishSummary>[];
    final info4Character = <WishSummary>[];
    final info5 = <WishSummary>[];
    final info5Weapon = <WishSummary>[];
    final info5Character = <WishSummary>[];

    var l4 = 0, l4w = 0, l4c = 0;
    var l5 = 0, l5w = 0, l5c = 0;
    bool? is4Guaranteed, is5Guaranteed;

    for (final item in wishes) {
      if (item.item.rarity == 4) {
        info4.add(item);
        is4Guaranteed ??= !(_ifBanners
                .getItem(item.wish.bannerId)
                ?.feature4
                .contains(item.wish.itemId) ??
            true);

        if (item.item.isWeapon) {
          info4Weapon.add(item);
        } else {
          info4Character.add(item);
        }
      } else if (item.item.rarity == 5) {
        info5.add(item);
        is5Guaranteed ??= !(_ifBanners
                .getItem(item.wish.bannerId)
                ?.feature5
                .contains(item.wish.itemId) ??
            true);
        if (item.item.isWeapon) {
          info5Weapon.add(item);
        } else {
          info5Character.add(item);
        }
      }
      if (info4.isEmpty) {
        l4++;
        if (info4Weapon.isEmpty) l4w++;
        if (info4Character.isEmpty) l4c++;
      }
      if (info5.isEmpty) {
        l5++;
        if (info5Weapon.isEmpty) l5w++;
        if (info5Character.isEmpty) l5c++;
      }
    }

    WishesInfo getWishInfo(List<WishSummary> list, int last) {
      return (
        last: last,
        total: list.length,
        average: list.isNotEmpty ? list.averageBy((e) => e.pity) : 0.0,
        percentage: list.length * 100 / wishes.length.coerceAtLeast(1),
        wishes: list,
      );
    }

    return WishesSummary(
      total: wishes.length,
      isNext4Guaranteed: is4Guaranteed ?? false,
      isNext5Guaranteed: is5Guaranteed ?? false,
      info4: getWishInfo(info4, l4),
      info4Weapon: getWishInfo(info4Weapon, l4w),
      info4Character: getWishInfo(info4Character, l4c),
      info5: getWishInfo(info5, l5),
      info5Weapon: getWishInfo(info5Weapon, l5w),
      info5Character: getWishInfo(info5Character, l5c),
    );
  }
}
