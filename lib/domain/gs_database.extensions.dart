import 'dart:math';

import 'package:dartx/dartx_io.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_database.json.dart';
import 'package:tracker/domain/gs_domain.dart';

// =============== Info extensions ===============

extension InfoBannerExt on JsonInfoDetails<InfoBanner> {
  List<InfoBanner> getInfoBannerByType(GsBanner type) =>
      getItems().where((e) => e.type == type).toList();
}

extension InfoCityExt on JsonInfoDetails<InfoCity> {
  int getCityMaxLevel(String id) => getItem(id).reputation.length;
}

extension InfoMaterialExt on JsonInfoDetails<InfoMaterial> {
  Iterable<InfoMaterial> getSubGroup(InfoMaterial material) {
    return getItems().where((element) =>
        element.group == material.group &&
        element.subgroup == material.subgroup);
  }
}

extension InfoVersionExt on JsonInfoDetails<InfoVersion> {
  bool isNew(String version) {
    final now = DateTime.now();
    final versions = getItems().sortedBy((e) => e.releaseDate).toList();
    final idx = versions.indexWhere((e) => e.id == version);
    if (idx == -1) return false;
    final match = versions[idx];
    final next = versions.elementAtOrNull(idx + 1);
    return match.releaseDate.isBefore(now) &&
        (next?.releaseDate.isAfter(now) ?? true);
  }

  bool isUpcoming(String version) {
    final now = DateTime.now();
    return getItemOrNull(version)?.releaseDate.isAfter(now) ?? false;
  }
}

// =============== Save extensions ===============

extension SaveReputationExt on JsonSaveDetails<SaveReputation> {
  int getSavedReputation(String id) => getItemOrNull(id)?.reputation ?? 0;

  void setSavedReputation(String id, int reputation) =>
      insertItem(SaveReputation(id: id, reputation: reputation));

  int getCityLevel(String id) {
    final cities = GsDatabase.instance.infoCities;
    final sRp = getSavedReputation(id);
    return cities.getItem(id).reputation.lastIndexWhere((e) => e <= sRp) + 1;
  }

  int getCityPreviousXpValue(String id) {
    final cities = GsDatabase.instance.infoCities;
    final sRP = getSavedReputation(id);
    final rep = cities.getItem(id).reputation;
    return rep.lastWhere((e) => e <= sRP, orElse: () => 0);
  }

  int getCityNextXpValue(String id) {
    final cities = GsDatabase.instance.infoCities;
    final sRP = getSavedReputation(id);
    final rep = cities.getItem(id).reputation;
    return rep.firstWhere((e) => e > sRP, orElse: () => -1);
  }

  int getCityNextLevelWeeks(String id) {
    final cities = GsDatabase.instance.infoCities;
    final sRp = getSavedReputation(id);
    final rep = cities.getItem(id).reputation;
    final idx = rep.lastIndexWhere((e) => e <= sRp);
    final next = idx + 1 < rep.length ? rep[idx + 1] : rep.last;
    final xp = next - sRp;
    return (xp / 420).ceil().coerceAtLeast(0);
  }

  int getCityMaxLevelWeeks(String id) {
    final cities = GsDatabase.instance.infoCities;
    final rep = cities.getItem(id).reputation;
    final xp = rep.last - getSavedReputation(id);
    return (xp / 420).ceil().coerceAtLeast(0);
  }
}

extension SaveWishesExt on JsonSaveDetails<SaveWish> {
  List<SaveWish> getBannerWishes(String banner) =>
      getItems().where((e) => e.bannerId == banner).toList();

  List<SaveWish> getSaveWishesByBannerType(GsBanner type) {
    final banners = GsDatabase.instance.infoBanners;
    final bn = banners.getInfoBannerByType(type).map((e) => e.id);
    return getItems().where((e) => bn.contains(e.bannerId)).toList();
  }

  bool bannerHasWishes(String banner) =>
      getItems().any((e) => e.bannerId == banner);

  int countBannerWishes(String banner) =>
      getItems().count((e) => e.bannerId == banner);

