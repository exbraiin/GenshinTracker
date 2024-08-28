import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/cards/gs_rarity_item_card.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/common/widgets/text_style_parser.dart';
import 'package:tracker/common/widgets/value_notifier_builder.dart';
import 'package:tracker/domain/enums/enum_ext.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/widgets/ascension_table.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';
import 'package:tracker/screens/widgets/item_info_widget.dart';

class CharacterDetailsScreen extends StatelessWidget {
  final _talents = GlobalKey();
  final _ascension = GlobalKey();
  final _materials = GlobalKey();
  final _attributes = GlobalKey();
  final _constellation = GlobalKey();
  static const id = 'character_details_screen';

  CharacterDetailsScreen({super.key});

  late final Color bgColor;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final item = args! as GsCharacter;
    final color = item.element.color;
    bgColor = Color.lerp(Colors.black, color, 0.2)!.withOpacity(0.5);

    return ValueStreamBuilder(
      stream: Database.instance.loaded,
      builder: (context, snapshot) {
        if (snapshot.data != true) return const SizedBox();
        return InventoryPage(
          appBar: InventoryAppBar(
            iconAsset: menuIconCharacters,
            label: item.name,
          ),
          child: InventoryBox(
            padding: EdgeInsets.zero,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(item.element.assetBgPath),
                ),
              ),
              child: Stack(
                children: [
                  if (item.constellationImage.isNotEmpty)
                    Positioned.fill(
                      child: CachedImageWidget(
                        item.constellationImage,
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.center,
                        scaleToSize: false,
                        showPlaceholder: false,
                      ),
                    ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(kSeparator4),
                    child: Column(
                      children: [
                        _getInfo(context, item),
                        _getAttributes(context, item),
                        const SizedBox(height: kSeparator8),
                        _getAscension(context, item),
                        const SizedBox(height: kSeparator8),
                        if (item.talents.isNotEmpty) ...[
                          _getTalents(context, item),
                          const SizedBox(height: kSeparator8),
                        ],
                        if (item.constellations.isNotEmpty) ...[
                          _getConstellations(context, item),
                          const SizedBox(height: kSeparator8),
                        ],
                        _getAllMaterials(context, item),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _getInfo(BuildContext context, GsCharacter info) {
    final ascension = GsUtils.characters.getCharAscension(info.id);
    final friendship = GsUtils.characters.getCharFriendship(info.id);
    final constellation = GsUtils.characters.getCharConstellations(info.id);
    final hasChar = GsUtils.characters.hasCaracter(info.id);

    return SizedBox(
      height: 260,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GsRarityItemCard(
                size: 120,
                image: GsUtils.characters.getImage(info.id),
                rarity: info.rarity,
              ),
              const SizedBox(height: kSeparator8),
              ...{
                Labels.attributes: _attributes,
                Labels.ascension: _ascension,
                Labels.talents: _talents,
                Labels.constellations: _constellation,
                Labels.materials: _materials,
              }.entries.map((e) {
                return _getTextButton(
                  context,
                  context.fromLabel(e.key),
                  () => Scrollable.ensureVisible(
                    e.value.currentContext!,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                  ),
                );
              }).separate(const SizedBox(height: kSeparator4)),
            ],
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      info.name,
                      style: context.themeStyles.title24n,
                    ),
                    const SizedBox(width: kSeparator8),
                    GsItemCardLabel(
                      asset: info.element.assetPath,
                      label: constellation != null ? 'C$constellation' : null,
                    ),
                    const SizedBox(width: kSeparator4),
                    if (hasChar)
                      GsItemCardLabel(
                        asset: imageXp,
                        label: friendship.toString(),
                        onTap: () => GsUtils.characters
                            .increaseFriendshipCharacter(info.id),
                      ),
                  ],
                ),
                if (hasChar)
                  InkWell(
                    onTap: () => GsUtils.characters.increaseAscension(info.id),
                    child: Text(
                      '${'✦' * ascension}${'✧' * (6 - ascension)}',
                      style: context.themeStyles.title20n,
                    ),
                  ),
                const SizedBox(height: kSeparator4),
                Text(
                  info.description,
                  style: context.themeStyles.label12n,
                ),
                const SizedBox(height: kSeparator8),
                _getTags(context, info),
              ],
            ),
          ),
          SizedBox(
            width: 310,
            height: 310,
            child: CachedImageWidget(
              GsUtils.characters.getFullImage(info.id),
              fit: BoxFit.fitWidth,
              alignment: Alignment.center,
              showPlaceholder: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getAttributes(BuildContext context, GsCharacter info) {
    final style = context.textTheme.titleSmall!;
    final stLabel = style.copyWith(color: context.themeColors.dimWhite);
    final stStyle = style.copyWith(color: Colors.white);
    final db = Database.instance.infoOf<GsRecipe>();
    final dish = db.getItem(info.specialDish);
    return GsDataBox.info(
      key: _attributes,
      bgColor: bgColor,
      title: Text(context.fromLabel(Labels.attributes)),
      children: [
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: IntrinsicColumnWidth(),
            2: IntrinsicColumnWidth(),
          },
          border: TableBorder(
            horizontalInside: BorderSide(
              color: context.themeColors.divider,
              width: 0.4,
            ),
          ),
          children: [
            TableRow(
              children: [
                Text(context.fromLabel(Labels.name), style: stLabel),
                Text(info.name, style: stStyle),
                Text(context.fromLabel(Labels.birthday), style: stLabel),
                Text(
                  info.birthday.toPrettyDate(context),
                  style: stStyle,
                ),
              ].map((e) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
                  child: e,
                );
              }).toList(),
            ),
            TableRow(
              children: [
                Text(context.fromLabel(Labels.constellation), style: stLabel),
                Text(info.constellation, style: stStyle),
                Text(context.fromLabel(Labels.title), style: stLabel),
                Text(info.title, style: stStyle),
              ].map((e) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
                  child: e,
                );
              }).toList(),
            ),
            TableRow(
              children: [
                Text(context.fromLabel(Labels.element), style: stLabel),
                Text(context.fromLabel(info.element.label), style: stStyle),
                Text(context.fromLabel(Labels.affiliation), style: stLabel),
                Text(info.affiliation, style: stStyle),
              ].map((e) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
                  child: e,
                );
              }).toList(),
            ),
            TableRow(
              children: [
                Text(context.fromLabel(Labels.weapon), style: stLabel),
                Text(context.fromLabel(info.weapon.label), style: stStyle),
                Text(context.fromLabel(Labels.version), style: stLabel),
                Text(info.version, style: stStyle),
              ].map((e) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
                  child: e,
                );
              }).toList(),
            ),
            TableRow(
              children: [
                Text(context.fromLabel(Labels.specialDish), style: stLabel),
                dish != null
                    ? Row(
                        children: [
                          ItemGridWidget.recipe(dish),
                          const SizedBox(width: kSeparator8),
                          Text(dish.name, style: stStyle),
                        ],
                      )
                    : Text(context.fromLabel(Labels.wsNone), style: stStyle),
                Text(context.fromLabel(Labels.releaseDate), style: stLabel),
                Text(
                  info.releaseDate.toPrettyDate(context),
                  style: stStyle,
                ),
              ].map((e) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
                  child: e,
                );
              }).toList(),
            ),
            if (GsUtils.characters.hasOutfits(info.id))
              TableRow(
                children: [
                  Text(context.fromLabel(Labels.outfits), style: stLabel),
                  Wrap(
                    spacing: kSeparator4,
                    runSpacing: kSeparator4,
                    children: [
                      ItemGridWidget(
                        urlImage: info.image,
                        rarity: info.rarity,
                        tooltip: info.name,
                        onTap: (ctx) =>
                            GsUtils.characters.setCharOutfit(info.id, ''),
                      ),
                      ...Database.instance
                          .infoOf<GsCharacterSkin>()
                          .items
                          .where((element) => element.character == info.id)
                          .map((e) {
                        return ItemGridWidget(
                          urlImage: e.image,
                          rarity: e.rarity,
                          tooltip: e.name,
                          onTap: (ctx) =>
                              GsUtils.characters.setCharOutfit(info.id, e.id),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(),
                  const SizedBox(),
                ].map((e) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
                    child: e,
                  );
                }).toList(),
              ),
          ],
        ),
      ],
    );
  }

  Widget _getAscension(BuildContext context, GsCharacter info) {
    return GsDataBox.info(
      key: _ascension,
      bgColor: bgColor,
      title: Text(context.fromLabel(Labels.ascension)),
      child: AscensionTable.character(info),
    );
  }

  Widget _getTalents(BuildContext context, GsCharacter info) {
    return ValueNotifierBuilder<int>(
      value: 0,
      builder: (context, notifier, child) {
        final selected = info.talents[notifier.value];
        return GsDataBox.info(
          key: _talents,
          bgColor: bgColor,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.fromLabel(Labels.talents)),
              const SizedBox(height: kSeparator6),
              Row(
                children: info.talents
                    .mapIndexed<Widget>((i, e) {
                      return _asButton(
                        selected: notifier.value == i,
                        onTap: () => notifier.value = i,
                        child: CachedImageWidget(e.icon),
                      );
                    })
                    .separate(const SizedBox(width: kSeparator8))
                    .toList(),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    selected.name,
                    style: context.themeStyles.title20n
                        .copyWith(color: context.themeColors.primary),
                  ),
                  const SizedBox(width: kSeparator8),
                  Text(
                    '(${context.fromLabel(selected.type.label)})',
                    style: context.themeStyles.label12i,
                  ),
                ],
              ),
              const SizedBox(height: kSeparator8),
              TextParserWidget(
                selected.desc,
                style:
                    context.textTheme.titleSmall!.copyWith(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getConstellations(BuildContext context, GsCharacter info) {
    return ValueNotifierBuilder<int>(
      value: 0,
      builder: (context, notifier, child) {
        final selected = info.constellations[notifier.value];
        return GsDataBox.info(
          key: _constellation,
          bgColor: bgColor,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.fromLabel(Labels.constellation)),
              const SizedBox(height: kSeparator6),
              Row(
                children: info.constellations
                    .mapIndexed<Widget>((i, e) {
                      return _asButton(
                        selected: notifier.value == i,
                        onTap: () => notifier.value = i,
                        child: CachedImageWidget(e.icon),
                      );
                    })
                    .separate(const SizedBox(width: kSeparator8))
                    .toList(),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selected.name,
                style: context.themeStyles.title20n
                    .copyWith(color: context.themeColors.primary),
              ),
              const SizedBox(height: kSeparator8),
              TextParserWidget(
                selected.desc,
                style:
                    context.textTheme.titleSmall!.copyWith(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getAllMaterials(BuildContext context, GsCharacter info) {
    final im = Database.instance.infoOf<GsMaterial>();
    final ic = GsUtils.characterMaterials;
    final tltMats = ic.getTalentMaterials(info.id);
    final ascMats = ic.getAscensionMaterials(info.id);
    final allMats = [...tltMats.entries, ...ascMats.entries]
        .groupBy((e) => e.key)
        .map((k, v) => MapEntry(k, v.sumBy((e) => e.value).toInt()));

    int existance(String? id) {
      if (id == null) return 0;
      final a = tltMats.containsKey(id) ? 1 : 0;
      final b = ascMats.containsKey(id) ? 1 : 0;
      final c = allMats.containsKey(id) ? 1 : 0;
      return a + b + c;
    }

    TableRow getTableRow(
      String label,
      Map<String, int> mats,
      Widget Function(MapEntry<GsMaterial, int> e) mapper,
    ) {
      return TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.all(kSeparator8),
            child: Text(
              label,
              style:
                  context.textTheme.titleSmall!.copyWith(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kSeparator4),
            child: Wrap(
              spacing: kSeparator4,
              runSpacing: kSeparator4,
              textDirection: TextDirection.rtl,
              children: mats.entries
                  .map((e) => MapEntry(im.getItem(e.key), e.value))
                  .where((e) => e.key != null)
                  .map((e) => MapEntry(e.key!, e.value))
                  .sortedBy((e) => existance(e.key.id))
                  .thenBy((e) => e.key.group.index)
                  .thenBy((e) => e.key.subgroup)
                  .thenBy((e) => e.key.rarity)
                  .thenBy((e) => e.key.name)
                  .reversed
                  .map(mapper)
                  .toList(),
            ),
          ),
        ],
      );
    }

    return GsDataBox.info(
      key: _materials,
      bgColor: bgColor,
      title: Text(context.fromLabel(Labels.materials)),
      child: Table(
        columnWidths: const {
          0: IntrinsicColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder(
          horizontalInside: BorderSide(
            color: context.themeColors.divider,
            width: 0.4,
          ),
        ),
        children: [
          getTableRow(
            context.fromLabel(Labels.ascension),
            ascMats,
            (e) => ItemGridWidget.material(e.key, label: e.value.compact()),
          ),
          getTableRow(
            context.fromLabel(Labels.talents),
            tltMats,
            (e) => ItemGridWidget.material(e.key, label: e.value.compact()),
          ),
          getTableRow(
            context.fromLabel(Labels.total),
            allMats,
            (e) => ItemGridWidget.material(e.key, label: e.value.compact()),
          ),
        ],
      ),
    );
  }

  Widget _getTags(BuildContext context, GsCharacter info) {
    return Row(
      children: [
        context.fromLabel(Labels.rarityStar, info.rarity),
        context.fromLabel(info.weapon.label),
        if (info.region != GeRegionType.none)
          context.fromLabel(info.region.label),
        context.fromLabel(info.element.label),
        if (info.arkhe != GeArkheType.none) context.fromLabel(info.arkhe.label),
        context.fromLabel(info.ascStatType.label),
      ]
          .map<Widget>((e) => GsItemCardLabel(label: e))
          .separate(const SizedBox(width: kSeparator4))
          .toList(),
    );
  }

  Widget _getTextButton(
    BuildContext context,
    String text, [
    VoidCallback? onTap,
  ]) {
    var hover = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return InkWell(
          onTap: onTap,
          onHover: (h) => setState(() => hover = h),
          child: Text(
            '${hover ? '✦' : '✧'} $text',
            style: context.themeStyles.label12n,
          ),
        );
      },
    );
  }

  Widget _asButton({
    required Widget child,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return MouseHoverBuilder(
      builder: (context, hover, child) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: hover || selected ? 1 : kDisableOpacity,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: selected
                    ? context.themeColors.almostWhite
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: child,
          ),
        );
      },
      child: SizedBox(
        width: 40,
        height: 40,
        child: InkWell(onTap: onTap, child: child),
      ),
    );
  }
}
