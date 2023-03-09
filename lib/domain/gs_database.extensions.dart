import 'package:dartx/dartx_io.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_database.json.dart';
import 'package:tracker/domain/gs_domain.dart';

// =============== Save extensions ===============

extension SaveWishesExt on JsonSaveDetails<SaveWish> {
  void removeLastWish(String bannerId) {
    final list = GsUtils.wishes.getBannerWishes(bannerId);
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
    final lastRoll = GsUtils.wishes.countBannerWishes(bannerId);
    var i = 0;
    for (var id in ids) {
      final number = lastRoll + 1 + i++;
      final wish = SaveWish(
        id: '${bannerId}_$number',
        date: date,
        itemId: id,
        number: number,
        bannerId: bannerId,
      );
      insertItem(wish);
    }
  }
}

extension SaveCharacterExt on JsonSaveDetails<SaveCharacter> {
  void setCharOutfit(String id, String outfit) {
    final char = getItemOrNull(id);
    final item = (char ?? SaveCharacter(id: id)).copyWith(outfit: outfit);
    if (item.outfit != char?.outfit) insertItem(item);
  }

  void setCharFriendship(String id, int friendship) {
    final char = getItemOrNull(id);
    final friend = friendship.clamp(1, 10);
    final item = (char ?? SaveCharacter(id: id)).copyWith(friendship: friend);
    if (item.friendship != char?.friendship) insertItem(item);
  }

  void increaseOwnedCharacter(String id) {
    final char = getItemOrNull(id);
    final wishes = GsUtils.wishes.countItem(id);

    var cOwned = char?.owned ?? 0;
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

// =============== Ascend Materials ===============

class AscendMaterial {
  final int required;
  final InfoMaterial? material;

  AscendMaterial(
    this.required,
    this.material,
  );

  factory AscendMaterial.fromId(String id, int required) {
    final db = GsDatabase.instance;
    final material = db.infoMaterials.getItemOrNull(id);
    return AscendMaterial(required, material);
  }

  factory AscendMaterial.combine(List<AscendMaterial> mats) {
    final valid = mats.where((e) => e.material != null);
    final first = valid.firstOrNull;
    if (first == null) return AscendMaterial(0, null);
    if (valid.map((e) => e.material!.id).toSet().length != 1) return first;
    return AscendMaterial(
      valid.sumBy((e) => e.required).toInt(),
      first.material,
    );
  }
}