  int countItem(String itemId) => getItems().count((e) => e.itemId == itemId);
  bool hasItem(String itemId) => getItems().any((e) => e.itemId == itemId);

  void removeLastWish(String bannerId) {
    final list = getBannerWishes(bannerId);
    if (list.isEmpty) return;
    deleteItem(list.sorted().last.id);
  }

  void updateWishDate(SaveWish wish, DateTime date) {
    if (!exists(wish.id)) return;
    final newWish = SaveWish(
      id: wish.id,
      date: date,
      itemId: wish.itemId,
      number: wish.number,
      bannerId: wish.bannerId,
    );
    insertItem(newWish);
  }

  void addWishes({
    required Iterable<String> ids,
    required DateTime date,
    required String bannerId,
  }) async {
    final lastRoll = countBannerWishes(bannerId);
    var i = 0;
    for (var id in ids) {
      final number = lastRoll + 1 + i++;
      final wish = SaveWish(
        id: '$bannerId\_$number',
        date: date,
        itemId: id,
        number: number,
        bannerId: bannerId,
      );
      insertItem(wish);
    }
  }

  int getOwnedCharacter(String key) {
    final saveCharacters = GsDatabase.instance.saveCharacters;
    final char = saveCharacters.getItemOrNull(key);
    return countItem(key) + (char?.owned ?? 0);
  }

  int getOwnedWeapon(String key) => countItem(key);

  bool hasWeapon(String key) => hasItem(key);

  bool hasCaracter(String key) {
    final db = GsDatabase.instance.saveCharacters;
    return (db.getItemOrNull(key)?.owned ?? 0) > 0 || hasItem(key);
  }
}

extension SaveSereniteaSetExt on JsonSaveDetails<SaveSereniteaSet> {
  void setSetCharacter(String set, String char, bool owned) {
    final sv = getItemOrNull(set) ?? SaveSereniteaSet(id: set, chars: []);
    final hasCharacter = sv.chars.contains(char);
    if (owned && !hasCharacter) {
      sv.chars.add(char);
    } else if (!owned && hasCharacter) {
      sv.chars.remove(char);
    }
    insertItem(sv);
  }

  bool isObtainable(String set) {
    final db = GsDatabase.instance;
    final item = db.infoSereniteaSets.getItem(set);
    final saved = getItemOrNull(set);
    final chars = saved?.chars ?? [];
    bool hasChar(String id) => db.saveWishes.getOwnedCharacter(id) > 0;
    return item.chars.any((c) => !chars.contains(c) && hasChar(c));
  }
}

extension SaveSpincrystalExt on JsonSaveDetails<SaveSpincrystal> {
  void updateSpincrystal(int number, {required bool obtained}) {
    final spin = SaveSpincrystal(
      id: number.toString(),
      obtained: obtained,
    );
    insertItem(spin);
  }
}

extension SaveRecipeExt on JsonSaveDetails<SaveRecipe> {
  void ownRecipe(String id, bool own) async {
    final contains = exists(id);
    if (own && !contains) {
      insertItem(SaveRecipe(id: id, proficiency: 0));
    } else if (!own && contains) {
      deleteItem(id);
    }
  }

  void changeSavedRecipe(String id, int proficiency) async {
    insertItem(SaveRecipe(id: id, proficiency: proficiency));
  }
}

extension SaveCharacterExt on JsonSaveDetails<SaveCharacter> {
  int getCharFriendship(String key) {
    final char = getItemOrNull(key);
    return char?.friendship.coerceAtLeast(1) ?? 1;
  }

  void setCharFriendship(String id, int friendship) {
    final char = getItemOrNull(id);
    final friend = friendship.clamp(1, 10);
    final item = (char ?? SaveCharacter(id: id)).copyWith(friendship: friend);
    if (item.friendship != char?.friendship) insertItem(item);
  }

  int getCharAscension(String id) {
    final char = getItemOrNull(id);
    return char?.ascension ?? 0;
  }

  bool getCharMaxAscended(String id) {
    final ascension = getCharAscension(id);
    return !(ascension + 1 < 7);
  }

