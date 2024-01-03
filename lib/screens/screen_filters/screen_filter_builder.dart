import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/enums/enum_ext.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/widgets/button.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';

typedef FilterBuilder<T extends GsModel<T>> = Widget Function(
  BuildContext context,
  ScreenFilter<T> filter,
  Widget button,
  void Function(String extra) toggle,
);

class ScreenFilterBuilder<T extends GsModel<T>> extends StatelessWidget {
  final notifier = ValueNotifier(false);
  final FilterBuilder<T> builder;

  ScreenFilterBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final filter = ScreenFilters.of<T>()!;
    return ValueListenableBuilder<bool>(
      valueListenable: notifier,
      builder: (context, value, child) {
        final button = IconButton(
          onPressed: () => _GsFilterDialog.show(context, filter)
              .then((value) => notifier.value = !notifier.value),
          icon: const Icon(Icons.filter_alt_rounded),
        );
        return builder(context, filter, button, (v) {
          filter.toggleExtra(v);
          notifier.value = !notifier.value;
        });
      },
    );
  }
}

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
      Database.instance
          .infoOf<GsVersion>()
          .items
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

  static FilterSection<GeRegionType, I> region<I>(
    GeRegionType Function(I item) match,
  ) {
    return FilterSection(
      GeRegionType.values.toSet(),
      match,
      (c) => c.fromLabel(Labels.region),
      (c, i) => c.fromLabel(i.label),
    );
  }

  static FilterSection<GeWeaponType, I> weapon<I>(
    GeWeaponType Function(I item) match,
  ) {
    return FilterSection(
      GeWeaponType.values.toSet(),
      match,
      (c) => c.fromLabel(Labels.weapon),
      (c, e) => c.fromLabel(e.label),
      asset: (e) => e.assetPath,
    );
  }

  static FilterSection<GeElementType, I> element<I>(
    GeElementType Function(I item) match,
  ) {
    return FilterSection(
      GeElementType.values.toSet(),
      match,
      (c) => c.fromLabel(Labels.element),
      (c, i) => c.fromLabel(i.label),
      asset: (i) => i.assetPath,
    );
  }

  static FilterSection<bool, I> item<I>(bool Function(I item) match) {
    return FilterSection(
      {true, false},
      match,
      (c) => c.fromLabel(Labels.type),
      (c, i) => c.fromLabel(i ? Labels.weapon : Labels.character),
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

  static FilterSection<GeSereniteaSetType, I> setCategory<I>(
    GeSereniteaSetType Function(I item) match,
  ) {
    return FilterSection(
      GeSereniteaSetType.values.toSet(),
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

class ScreenFilter<I extends GsModel<I>> {
  final _extras = <String>{};
  final List<FilterSection<dynamic, I>> sections;

  ScreenFilter(this.sections);

  Iterable<I> match(Iterable<I> items) {
    return items.where((e) => sections.every((s) => s._filter(e)));
  }

  void reset() {
    for (var section in sections) {
      section.enabled.clear();
    }
  }

  bool hasExtra(String key) {
    return _extras.contains(key);
  }

  bool isDefault() {
    return sections
        .every((e) => e.values.length == e.enabled.length || e.enabled.isEmpty);
  }

  void toggleExtra(String key) =>
      _extras.contains(key) ? _extras.remove(key) : _extras.add(key);

  bool isSectionEmpty(String key) =>
      sections.firstOrNullWhere((e) => e.key == key)?.enabled.isEmpty ?? true;
}

class ScreenFilters {
  static final _db = Database.instance;

  static final _weekdays =
      GeWeekdayType.values.exceptElement(GeWeekdayType.sunday).toSet();
  static final _getItem = GsUtils.items.getItemData;

  static ScreenFilter<T>? of<T extends GsModel<T>>() {
    return switch (T) {
      const (GsWish) => ScreenFilter<GsWish>([
          FilterSection.item((item) => item.isWeapon),
          FilterSection.rarity((item) => item.rarity, 3),
        ]),
      const (GiWish) => ScreenFilter<GiWish>([
          FilterSection.item((item) => _getItem(item.itemId).isWeapon),
          FilterSection.rarity((item) => _getItem(item.itemId).rarity, 3),
        ]),
      const (GsAchievement) => ScreenFilter<GsAchievement>([
          FilterSection<bool, GsAchievement>(
            {true, false},
            (item) => item.hidden,
            (c) => c.fromLabel(Labels.achHidden),
            (c, e) => c.fromLabel(e ? Labels.achHidden : Labels.achVisible),
          ),
          FilterSection<GeAchievementType, GsAchievement>(
            GeAchievementType.values.toSet(),
            (item) => item.type,
            (c) => c.fromLabel(Labels.type),
            (c, e) => c.fromLabel(e.label),
          ),
          FilterSection<bool, GsAchievement>(
            {true, false},
            (item) => GsUtils.achievements.isObtainable(item.id),
            (c) => c.fromLabel(Labels.status),
            (c, e) => c.fromLabel(e ? Labels.obtainable : Labels.owned),
          ),
          FilterSection.version((item) => item.version),
        ]),
      const (GsEnemy) => ScreenFilter<GsEnemy>([
          FilterSection<GeEnemyType, GsEnemy>(
            GeEnemyType.values.toSet(),
            (item) => item.type,
            (c) => c.fromLabel(Labels.type),
            (c, i) => c.fromLabel(i.label),
          ),
          FilterSection<GeEnemyFamilyType, GsEnemy>(
            GeEnemyFamilyType.values.toSet(),
            (item) => item.family,
            (c) => c.fromLabel(Labels.family),
            (c, i) => c.fromLabel(i.label),
          ),
          FilterSection.version((item) => item.version),
        ]),
      const (GsNamecard) => ScreenFilter<GsNamecard>([
          FilterSection<GeNamecardType, GsNamecard>(
            GeNamecardType.values.toSet(),
            (item) => item.type,
            (c) => c.fromLabel(Labels.type),
            (c, e) => c.fromLabel(e.label),
          ),
          FilterSection.version((item) => item.version),
        ]),
      const (GsRecipe) => ScreenFilter<GsRecipe>([
          FilterSection.rarity((item) => item.rarity),
          FilterSection<GeRecipeEffectType, GsRecipe>(
            GeRecipeEffectType.values.toSet(),
            (item) => item.effect,
            (c) => c.fromLabel(Labels.status),
            (c, i) => c.fromLabel(i.label),
            asset: (i) => i.assetPath,
          ),
          FilterSection.version((item) => item.version),
          FilterSection.owned(
            (item) {
              if (item.baseRecipe.isNotEmpty) {
                final id = _db
                    .infoOf<GsCharacter>()
                    .items
                    .firstOrNullWhere((e) => e.specialDish == item.id)
                    ?.id;
                return GsUtils.characters.hasCaracter(id ?? '');
              }
              return _db.saveOf<GiRecipe>().exists(item.id);
            },
          ),
          FilterSection<bool, GsRecipe>(
            {true, false},
            (item) =>
                _db.saveOf<GiRecipe>().getItem(item.id)?.proficiency ==
                item.maxProficiency,
            (c) => c.fromLabel(Labels.proficiency),
            (c, e) => c.fromLabel(e ? Labels.master : Labels.ongoing),
            filter: (i) => _db.saveOf<GiRecipe>().exists(i.id),
          ),
          FilterSection<bool, GsRecipe>(
            {true, false},
            (item) => item.baseRecipe.isNotEmpty,
            (c) => c.fromLabel(Labels.specialDish),
            (c, e) => c.fromLabel(e ? Labels.specialDish : Labels.wsNone),
          ),
          FilterSection<GeRecipeType, GsRecipe>(
            GeRecipeType.values.toSet(),
            (item) => item.type,
            (c) => c.fromLabel(Labels.type),
            (c, i) => c.fromLabel(i.label),
          ),
        ]),
      const (GsFurnitureChest) => ScreenFilter<GsFurnitureChest>([
          FilterSection.rarity((item) => item.rarity),
          FilterSection.version((item) => item.version),
          FilterSection.region((item) => item.region),
          FilterSection.setCategory((item) => item.type),
          FilterSection.owned(
            (item) => _db.saveOf<GiFurnitureChest>().exists(item.id),
          ),
        ]),
      const (GsWeapon) => ScreenFilter<GsWeapon>([
          FilterSection.weapon((item) => item.type),
          FilterSection.rarity((item) => item.rarity),
          FilterSection.version((item) => item.version),
          FilterSection.owned((item) => GsUtils.wishes.hasItem(item.id)),
          FilterSection<GeWeekdayType, GsWeapon>.raw(
            _weekdays,
            (item, enabled) {
              final t = _db.infoOf<GsMaterial>().items;
              final m =
                  t.where((e) => e.weekdays.intersect(enabled).isNotEmpty);
              final i = GsUtils.weaponMaterials.getAscensionMaterials(item.id);
              return m.any((e) => i.containsKey(e.id));
            },
            (c) => c.fromLabel(Labels.materials),
            (c, i) => i.getLabel(c),
            key: 'weekdays',
          ),
          FilterSection<GeWeaponAscStatType, GsWeapon>(
            GeWeaponAscStatType.values.toSet(),
            (item) => item.statType,
            (c) => c.fromLabel(Labels.ndStat),
            (c, i) => c.fromLabel(i.label),
            asset: (e) => e.assetPath,
          ),
          FilterSection<GeItemSourceType, GsWeapon>(
            Database.instance
                .infoOf<GsWeapon>()
                .items
                .map((e) => e.source)
                .toSet(),
            (item) => item.source,
            (c) => c.fromLabel(Labels.source),
            (c, i) => i.name.capitalize(),
          ),
        ]),
      const (GsArtifact) => ScreenFilter<GsArtifact>([
          FilterSection.rarity((item) => item.rarity, 3),
          FilterSection.version((item) => item.version),
        ]),
      const (GsCharacter) => ScreenFilter<GsCharacter>([
          FilterSection.element((item) => item.element),
          FilterSection.weapon((item) => item.weapon),
          FilterSection<GeWeekdayType, GsCharacter>.raw(
            _weekdays,
            (item, enabled) {
              final t = _db.infoOf<GsMaterial>().items;
              final m =
                  t.where((e) => e.weekdays.intersect(enabled).isNotEmpty);
              final i = GsUtils.characterMaterials.getTalentMaterials(item.id);
              return m.any((e) => i.containsKey(e.id));
            },
            (c) => c.fromLabel(Labels.materials),
            (c, i) => i.getLabel(c),
            key: 'weekdays',
          ),
          FilterSection.version((item) => item.version),
          FilterSection.region((item) => item.region),
          FilterSection<GeCharacterAscStatType, GsCharacter>(
            GeCharacterAscStatType.values.toSet(),
            (item) => item.ascStatType,
            (c) => 'Special Stat',
            (c, i) => c.fromLabel(i.label),
            asset: (i) => i.assetPath,
          ),
          FilterSection<bool, GsCharacter>(
            {true, false},
            (item) => GsUtils.characters.getCharFriendship(item.id) == 10,
            (c) => c.fromLabel(Labels.friendship),
            (c, i) => c.fromLabel(i ? Labels.max : Labels.ongoing),
            filter: (i) => GsUtils.characters.hasCaracter(i.id),
          ),
          FilterSection.owned((e) => GsUtils.characters.hasCaracter(e.id)),
          FilterSection<bool, GsCharacter>(
            {true, false},
            (item) => GsUtils.characters.isCharMaxAscended(item.id),
            (c) => c.fromLabel(Labels.ascension),
            (c, i) => c.fromLabel(i ? Labels.max : Labels.ongoing),
            filter: (i) => GsUtils.characters.hasCaracter(i.id),
          ),
          FilterSection.rarity((item) => item.rarity, 4),
        ]),
      const (GsSereniteaSet) => ScreenFilter<GsSereniteaSet>([
          FilterSection.version((item) => item.version),
          FilterSection.setCategory((item) => item.category),
          FilterSection<bool, GsSereniteaSet>(
            {true, false},
            (item) => GsUtils.sereniteaSets.isCraftable(item.id),
            (c) => c.fromLabel(Labels.craftable),
            (c, i) => c.fromLabel(i ? Labels.buttonYes : Labels.buttonNo),
          ),
          FilterSection<bool, GsSereniteaSet>(
            {true, false},
            (item) => GsUtils.sereniteaSets.isObtainable(item.id),
            (c) => c.fromLabel(Labels.status),
            (c, e) => c.fromLabel(e ? Labels.obtainable : Labels.owned),
          ),
        ]),
      const (GsSpincrystal) => ScreenFilter<GsSpincrystal>([
          FilterSection.owned(
            (item) => _db.saveOf<GiSpincrystal>().exists(item.id),
          ),
          FilterSection.version((item) => item.version),
          FilterSection(
            {true, false},
            (item) => item.fromChubby,
            (c) => c.fromLabel(Labels.source),
            (c, i) => c.fromLabel(i ? Labels.chubby : Labels.world),
          ),
        ]),
      const (GsMaterial) => ScreenFilter<GsMaterial>([
          FilterSection.rarity((item) => item.rarity),
          FilterSection.version((item) => item.version),
          FilterSection(
            {true},
            (item) => item.ingredient,
            (c) => c.fromLabel(Labels.ingredients),
            (c, i) => c.fromLabel(Labels.buttonYes),
          ),
          FilterSection<GeMaterialType, GsMaterial>(
            GeMaterialType.values.toSet(),
            (item) => item.group,
            (c) => c.fromLabel(Labels.category),
            (c, i) => c.fromLabel(i.label),
          ),
        ]),
      _ => null,
    } as ScreenFilter<T>?;
  }
}

class _GsFilterDialog extends StatefulWidget {
  static Future<void> show(BuildContext context, ScreenFilter filter) async {
    return showDialog(
      context: context,
      builder: (_) => _GsFilterDialog(filter),
    );
  }

  final ScreenFilter filter;

  const _GsFilterDialog(this.filter);

  @override
  State<_GsFilterDialog> createState() => _GsFilterDialogState();
}

class _GsFilterDialogState extends State<_GsFilterDialog> {
  final notifier = ValueNotifier(false);

  @override
  void dispose() {
    notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: size.height / 4,
        horizontal: size.width / 4,
      ),
      padding: kListPadding,
      decoration: BoxDecoration(
        color: context.themeColors.mainColor0,
        borderRadius: kGridRadius,
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            InventoryBox(
              child: Row(
                children: [
                  const SizedBox(width: kGridSeparator),
                  Expanded(
                    child: Text(
                      context.fromLabel(Labels.filter),
                      style: context.themeStyles.title18n,
                      strutStyle: context.themeStyles.title18n.toStrut(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.restart_alt_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      widget.filter.reset();
                      notifier.value = !notifier.value;
                      Navigator.of(context).maybePop();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: kGridSeparator),
            Expanded(
              child: InventoryBox(
                padding: const EdgeInsets.all(kGridSeparator * 2),
                child: ValueListenableBuilder<bool>(
                  valueListenable: notifier,
                  builder: (context, value, child) {
                    final half = widget.filter.sections.length ~/ 2;
                    return SingleChildScrollView(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widget.filter.sections
                                  .take(half)
                                  .map(_filter)
                                  .separate(const SizedBox(height: 12))
                                  .toList(),
                            ),
                          ),
                          const SizedBox(width: kSeparator8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widget.filter.sections
                                  .skip(half)
                                  .map(_filter)
                                  .separate(const SizedBox(height: 12))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filter(FilterSection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.title(context),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: kGridSeparator * 2),
        Wrap(
          spacing: kGridSeparator,
          runSpacing: kGridSeparator,
          children: section.values.map((v) {
            return MainButton(
              selected: section.enabled.contains(v),
              label: section.label(context, v),
              onPress: () {
                section.toggle(v);
                notifier.value = !notifier.value;
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
