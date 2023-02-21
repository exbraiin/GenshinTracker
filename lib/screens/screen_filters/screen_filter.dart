import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/enums/gs_weekday.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

class FilterSection<T, I> {
  final String? key;
  final Set<T> values;
  final Set<T> enabled;
  final bool Function(I item)? filter;
  final IconData? Function(T i)? _icon;
  final String? Function(T i)? _asset;
  final String Function(BuildContext c) title;
  final String Function(BuildContext c, T i) _label;
  final bool Function(I item, Set<T> enabled) match;

  FilterSection(
    this.values,
    T Function(I item) match,
    this.title,
    this._label, {
    this.key,
    this.filter,
    String? Function(T i)? asset,
    IconData? Function(T i)? icon,
  })  : enabled = {},
        _icon = icon,
        _asset = asset,
        match = ((item, enabled) => enabled.contains(match(item)));

  FilterSection.raw(
    this.values,
    this.match,
    this.title,
    this._label, {
    this.key,
    this.filter,
    String? Function(T i)? asset,
    IconData? Function(T i)? icon,
  })  : enabled = {},
        _icon = icon,
        _asset = asset;

  IconData? icon(T i) => _icon?.call(i);
  String? asset(T i) => _asset?.call(i);
  String label(BuildContext c, T i) => _label(c, i);

  bool _filter(I e) {
    if (enabled.isEmpty) return true;
    return (filter?.call(e) ?? true) && match.call(e, enabled);
  }

  void toggle(T v) => enabled.contains(v) ? enabled.remove(v) : enabled.add(v);
}

class ScreenFilter<I> {
  final Set<String> extras;
  final Iterable<Comparator<I>> sorting;
  final List<FilterSection<dynamic, I>> sections;

  ScreenFilter({
    this.sections = const [],
    this.sorting = const [],
    Set<String>? extras,
  }) : extras = extras ?? {};

  List<I> match(Iterable<I> items) {
    final sorters = _chain(sorting);
    final filtr = items.where((e) => sections.every((s) => s._filter(e)));
    return filtr.sortedWith(sorters);
  }

  void reset() {
    for (var section in sections) {
      section.enabled.clear();
    }
  }

  bool hasExtra(String key) {
    return extras.contains(key);
  }

  bool isDefault() {
    return sections
        .every((e) => e.values.length == e.enabled.length || e.enabled.isEmpty);
  }

  void toggleExtra(String key) =>
      extras.contains(key) ? extras.remove(key) : extras.add(key);

  bool isSectionEmpty(String key) =>
      sections.firstOrNullWhere((e) => e.key == key)?.enabled.isEmpty ?? true;
}

class ScreenFilters {
  static final _db = GsDatabase.instance;

  static String _toMajorVersion(String version) =>
      '${version.split('.').first}.x';
  static final _versions = GsDatabase.instance.infoVersion
      .getItems()
      .map((e) => _toMajorVersion(e.id))
      .toSet();
  static final _weekdays =
      GsWeekday.values.exceptElement(GsWeekday.sunday).toSet();

