import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

class FilterSection<T, I> {
  final Set<T> values;
  final Set<T> enabled;
  final T Function(I item) match;
  final bool Function(I item)? filter;
  final IconData? Function(T i)? _icon;
  final String? Function(T i)? _asset;
  final String Function(BuildContext c) title;
  final String Function(BuildContext c, T i) _label;

  int order = 1;
  final Comparator<I>? comparator;

  FilterSection(
    this.values,
    this.match,
    this.title,
    this._label, {
    this.filter,
    String? Function(T i)? asset,
    IconData? Function(T i)? icon,
    this.comparator,
  })  : enabled = {},
        _icon = icon,
        _asset = asset;

  IconData? icon(T i) => _icon?.call(i);
  String? asset(T i) => _asset?.call(i);
  String label(BuildContext c, T i) => _label(c, i);

  bool _filter(I e) {
    if (enabled.isEmpty) return true;
    return (filter?.call(e) ?? true) && enabled.contains(match(e));
  }

  void toggle(T v) => enabled.contains(v) ? enabled.remove(v) : enabled.add(v);
}

class ScreenFilter<I> {
  final Set<String> extras;
  final Iterable<Comparator<I>> comparators;
  final List<FilterSection<dynamic, I>> sorting = [];
  final List<FilterSection<dynamic, I>> sections;

  ScreenFilter({
    this.sections = const [],
    this.comparators = const [],
    Set<String>? extras,
  }) : extras = extras ?? {};

  List<I> match(Iterable<I> items) {
    final compt = _chain(comparators);
    final order = _chain(sorting.map((e) => e.comparator!.ordered(e.order)));
    final filtr = items.where((e) => sections.every((s) => s._filter(e)));
    return filtr.sortedWith(order).thenWith(compt);
  }

  void reset() {
    sorting.clear();
    for (var section in sections) {
      section.enabled.clear();
    }
  }

  bool hasExtra(String key) {
    return extras.contains(key);
  }

  bool isDefault() {
    return sections.every(
        (e) => e.values.length == e.enabled.length || e.enabled.length == 0);
  }

  void toggleExtra(String key) =>
      extras.contains(key) ? extras.remove(key) : extras.add(key);

  void addSort(FilterSection<dynamic, I> section) {
    if (sorting.contains(section)) {
      if (section.order == 1) {
        section.order = -1;
        sorting.remove(section);
        sorting.add(section);
      } else {
        section.order = 1;
        sorting.remove(section);
      }
    } else {
      section.order = 1;
      sorting.add(section);
    }
  }
}

