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

  static FilterSection<String, I> version<I>(String Function(I item) match) {
    String toMajorVersion(String version) => '${version.split('.').first}.x';
    return FilterSection(
      GsDatabase.instance.infoVersion
          .getItems()
          .map((e) => toMajorVersion(e.id))
          .toSet(),
      (item) => toMajorVersion(match(item)),
      (c) => c.fromLabel(Labels.version),
      (c, i) => i,
    );
  }

  static FilterSection<int, I> rarity<I>(
    int Function(I item) match, [
    int min = 1,
  ]) {
    return FilterSection(
      Iterable.generate(6 - min, (idx) => idx + min).toSet(),
      match,
      (c) => c.fromLabel(Labels.rarity),
      (c, i) => c.fromLabel(Labels.rarityStar, i),
    );
  }

  static FilterSection<GsRegion, I> region<I>(
    GsRegion Function(I item) match,
  ) {
    return FilterSection(
      GsRegion.values.toSet(),
      match,
      (c) => c.fromLabel(Labels.region),
      (c, i) => c.fromLabel(i.label),
    );
  }

  static FilterSection<GsWeapon, I> weapon<I>(GsWeapon Function(I item) match) {
    return FilterSection(
      GsWeapon.values.toSet(),
      match,
      (c) => c.fromLabel(Labels.weapon),
      (c, e) => c.fromLabel(e.label),
      asset: (e) => e.assetPath,
    );
  }

  static FilterSection<GsElement, I> element<I>(
    GsElement Function(I item) match,
  ) {
    return FilterSection(
      GsElement.values.toSet(),
      match,
      (c) => c.fromLabel(Labels.element),
      (c, i) => c.fromLabel(i.label),
    );
  }

  static FilterSection<GsItem, I> item<I>(GsItem Function(I item) match) {
    return FilterSection(
      GsItem.values.toSet(),
      match,
      (c) => c.fromLabel(Labels.type),
      (c, i) => c.fromLabel(i.label),
    );
  }

  static FilterSection<bool, I> owned<I>(bool Function(I item) match) {
    return FilterSection(
      {true, false},
      match,
      (c) => c.fromLabel(Labels.status),
      (c, i) => c.fromLabel(i ? Labels.owned : Labels.unowned),
    );
  }

  static FilterSection<GsSetCategory, I> setCategory<I>(
    GsSetCategory Function(I item) match,
  ) {
    return FilterSection(
      GsSetCategory.values.toSet(),
      match,
      (c) => c.fromLabel(Labels.category),
      (c, i) => c.fromLabel(i.label),
    );
  }

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

  static final _weekdays =
      GsWeekday.values.exceptElement(GsWeekday.sunday).toSet();
  static final _getItem = GsUtils.items.getItemData;

  static final itemDataFilter = ScreenFilter<ItemData>(
    sections: [
      FilterSection.item((item) => item.type),
      FilterSection.rarity((item) => item.rarity, 3),
    ],
    sorting: [(a, b) => a.compareTo(b)],
  );
  static final saveWishFilter = ScreenFilter<SaveWish>(
    sections: [
      FilterSection.item((item) => _getItem(item.itemId).type),
      FilterSection.rarity((item) => _getItem(item.itemId).rarity, 3),
    ],
    extras: {'show'},
  );
  static final infoNamecardFilter = ScreenFilter<InfoNamecard>(
    sections: [
      FilterSection<GsNamecardType, InfoNamecard>(
        GsNamecardType.values.toSet(),
        (item) => item.type,
        (c) => c.fromLabel(Labels.type),
        (c, e) => c.fromLabel(e.label),
      ),
      FilterSection.version((item) => item.version),
    ],
    sorting: [
      (a, b) => a.type.index.compareTo(b.type.index),
      (a, b) => a.name.compareTo(b.name),
    ],
  );
  static final infoRecipeFilter = ScreenFilter<InfoRecipe>(
    sections: [
      FilterSection.rarity((item) => item.rarity),
      FilterSection<GsRecipeBuff, InfoRecipe>(
        GsRecipeBuff.values.toSet(),
        (item) => item.effect,
        (c) => c.fromLabel(Labels.status),
        (c, i) => c.fromLabel(i.label),
        asset: (i) => i.assetPath,
      ),
      FilterSection.version((item) => item.version),
      FilterSection.owned(
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
      FilterSection<GsRecipeType, InfoRecipe>(
        GsRecipeType.values.toSet(),
        (item) => item.type,
        (c) => c.fromLabel(Labels.type),
        (c, i) => c.fromLabel(i.label),
      ),
    ],
    sorting: [
      (a, b) => b.rarity.compareTo(a.rarity),
      (a, b) => a.name.compareTo(b.name),
    ],
  );
  static final infoRemarkableChestFilter = ScreenFilter<InfoRemarkableChest>(
    sections: [
      FilterSection.rarity((item) => item.rarity),
      FilterSection.version((item) => item.version),
      FilterSection.region((item) => item.region),
      FilterSection.setCategory((item) => item.type),
      FilterSection<String, InfoRemarkableChest>(
        GsDatabase.instance.infoRemarkableChests
            .getItems()
            .map((e) => e.category)
            .toSet(),
        (item) => item.category,
        (c) => c.fromLabel(Labels.type),
        (c, i) => i.capitalize(),
      ),
      FilterSection.owned((item) => _db.saveRemarkableChests.exists(item.id)),
    ],
    sorting: [
      (a, b) => a.region.index.compareTo(b.region.index),
      (a, b) => a.rarity.compareTo(b.rarity),
      (a, b) => a.name.compareTo(b.name),
    ],
  );
  static final infoWeaponFilter = ScreenFilter<InfoWeapon>(
    sections: [
      FilterSection.weapon((item) => item.type),
      FilterSection.rarity((item) => item.rarity),
      FilterSection.version((item) => item.version),
      FilterSection.owned((item) => _db.saveWishes.hasWeapon(item.id)),
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
      FilterSection<GsItemSource, InfoWeapon>(
        GsDatabase.instance.infoWeapons.getItems().map((e) => e.source).toSet(),
        (item) => item.source,
        (c) => c.fromLabel(Labels.source),
        (c, i) => i.name.capitalize(),
      ),
    ],
    sorting: [
      (a, b) => b.rarity.compareTo(a.rarity),
      (a, b) => a.name.compareTo(b.name),
    ],
  );
  static final infoArtifactFilter = ScreenFilter<InfoArtifact>(
    sections: [
      FilterSection.rarity((item) => item.rarity, 3),
      FilterSection.version((item) => item.version),
    ],
    sorting: [
      (a, b) => b.rarity.compareTo(a.rarity),
      (a, b) => a.region.index.compareTo(b.region.index),
      (a, b) => a.version.compareTo(b.version),
      (a, b) => a.domain.compareTo(b.domain),
      (a, b) => a.name.compareTo(b.name),
    ],
  );
  static final infoCharacterFilter = ScreenFilter<InfoCharacter>(
    sections: [
      FilterSection.element((item) => item.element),
      FilterSection.weapon((item) => item.weapon),
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
      FilterSection.version((item) => item.version),
      FilterSection.region((item) => item.region),
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
      FilterSection.owned((item) => GsUtils.characters.hasCaracter(item.id)),
      FilterSection<bool, InfoCharacter>(
        {true, false},
        (item) => GsUtils.characters.isCharMaxAscended(item.id),
        (c) => c.fromLabel(Labels.ascension),
        (c, i) => c.fromLabel(i ? Labels.max : Labels.ongoing),
        filter: (i) => GsUtils.characters.hasCaracter(i.id),
      ),
      FilterSection.rarity((item) => item.rarity, 4),
    ],
    sorting: [
      (a, b) => b.rarity.compareTo(a.rarity),
      (a, b) => a.name.compareTo(b.name),
    ],
  );
  static final infoSereniteaSetFilter = ScreenFilter<InfoSereniteaSet>(
    sections: [
      FilterSection.version((item) => item.version),
      FilterSection.setCategory((item) => item.category),
      FilterSection<bool, InfoSereniteaSet>(
        {true, false},
        (item) => _db.saveSereniteaSets.isObtainable(item.id),
        (c) => c.fromLabel(Labels.status),
        (c, e) => c.fromLabel(e ? Labels.obtainable : Labels.owned),
      ),
    ],
    sorting: [(a, b) => a.name.compareTo(b.name)],
  );
  static final infoSpincrystalFilter = ScreenFilter<InfoSpincrystal>(
    sections: [
      FilterSection.owned((item) => _db.saveSpincrystals.exists(item.id)),
      FilterSection.version((item) => item.version),
    ],
    sorting: [(a, b) => a.number.compareTo(b.number)],
  );
  static final infoMaterialFilter = ScreenFilter<InfoMaterial>(
    sections: [
      FilterSection.rarity((item) => item.rarity),
      FilterSection.version((item) => item.version),
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
      (a, b) => a.region.index.compareTo(b.region.index),
      (a, b) => a.rarity.compareTo(b.rarity),
      (a, b) => a.name.compareTo(b.name),
    ],
  );
}

Comparator<E> _chain<E>(Iterable<Comparator<E>> selectors) {
  return selectors.fold((a, b) => 0, (p, e) => p.compose(e));
}