  static final itemDataFilter = ScreenFilter<ItemData>(
    sections: [
      FilterSection<GsItem, ItemData>(
        GsItem.values.toSet(),
        (item) => item.type,
        (c) => c.fromLabel(Labels.type),
        (c, e) => c.fromLabel(e.label),
      ),
      FilterSection<int, ItemData>(
        {3, 4, 5},
        (item) => item.rarity,
        (c) => c.fromLabel(Labels.rarity),
        (c, e) => c.fromLabel(Labels.rarityStar, e),
      ),
    ],
    sorting: [(a, b) => a.compareTo(b)],
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
  static final infoNamecardFilter = ScreenFilter<InfoNamecard>(
    sections: [
      FilterSection<String, InfoNamecard>(
        GsDatabase.instance.infoNamecards.getItems().map((e) => e.type).toSet(),
        (item) => item.type,
        (c) => c.fromLabel(Labels.type),
        (c, e) => e.capitalize(),
      ),
      FilterSection<String, InfoNamecard>(
        _versions,
        (item) => _toMajorVersion(item.version),
        (c) => c.fromLabel(Labels.version),
        (c, i) => i,
      ),
    ],
  );
  static final infoRecipeFilter = ScreenFilter<InfoRecipe>(
    sections: [
      FilterSection<int, InfoRecipe>(
        {1, 2, 3, 4, 5},
        (item) => item.rarity,
        (c) => c.fromLabel(Labels.rarity),
        (c, e) => c.fromLabel(Labels.rarityStar, e),
      ),
      FilterSection<GsRecipeBuff, InfoRecipe>(
        GsRecipeBuff.values.toSet(),
        (item) => item.effect,
        (c) => c.fromLabel(Labels.status),
        (c, i) => c.fromLabel(i.label),
        asset: (i) => i.assetPath,
      ),
      FilterSection<String, InfoRecipe>(
        _versions,
        (item) => _toMajorVersion(item.version),
        (c) => c.fromLabel(Labels.version),
        (c, i) => i,
      ),
      FilterSection<bool, InfoRecipe>(
        {true, false},
        (item) {
          if (item.baseRecipe.isNotEmpty) {
            final id = _db.infoCharacters
                .getItems()
                .firstOrNullWhere((e) => e.specialDish == item.id)
                ?.id;
            return GsUtils.characters.hasCaracter(id ?? '');
          }
          return _db.saveRecipes.exists(item.id);
        },
        (c) => c.fromLabel(Labels.status),
        (c, e) => c.fromLabel(e ? Labels.owned : Labels.unowned),
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
    sorting: [
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
      ),
      FilterSection<String, InfoRemarkableChest>(
        _versions,
        (item) => _toMajorVersion(item.version),
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
      FilterSection<GsSetCategory, InfoRemarkableChest>(
        GsSetCategory.values.toSet(),
        (item) => item.type,
        (c) => c.fromLabel(Labels.category),
        (c, i) => c.fromLabel(i.label),
      ),
      FilterSection<String, InfoRemarkableChest>(
        GsDatabase.instance.infoRemarkableChests
            .getItems()
            .map((e) => e.category)
            .toSet(),
        (item) => item.category,
        (c) => c.fromLabel(Labels.type),
        (c, i) => i.capitalize(),
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
      ),
      FilterSection<bool, InfoWeapon>(
        {true, false},
        (item) => _db.saveWishes.hasWeapon(item.id),
        (c) => c.fromLabel(Labels.status),
        (c, e) => c.fromLabel(e ? Labels.owned : Labels.unowned),
      ),
      FilterSection<GsWeekday, InfoWeapon>.raw(
        _weekdays,
        (item, enabled) {
          final t = _db.infoMaterials.getItems();
          final m = t.where((e) => e.weekdays.intersect(enabled).isNotEmpty);
          final inMats = _db.infoWeaponsInfo.getAscensionMaterials(item.id);
          return m.any((e) => inMats.containsKey(e.id));
        },
        (c) => c.fromLabel(Labels.materials),
        (c, i) => i.label,
        key: 'weekdays',
      ),
      FilterSection<GsAttributeStat, InfoWeapon>(
        GsAttributeStat.weaponStats,
        (item) => item.statType,
        (c) => c.fromLabel(Labels.ndStat),
        (c, i) => c.fromLabel(i.label),
        asset: (e) => e.assetPath,
      ),
      FilterSection<int, InfoWeapon>(
        {1, 2, 3, 4, 5},
        (item) => item.rarity,
        (c) => c.fromLabel(Labels.rarity),
        (c, e) => c.fromLabel(Labels.rarityStar, e),
      ),
      FilterSection<String, InfoWeapon>(
        _versions,
        (item) => _toMajorVersion(item.version),
        (c) => c.fromLabel(Labels.version),
        (c, i) => i,
      ),
      FilterSection<GsItemSource, InfoWeapon>(
        GsDatabase.instance.infoWeapons.getItems().map((e) => e.source).toSet(),
        (item) => item.source,
        (c) => c.fromLabel(Labels.source),
        (c, i) => c.fromLabel(i.name),
      ),
    ],
    sorting: [
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
      ),
      FilterSection<String, InfoArtifact>(
        _versions,
        (item) => _toMajorVersion(item.version),
        (c) => c.fromLabel(Labels.version),
        (c, i) => i,
      ),
    ],
    sorting: [
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
      ),
      FilterSection<GsWeapon, InfoCharacter>(
        GsWeapon.values.toSet(),
        (item) => item.weapon,
        (c) => c.fromLabel(Labels.weapon),
        (c, i) => c.fromLabel(i.label),
        asset: (i) => i.assetPath,
      ),
      FilterSection<GsWeekday, InfoCharacter>.raw(
        _weekdays,
        (item, enabled) {
          final t = _db.infoMaterials.getItems();
          final m = t.where((e) => e.weekdays.intersect(enabled).isNotEmpty);
          final charMats = _db.infoCharactersInfo.getTalentMaterials(item.id);
          return m.any((e) => charMats.containsKey(e.id));
        },
        (c) => c.fromLabel(Labels.materials),
        (c, i) => i.label,
        key: 'weekdays',
      ),
      FilterSection<String, InfoCharacter>(
        _versions,
        (item) => _toMajorVersion(item.version),
        (c) => c.fromLabel(Labels.version),
        (c, i) => i,
      ),
      FilterSection<GsRegion, InfoCharacter>(
        GsRegion.values.toSet(),
        (item) => item.region,
        (c) => c.fromLabel(Labels.region),
        (c, i) => c.fromLabel(i.label),
      ),
      FilterSection<GsAttributeStat, InfoCharacter>(
        GsAttributeStat.characterStats,
        (item) =>
            _db.infoCharactersInfo
                .getItemOrNull(item.id)
                ?.ascension
                .ascStatType ??
            GsAttributeStat.none,
        (c) => 'Special Stat',
        (c, i) => c.fromLabel(i.label),
      ),
      FilterSection<bool, InfoCharacter>(
        {true, false},
        (item) => GsUtils.characters.getCharFriendship(item.id) == 10,
        (c) => c.fromLabel(Labels.friendship),
        (c, i) => c.fromLabel(i ? Labels.max : Labels.ongoing),
        filter: (i) => GsUtils.characters.hasCaracter(i.id),
      ),
      FilterSection<bool, InfoCharacter>(
        {true, false},
        (item) => GsUtils.characters.hasCaracter(item.id),
        (c) => c.fromLabel(Labels.status),
        (c, i) => c.fromLabel(i ? Labels.owned : Labels.unowned),
      ),
      FilterSection<bool, InfoCharacter>(
        {true, false},
        (item) => GsUtils.characters.isCharMaxAscended(item.id),
        (c) => c.fromLabel(Labels.ascension),
        (c, i) => c.fromLabel(i ? Labels.max : Labels.ongoing),
        filter: (i) => GsUtils.characters.hasCaracter(i.id),
      ),
      FilterSection<int, InfoCharacter>(
        {4, 5},
        (item) => item.rarity,
        (c) => c.fromLabel(Labels.rarity),
        (c, i) => c.fromLabel(Labels.rarityStar, i),
      ),
    ],
    sorting: [
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
      ),
      FilterSection<GsSetCategory, InfoSereniteaSet>(
        GsSetCategory.values.toSet(),
        (item) => item.category,
        (c) => c.fromLabel(Labels.type),
        (c, e) => c.fromLabel(e.label),
      ),
      FilterSection<String, InfoSereniteaSet>(
        _versions,
        (item) => _toMajorVersion(item.version),
        (c) => c.fromLabel(Labels.version),
        (c, i) => i,
      ),
    ],
    sorting: [(a, b) => a.name.compareTo(b.name)],
  );
  static final infoSpincrystalFilter = ScreenFilter<InfoSpincrystal>(
    sections: [
      FilterSection<bool, InfoSpincrystal>(
        {true, false},
        (item) => _db.saveSpincrystals.exists(item.id),
        (c) => c.fromLabel(Labels.status),
        (c, e) => c.fromLabel(e ? Labels.owned : Labels.unowned),
      ),
      FilterSection<String, InfoSpincrystal>(
        _versions,
        (item) => _toMajorVersion(item.version),
        (c) => c.fromLabel(Labels.version),
        (c, i) => i,
      ),
    ],
    sorting: [(a, b) => a.number.compareTo(b.number)],
  );
  static final infoMaterialFilter = ScreenFilter<InfoMaterial>(
    sections: [
      FilterSection<int, InfoMaterial>(
        {1, 2, 3, 4, 5},
        (item) => item.rarity,
        (c) => c.fromLabel(Labels.rarity),
        (c, i) => c.fromLabel(Labels.rarityStar, i),
      ),
      FilterSection<String, InfoMaterial>(
        _versions,
        (item) => _toMajorVersion(item.version),
        (c) => c.fromLabel(Labels.version),
        (c, i) => i,
      ),
      FilterSection<GsMaterialGroup, InfoMaterial>(
        GsMaterialGroup.values.toSet(),
        (item) => item.group,
        (c) => c.fromLabel(Labels.category),
        (c, i) => c.fromLabel(i.label),
      ),
    ],
    sorting: [
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