class ScreenFilters {
  static final _db = GsDatabase.instance;
  static final itemDataFilter = ScreenFilter<ItemData>(
    sections: [
      FilterSection<GsItem, ItemData>(
        GsItem.values.toSet(),
        (item) => item.type,
        (c) => c.fromLabel(Labels.type),
        (c, e) => c.fromLabel(e.label),
        comparator: (a, b) => a.type.index.compareTo(b.type.index),
      ),
      FilterSection<int, ItemData>(
        {3, 4, 5},
        (item) => item.rarity,
        (c) => c.fromLabel(Labels.rarity),
        (c, e) => c.fromLabel(Labels.rarityStar, e),
        comparator: (a, b) => a.rarity.compareTo(b.rarity),
      ),
    ],
    comparators: [(a, b) => a.compareTo(b)],
  );
  static final saveWishFilter = ScreenFilter<SaveWish>(
    sections: [
      FilterSection<GsItem, SaveWish>(
        GsItem.values.toSet(),
        (item) => GsUtils.items.getItemData(item.itemId).type,
        (c) => c.fromLabel(Labels.type),
        (c, e) => c.fromLabel(e.label),
      ),
      FilterSection<int, SaveWish>(
        {3, 4, 5},
        (item) => GsUtils.items.getItemData(item.itemId).rarity,
        (c) => c.fromLabel(Labels.rarity),
        (c, e) => c.fromLabel(Labels.rarityStar, e),
      ),
    ],
    extras: {'show'},
  );
  static final infoRecipeFilter = ScreenFilter<InfoRecipe>(
    sections: [
      FilterSection<int, InfoRecipe>(
        {1, 2, 3, 4, 5},
        (item) => item.rarity,
        (c) => c.fromLabel(Labels.rarity),
        (c, e) => c.fromLabel(Labels.rarityStar, e),
        comparator: (a, b) => a.rarity.compareTo(b.rarity),
      ),
      FilterSection<GsRecipeBuff, InfoRecipe>(
        GsRecipeBuff.values.toSet(),
        (item) => item.effect,
        (c) => c.fromLabel(Labels.status),
        (c, i) => c.fromLabel(i.label),
        asset: (i) => i.assetPath,
      ),
      FilterSection<String, InfoRecipe>(
        {'1.x', '2.x', '3.x'},
        (item) => '${item.version.split('.').firstOrNull ?? ''}.x',
        (c) => c.fromLabel(Labels.version),
        (c, i) => i,
        comparator: (a, b) => a.version.compareTo(b.version),
      ),
      FilterSection<bool, InfoRecipe>(
        {true, false},
        (item) => _db.saveRecipes.exists(item.id),
        (c) => c.fromLabel(Labels.status),
        (c, e) => c.fromLabel(e ? Labels.owned : Labels.unowned),
        filter: (i) => i.baseRecipe.isEmpty,
      ),
      FilterSection<bool, InfoRecipe>(
        {true, false},
        (item) =>
            _db.saveRecipes.getItemOrNull(item.id)?.proficiency ==
            item.maxProficiency,
        (c) => c.fromLabel(Labels.proficiency),
        (c, e) => c.fromLabel(e ? Labels.master : Labels.ongoing),
        filter: (i) => _db.saveRecipes.exists(i.id),
      ),
      FilterSection<bool, InfoRecipe>(
        {true, false},
        (item) => item.baseRecipe.isNotEmpty,
        (c) => c.fromLabel(Labels.specialDish),
        (c, e) => c.fromLabel(e ? Labels.specialDish : Labels.wsNone),
      ),
    ],
    comparators: [
      (a, b) => b.rarity.compareTo(a.rarity),
      (a, b) => a.name.compareTo(b.name),
    ],
  );
  static final infoRemarkableChestFilter = ScreenFilter<InfoRemarkableChest>(
    sections: [
      FilterSection<int, InfoRemarkableChest>(
        {1, 2, 3, 4, 5},
        (item) => item.rarity,
        (c) => c.fromLabel(Labels.rarity),
        (c, e) => c.fromLabel(Labels.rarityStar, e),
        comparator: (a, b) => a.rarity.compareTo(b.rarity),
      ),
      FilterSection<String, InfoRemarkableChest>(
        _db.infoRemarkableChests
            .getItems()
            .map((e) => e.version)
            .toSet()
            .sorted()
            .toSet(),
        (item) => item.version,
        (c) => c.fromLabel(Labels.version),
        (c, i) => i,
      ),
      FilterSection<String, InfoRemarkableChest>(
        _db.infoRemarkableChests
            .getItems()
            .map((e) => e.source)
            .toSet()
            .sorted()
            .toSet(),
        (item) => item.source,
        (c) => c.fromLabel(Labels.source),
        (c, i) => i,
      ),
      FilterSection<bool, InfoRemarkableChest>(
        {true, false},
        (item) => _db.saveRemarkableChests.exists(item.id),
        (c) => c.fromLabel(Labels.status),
        (c, e) => c.fromLabel(e ? Labels.owned : Labels.unowned),
      ),
    ],
  );
  static final infoWeaponFilter = ScreenFilter<InfoWeapon>(
    sections: [
      FilterSection<GsWeapon, InfoWeapon>(
        GsWeapon.values.toSet(),
        (item) => item.type,
        (c) => c.fromLabel(Labels.weapon),
        (c, e) => c.fromLabel(e.label),
        asset: (e) => e.assetPath,
        comparator: (a, b) => a.type.index.compareTo(b.type.index),
      ),
      FilterSection<bool, InfoWeapon>(
        {true, false},
        (item) => _db.saveWishes.hasWeapon(item.id),
        (c) => c.fromLabel(Labels.status),
        (c, e) => c.fromLabel(e ? Labels.owned : Labels.unowned),
        comparator: (a, b) => _db.saveWishes
            .hasWeapon(a.id)
            .compareTo(_db.saveWishes.hasWeapon(b.id)),
      ),
      FilterSection<GsAttributeStat, InfoWeapon>(
        GsAttributeStat.values.weaponStats,
        (item) => item.statType,
        (c) => c.fromLabel(Labels.ndStat),
        (c, i) => c.fromLabel(i.label),
        asset: (e) => e.assetPath,
        comparator: (a, b) => a.statType.index.compareTo(b.statType.index),
      ),
      FilterSection<int, InfoWeapon>(
        {1, 2, 3, 4, 5},
        (item) => item.rarity,
        (c) => c.fromLabel(Labels.rarity),
        (c, e) => c.fromLabel(Labels.rarityStar, e),
        comparator: (a, b) => a.rarity.compareTo(b.rarity),
      ),
    ],
    comparators: [
      (a, b) => b.rarity.compareTo(a.rarity),
      (a, b) => a.name.compareTo(b.name),
    ],
  );
  static final infoArtifactFilter = ScreenFilter<InfoArtifact>(
    sections: [
      FilterSection<int, InfoArtifact>(
        {3, 4, 5},
        (item) => item.rarity,
        (c) => c.fromLabel(Labels.rarity),
        (c, i) => c.fromLabel(Labels.rarityStar, i),
        comparator: (a, b) => a.rarity.compareTo(b.rarity),
      ),
    ],
    comparators: [
      (a, b) => b.rarity.compareTo(a.rarity),
      (a, b) => a.name.compareTo(b.name),
    ],
  );
  static final infoCharacterFilter = ScreenFilter<InfoCharacter>(
    sections: [
      FilterSection<GsElement, InfoCharacter>(
        GsElement.values.toSet(),
        (item) => item.element,
        (c) => c.fromLabel(Labels.element),
        (c, i) => c.fromLabel(i.label),
        asset: (i) => i.assetPath,
        comparator: (a, b) => a.element.index.compareTo(b.element.index),
      ),
      FilterSection<GsWeapon, InfoCharacter>(
        GsWeapon.values.toSet(),
        (item) => item.weapon,
        (c) => c.fromLabel(Labels.weapon),
        (c, i) => c.fromLabel(i.label),
        asset: (i) => i.assetPath,
        comparator: (a, b) => a.weapon.index.compareTo(b.weapon.index),
      ),
      FilterSection<String, InfoCharacter>(
        {'1.x', '2.x', '3.x'},
        (item) => '${item.version.split('.').first}.x',
        (c) => c.fromLabel(Labels.version),
        (c, i) => i,
        comparator: (a, b) => a.version.compareTo(b.version),
      ),
      FilterSection<GsRegion, InfoCharacter>(
        GsRegion.values.toSet(),
        (item) => item.region,
        (c) => c.fromLabel(Labels.region),
        (c, i) => c.fromLabel(i.label),
        comparator: (a, b) => a.region.index.compareTo(b.region.index),
      ),
      FilterSection<GsAttributeStat, InfoCharacter>(
        GsAttributeStat.values.characterStats,
        (item) =>
            _db.infoCharactersInfo
                .getItemOrNull(item.id)
                ?.ascension
                .ascStatType ??
            GsAttributeStat.none,
        (c) => 'Special Stat',
        (c, i) => c.fromLabel(i.label),
        comparator: (a, b) => a.region.index.compareTo(b.region.index),
      ),
      FilterSection<bool, InfoCharacter>(
        {true, false},
        (item) => GsUtils.characters.getCharFriendship(item.id) == 10,
        (c) => c.fromLabel(Labels.friendship),
        (c, i) => c.fromLabel(i ? Labels.max : Labels.ongoing),
        filter: (i) => GsUtils.characters.hasCaracter(i.id),
        comparator: (a, b) => GsUtils.characters
            .getCharFriendship(a.id)
            .compareTo(GsUtils.characters.getCharFriendship(b.id)),
      ),
      FilterSection<bool, InfoCharacter>(
        {true, false},
        (item) => GsUtils.characters.hasCaracter(item.id),
        (c) => c.fromLabel(Labels.status),
        (c, i) => c.fromLabel(i ? Labels.owned : Labels.unowned),
        comparator: (a, b) => GsUtils.characters
            .hasCaracter(a.id)
            .compareTo(GsUtils.characters.hasCaracter(b.id)),
      ),
      FilterSection<bool, InfoCharacter>(
        {true, false},
        (item) => GsUtils.characters.isCharMaxAscended(item.id),
        (c) => c.fromLabel(Labels.ascension),
        (c, i) => c.fromLabel(i ? Labels.max : Labels.ongoing),
        filter: (i) => GsUtils.characters.hasCaracter(i.id),
        comparator: (a, b) => GsUtils.characters
            .getCharAscension(a.id)
            .compareTo(GsUtils.characters.getCharAscension(b.id)),
      ),
      FilterSection<int, InfoCharacter>(
        {4, 5},
        (item) => item.rarity,
        (c) => c.fromLabel(Labels.rarity),
        (c, i) => c.fromLabel(Labels.rarityStar, i),
        comparator: (a, b) => a.rarity.compareTo(b.rarity),
      ),
    ],
    comparators: [
      (a, b) => b.rarity.compareTo(a.rarity),
      (a, b) => a.name.compareTo(b.name),
    ],
  );
  static final infoSereniteaSetFilter = ScreenFilter<InfoSereniteaSet>(
    sections: [
      FilterSection<bool, InfoSereniteaSet>(
        {true, false},
        (item) => _db.saveSereniteaSets.isObtainable(item.id),
        (c) => c.fromLabel(Labels.status),
        (c, e) => c.fromLabel(e ? Labels.obtainable : Labels.owned),
        comparator: (a, b) => _db.saveSereniteaSets
            .isObtainable(a.id)
            .compareTo(_db.saveSereniteaSets.isObtainable(b.id)),
      ),
      FilterSection<GsSetCategory, InfoSereniteaSet>(
        GsSetCategory.values.toSet(),
        (item) => item.category,
        (c) => c.fromLabel(Labels.type),
        (c, e) => c.fromLabel(e.label),
        comparator: (a, b) => a.category.index.compareTo(b.category.index),
      ),
    ],
    comparators: [(a, b) => a.name.compareTo(b.name)],
  );
  static final infoSpincrystalFilter = ScreenFilter<InfoSpincrystal>(
    sections: [
      FilterSection<bool, InfoSpincrystal>(
        {true, false},
        (item) => _db.saveSpincrystals.exists(item.id),
        (c) => c.fromLabel(Labels.status),
        (c, e) => c.fromLabel(e ? Labels.owned : Labels.unowned),
        comparator: (a, b) => _db.saveSpincrystals
            .exists(a.id)
            .compareTo(_db.saveSpincrystals.exists(b.id)),
      ),
    ],
    comparators: [(a, b) => a.number.compareTo(b.number)],
  );
  static final infoMaterialFilter = ScreenFilter<InfoMaterial>(
    sections: [
      FilterSection<int, InfoMaterial>(
        {1, 2, 3, 4, 5},
        (item) => item.rarity,
        (c) => c.fromLabel(Labels.rarity),
        (c, i) => c.fromLabel(Labels.rarityStar, i),
      ),
      FilterSection<GsMaterialGroup, InfoMaterial>(
        GsMaterialGroup.values.toSet(),
        (item) => item.group,
        (c) => c.fromLabel(Labels.category),
        (c, i) => c.fromLabel(i.label),
      ),
    ],
    comparators: [
      (a, b) => a.group.index.compareTo(b.group.index),
      (a, b) => a.subgroup.compareTo(b.subgroup),
      (a, b) => a.rarity.compareTo(b.rarity),
      (a, b) => a.name.compareTo(b.name),
    ],
  );
}

Comparator<E> _chain<E>(Iterable<Comparator<E>> selectors) {
  return selectors.fold((a, b) => 0, (p, e) => p.compose(e));
}

extension<E> on Comparator<E> {
  Comparator<E> ordered(int order) => (a, b) => this(a, b) * order;
}

extension on bool {
  int compareTo(bool other) => (this ? 1 : 0).compareTo(other ? 1 : 0);
}