  void increaseOwnedCharacter(String id) {
    final char = getItemOrNull(id);
    final wishes = GsDatabase.instance.saveWishes.countItem(id);

    var cOwned = (char?.owned ?? 0);
    cOwned = cOwned + 1 + wishes > 7 ? 0 : cOwned + 1;
    final item = (char ?? SaveCharacter(id: id)).copyWith(owned: cOwned);
    insertItem(item);
  }

  void increaseFriendshipCharacter(String id) {
    final char = getItemOrNull(id);
    var cFriendship = (char?.friendship) ?? 1;
    cFriendship = ((cFriendship + 1) % 11).coerceAtLeast(1);

    final item =
        (char ?? SaveCharacter(id: id)).copyWith(friendship: cFriendship);
    insertItem(item);
  }

  void increaseAscension(String id) {
    final char = getItemOrNull(id);
    var cAscension = char?.ascension ?? 0;
    cAscension = (cAscension + 1) % 7;
    final item =
        (char ?? SaveCharacter(id: id)).copyWith(ascension: cAscension);
    insertItem(item);
  }
}

extension SaveMaterialExt on JsonSaveDetails<SaveMaterial> {
  void changeAmount(String id, int amount) {
    insertItem(SaveMaterial(id: id, amount: amount));
  }

  int getMaterialAmount(String id) => getItemOrNull(id)?.amount ?? 0;

  int getCraftableAmount(String id) {
    final info = GsDatabase.instance.infoMaterials.getItemOrNull(id);
    if (info == null) return 0;
    return _getCraftableAmount(info);
  }

  int _getCraftableAmount(InfoMaterial mat) {
    int getCraftable(InfoMaterial e) =>
        getMaterialAmount(e.id) ~/ pow(3, mat.rarity - e.rarity);

    return GsDatabase.instance.infoMaterials
        .getSubGroup(mat)
        .where((e) => e.rarity < mat.rarity)
        .sumBy((e) => getCraftable(e))
        .toInt();
  }
}

// =============== Save extensions ===============

class GsDatabaseUtils {
  GsDatabaseUtils._();

  static List<AscendMaterial> getCharAscensionMats(String id, int level) {
    final db = GsDatabase.instance;
    final char = db.infoCharacters.getItemOrNull(id);
    if (char == null) return const [];

    final details = db.infoCharactersDetails.getItemOrNull(id);
    final witsAmount = db.infoDetails.data.getAscensionHerosWit(level);
    final materials = details?.ascension.elementAtOrNull(level)?.materials;
    return ((materials?.entries.toList() ?? [])
          ..insert(0, MapEntry('heros_wit', witsAmount)))
        .map((e) => AscendMaterial.fromId(e.key, e.value))
        .toList();
  }

  static List<AscendMaterial> getCharNextAscensionMats(String id) {
    final db = GsDatabase.instance;
    if (db.saveCharacters.getCharMaxAscended(id)) return const [];
    final ascension = db.saveCharacters.getCharAscension(id);
    return getCharAscensionMats(id, ascension + 1);
  }
}

class AscendMaterial {
  final int owned;
  final int required;
  final int craftable;
  final InfoMaterial? material;

  bool get hasRequired => owned + craftable >= required;

  AscendMaterial(
    this.owned,
    this.required,
    this.craftable,
    this.material,
  );

  factory AscendMaterial.fromId(String id, int required) {
    final db = GsDatabase.instance;
    final owned = db.saveMaterials.getMaterialAmount(id);
    final craft = db.saveMaterials.getCraftableAmount(id);
    final material = db.infoMaterials.getItemOrNull(id);
    return AscendMaterial(owned, required, craft, material);
  }

  factory AscendMaterial.combine(List<AscendMaterial> mats) {
    final valid = mats.where((e) => e.material != null);
    final first = valid.firstOrNull;
    if (first == null) return AscendMaterial(0, 0, 0, null);
    if (valid.map((e) => e.material!.id).toSet().length != 1) return first;
    return AscendMaterial(
      first.owned,
      valid.sumBy((e) => e.required).toInt(),
      first.craftable,
      first.material,
    );
  }
}
