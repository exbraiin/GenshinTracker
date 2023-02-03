import 'package:dartx/dartx_io.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

final _db = GsDatabase.instance;

class GsUtils {
  GsUtils._();

  static final items = _Items();
  static final wishes = _Wishes();
  static final versions = _Versions();
  static final characters = _Characters();
}

enum WishState { none, won, lost, guaranteed }

class _Items {
  /// Gets a weapon or a character by the given [id].
  ItemData getItemData(String id) {
    return _db.infoWeapons.exists(id)
        ? ItemData(weapon: _db.infoWeapons.getItem(id))
        : ItemData(character: _db.infoCharacters.getItem(id));
  }
}

class _Wishes {
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
    if (item.rarity != 5) return WishState.none;

    final db = GsDatabase.instance;
    late final banner = db.infoBanners.getItem(wish.bannerId);
    late final contained = banner.feature5.contains(wish.itemId);

    wishes = wishes.skipWhile((value) => value != wish).skip(1).toList();
    final lastWish = _getLastWish(wishes);
    if (lastWish == null) return contained ? WishState.won : WishState.lost;

    final lastBanner = db.infoBanners.getItem(lastWish.bannerId);
    final lastBannerContains = lastBanner.feature5.contains(lastWish.itemId);

    if (lastBannerContains && contained) return WishState.won;
    if (lastBannerContains && !contained) return WishState.lost;
    if (!lastBannerContains && contained) return WishState.guaranteed;
    return WishState.none;
  }

  /// Gets a list of [ItemData] that can be obtained in banners.
  Iterable<ItemData> getBannerItemsData(InfoBanner banner) {
    final db = GsDatabase.instance;

    bool filterWeapon(InfoWeapon info) {
      late final isStandard = info.source == GsItemSource.wishesStandard;
      late final isFeatured = banner.feature5.contains(info.id);
      late final isChar = banner.type == GsBanner.character && info.rarity == 5;
      late final isBegn = banner.type == GsBanner.beginner && info.rarity > 3;
      return (isStandard || isFeatured) && !isChar && !isBegn;
    }

    bool filterCharacter(InfoCharacter info) {
      late final isStandard = info.source == GsItemSource.wishesStandard;
      late final isFeatured = banner.feature5.contains(info.id);
      late final isWeap = banner.type == GsBanner.weapon && info.rarity == 5;
      return (isStandard || isFeatured) && !isWeap;
    }

    return [
      ...db.infoWeapons
          .getItems()
          .where((element) => filterWeapon(element))
          .map((element) => ItemData(weapon: element)),
      ...db.infoCharacters
          .getItems()
          .where((element) => filterCharacter(element))
          .map((element) => ItemData(character: element)),
    ];
  }
}

class _Versions {
  bool isCurrentVersion(String version) {
    final now = DateTime.now();
    final versions = GsDatabase.instance.infoVersion.getItems();
    final current = versions
        .sortedBy((element) => element.releaseDate)
        .lastOrNullWhere((element) => !element.releaseDate.isAfter(now));
    return current?.id == version;
  }

  bool isUpcomingVersion(String version) {
    final now = DateTime.now();
    final versions = GsDatabase.instance.infoVersion.getItems();
    final upcoming = versions
        .sortedBy((element) => element.releaseDate)
        .where((element) => element.releaseDate.isAfter(now));
    return upcoming.any((element) => element.id == version);
  }

  InfoVersion? getCurrentVersion() {
    final now = DateTime.now();
    final versions = GsDatabase.instance.infoVersion.getItems();
    final current = versions
        .sortedBy((element) => element.releaseDate)
        .lastOrNullWhere((element) => !element.releaseDate.isAfter(now));
    return current;
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
    return GsDatabase.instance.infoCharactersOutfit
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
    final total = _db.saveWishes.countItem(id);
    final sum = total + (char?.owned ?? 0);
    return sum > 0 ? (sum - 1) : null;
  }

  String getImage(String id) {
    final outfit = _db.saveCharacters.getItemOrNull(id)?.outfit ?? '';
    final url = _db.infoCharactersOutfit.getItemOrNull(outfit)?.image ?? '';
    return url.isNotEmpty ? url : _db.infoCharacters.getItem(id).image;
  }

  String getFullImage(String id) {
    final outfit = _db.saveCharacters.getItemOrNull(id)?.outfit ?? '';
    final url = _db.infoCharactersOutfit.getItemOrNull(outfit)?.fullImage ?? '';
    return url.isNotEmpty ? url : _db.infoCharacters.getItem(id).fullImage;
  }
}

// === OLD ===

class ItemData extends Comparable<ItemData> {
  final InfoWeapon? weapon;
  final InfoCharacter? character;

  String get id => weapon?.id ?? character?.id ?? '';
  String get name => weapon?.name ?? character?.name ?? '';
  String get image => weapon?.image ?? character?.image ?? '';
  GsItem get type => weapon != null ? GsItem.weapon : GsItem.character;
  int get rarity => weapon?.rarity ?? character?.rarity ?? 0;

  ItemData({
    this.weapon,
    this.character,
  }) : assert(weapon != null || character != null);

  String? getUrlImg() => weapon != null ? weapon?.image : character?.image;

  @override
  int compareTo(ItemData other) {
    final r = rarity.compareTo(other.rarity);
    if (r != 0) return r;
    final t = type.index.compareTo(other.type.index);
    if (t != 0) return t;
    return name.compareTo(other.name);
  }
}

List<Widget> getSized(Iterable<Widget> widgets) {
  final List<double> sizes = [100, 44, 0, 20, 64, 84, 56];
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

Widget primoWidget([double size = 20, double offset = 3]) {
  return Transform.translate(
    offset: Offset(0, offset),
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
    final getPity = GsUtils.wishes.countPity;
    final g = wishes.where((e) => selector(getItem(e.itemId)));
    final lst = wishes.takeWhile((e) => !selector(getItem(e.itemId))).length;
    final avg = g.isNotEmpty ? g.map((e) => getPity(wishes, e)).average() : 0.0;
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
