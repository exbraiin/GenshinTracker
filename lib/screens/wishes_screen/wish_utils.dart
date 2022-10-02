import 'package:dartx/dartx_io.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

class ItemData extends Comparable<ItemData> {
  final InfoWeapon? weapon;
  final InfoCharacter? character;

  String get id => weapon?.id ?? character?.id ?? '';
  String get name => weapon?.name ?? character?.name ?? '';
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

/// Gets a weapon or a character by the given [id].
ItemData getItemData(String id) {
  final db = GsDatabase.instance;
  return db.infoWeapons.exists(id)
      ? ItemData(weapon: db.infoWeapons.getItem(id))
      : ItemData(character: db.infoCharacters.getItem(id));
}

/// Gets a list of [ItemData] that can be obtained in banners.
Iterable<ItemData> getEveryItemData() {
  final db = GsDatabase.instance;
  return [
    ...db.infoWeapons
        .getItems()
        .where((e) => e.rarity > 2)
        .map((element) => ItemData(weapon: element)),
    ...db.infoCharacters
        .getItems()
        .map((element) => ItemData(character: element)),
  ];
}

/// Gets the pity of the given wish in the given wishes list.
int getPity(List<SaveWish> wishes, SaveWish wish) {
  final item = getItemData(wish.itemId);

  if (item.rarity == 4 || item.rarity == 5) {
    final list = wishes.skipWhile((value) => value != wish).skip(1).toList();
    final last =
        list.indexWhere((e) => getItemData(e.itemId).rarity == item.rarity);
    return last != -1 ? (last + 1).coerceAtLeast(1) : list.length + 1;
  }

  return 1;
}

enum WishState { none, won, lost, guaranteed }

WishState getWishState(List<SaveWish> wishes, SaveWish wish) {
  final item = getItemData(wish.itemId);
  if (item.rarity != 5) return WishState.none;

  final db = GsDatabase.instance;
  final banner = db.infoBanners.getItem(wish.bannerId);
  final bannerContains = banner.feature5.contains(wish.itemId);

  wishes = wishes.skipWhile((value) => value != wish).skip(1).toList();
  final last = wishes.indexWhere((e) => getItemData(e.itemId).rarity == 5);
  if (last == -1) return bannerContains ? WishState.won : WishState.lost;

  final lastWish = wishes[last];
  final lastBanner = db.infoBanners.getItem(lastWish.bannerId);
  final lastBannerContains = lastBanner.feature5.contains(wishes[last].itemId);

  if (lastBannerContains && bannerContains) return WishState.won;
  if (lastBannerContains && !bannerContains) return WishState.lost;
  if (!lastBannerContains && bannerContains) return WishState.guaranteed;
  return WishState.none;
}

/// Checks if the given wish was a guaranteed wish in the given wishes list.
bool getGuaranteed(List<SaveWish> wishes, SaveWish wish) {
  final item = getItemData(wish.itemId);
  if (item.rarity != 5) return false;
  final list = wishes.skipWhile((value) => value != wish).skip(1).toList();
  return isNextGaranteed(list);
}

/// Checks if the next wish is a guaranteed one in the given wishes list.
bool isNextGaranteed(List<SaveWish> wishes) {
  final last = wishes.indexWhere((e) => getItemData(e.itemId).rarity == 5);
  if (last == -1) return false;
  final lastWish = wishes[last];
  final db = GsDatabase.instance;
  final banner = db.infoBanners.getItem(lastWish.bannerId);
  return !banner.feature5.contains(wishes[last].itemId);
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
      padding: EdgeInsets.only(right: 4),
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
    final g = wishes.where((e) => selector(getItemData(e.itemId)));
    final l = wishes.takeWhile((e) => !selector(getItemData(e.itemId))).length;
    final a = g.length > 0 ? g.map((e) => getPity(wishes, e)).average() : 0.0;
    final p = g.length * 100 / wishes.length.coerceAtLeast(1);
    return WishInfo(
      last: l,
      total: g.length,
      average: a,
      percentage: p,
      wishes: g.toList(),
    );
  }
}
