import 'package:cached_network_image/cached_network_image.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/cards/gs_rarity_item_card.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/common/widgets/text_style_parser.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/character_ascension_screen/character_ascension_material.dart';
import 'package:tracker/theme/theme.dart';

class CharacterDetailsScreen extends StatelessWidget {
  final _talents = GlobalKey();
  final _ascension = GlobalKey();
  final _materials = GlobalKey();
  final _attributes = GlobalKey();
  final _constellation = GlobalKey();
  static const id = 'character_details_screen';

  CharacterDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final item = args! as InfoCharacter;
    final info = GsDatabase.instance.infoCharactersInfo.getItemOrNull(item.id);

    return ValueStreamBuilder<bool>(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        if (!snapshot.data!) return const SizedBox();
        return Scaffold(
          appBar: GsAppBar(
            label: item.name,
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(getElementBgImage(item.element)),
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
                      _getInfo(context, item, info),
                      _getAttributes(context, item),
                      if (info != null) ...[
                        const SizedBox(height: kSeparator8),
                        _getAscension(context, info),
                        const SizedBox(height: kSeparator8),
                        _getTalents(context, info),
                        const SizedBox(height: kSeparator8),
                        _getConstellations(context, info),
                        const SizedBox(height: kSeparator8),
                        _getAllMaterials(context, info),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _getInfo(
    BuildContext context,
    InfoCharacter info,
    InfoCharacterInfo? infos,
  ) {
    final db = GsDatabase.instance.saveCharacters;
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
                      style: Theme.of(context).textTheme.bigTitle2,
                    ),
                    const SizedBox(width: kSeparator8),
                    GsItemCardLabel(
                      asset: info.element.assetPath,
                      label: constellation != null ? 'C$constellation' : null,
                      onTap: () => GsDatabase.instance.saveCharacters
                          .increaseOwnedCharacter(info.id),
                    ),
                    const SizedBox(width: kSeparator4),
                    if (hasChar)
                      GsItemCardLabel(
                        asset: imageXp,
                        label: friendship.toString(),
                        onTap: () => GsDatabase.instance.saveCharacters
                            .increaseFriendshipCharacter(info.id),
                      )
                  ],
                ),
                if (hasChar)
                  InkWell(
                    onTap: () => db.increaseAscension(info.id),
                    child: Text(
                      '${'✦' * ascension}${'✧' * (6 - ascension)}',
                      style: context.textTheme.bigTitle3,
                    ),
                  ),
                const SizedBox(height: kSeparator4),
                Text(
                  info.description,
                  style: context.textTheme.description2,
                ),
                const SizedBox(height: kSeparator8),
                _getTags(context, info, infos),
              ],
            ),
          ),
          SizedBox(
            width: 310,
            child: CachedImageWidget(
              GsUtils.characters.getFullImage(info.id),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
              showPlaceholder: false,
            ),
          )
        ],
      ),
    );
  }

  Widget _getAttributes(BuildContext context, InfoCharacter info) {
    final style = context.textTheme.titleSmall!;
    final stLabel = style.copyWith(color: context.themeColors.dimWhite);
    final stStyle = style.copyWith(color: Colors.white);
    final db = GsDatabase.instance.infoRecipes;
    final dish = db.getItemOrNull(info.specialDish);
    return GsDataBox.info(
      key: _attributes,
      title: context.fromLabel(Labels.attributes),
      children: [
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: IntrinsicColumnWidth(),
            2: IntrinsicColumnWidth(),
          },
          border: TableBorder(
            horizontalInside: BorderSide(
              color: context.themeColors.dimWhite,
              width: 0.4,
            ),
          ),
          children: [
            TableRow(
              children: [
                Text(context.fromLabel(Labels.name), style: stLabel),
                Text(info.name, style: stStyle),
                Text(context.fromLabel(Labels.birthday), style: stLabel),
                Text(info.birthday.toPrettyDate(), style: stStyle),
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
                Text(context.fromLabel(Labels.vision), style: stLabel),
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
                          GsRarityItemCard(
                            size: 48,
                            image: dish.image,
                            rarity: dish.rarity,
                          ),
                          const SizedBox(width: kSeparator8),
                          Text(dish.name, style: stStyle),
                        ],
                      )
                    : Text(context.fromLabel(Labels.wsNone), style: stStyle),
                Text(context.fromLabel(Labels.releaseDate), style: stLabel),
                Text(info.releaseDate.toPrettyDate(), style: stStyle),
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
                      GsRarityItemCard.withLabels(
                        image: info.image,
                        rarity: info.rarity,
                        labelFooter: info.name,
                        onTap: () => GsDatabase.instance.saveCharacters
                            .setCharOutfit(info.id, ''),
                      ),
                      ...GsDatabase.instance.infoCharactersOutfit
                          .getItems()
                          .where((element) => element.character == info.id)
                          .map((e) {
                        return GsRarityItemCard.withLabels(
                          image: e.image,
                          rarity: e.rarity,
                          labelFooter: e.name,
                          onTap: () => GsDatabase.instance.saveCharacters
                              .setCharOutfit(info.id, e.id),
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
              )
          ],
        ),
      ],
    );
  }

  Widget _getAscension(
    BuildContext context,
    InfoCharacterInfo infos,
  ) {
    final style = context.textTheme.titleSmall!.copyWith(color: Colors.white);
    return GsDataBox.info(
      key: _ascension,
      title: context.fromLabel(Labels.ascension),
      children: [
        Table(
          columnWidths: const {
            0: IntrinsicColumnWidth(),
            5: IntrinsicColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: TableBorder(
            horizontalInside: BorderSide(
              color: context.themeColors.dimWhite,
              width: 0.4,
            ),
          ),
          children: [
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: kSeparator4),
                  child: Center(
                    child: Text(context.fromLabel(Labels.level), style: style),
                  ),
                ),
                Center(
                  child: Text(
                    context.fromLabel(GsAttributeStat.hp.label),
                    style: style,
                  ),
                ),
                Center(
                  child: Text(
                    context.fromLabel(GsAttributeStat.atk.label),
                    style: style,
                  ),
                ),
                Center(
                  child: Text(
                    context.fromLabel(GsAttributeStat.def.label),
                    style: style,
                  ),
                ),
                Center(
                  child: Text(
                    context.fromLabel(infos.ascension.ascStatType.label),
                    style: style,
                  ),
                ),
                Center(
                  child: Text(
                    context.fromLabel(Labels.materials),
                    style: style,
                  ),
                ),
              ],
            ),
            ...GsDatabase.instance.infoCharactersInfo
                .characterAscension()
                .mapIndexed((idx, cfg) {
              final hp = infos.ascension.ascHpValues.elementAtOrNull(idx);
              final atk = infos.ascension.ascAtkValues.elementAtOrNull(idx);
              final def = infos.ascension.ascDefValues.elementAtOrNull(idx);
              final stat = infos.ascension.ascStatValues.elementAtOrNull(idx);
              if (hp == null && atk == null && def == null && stat == null) {
                return null;
              }
              return TableRow(
                children: [
                  Container(
                    height: 64 + 24,
                    margin: const EdgeInsets.symmetric(vertical: kSeparator4),
                    child: Center(
                      child: Text(
                        cfg.level.toString(),
                        style: context.textTheme.titleSmall!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  Center(child: Text(hp ?? '-', style: style)),
                  Center(child: Text(atk ?? '-', style: style)),
                  Center(child: Text(def ?? '-', style: style)),
                  Center(child: Text(stat ?? '-', style: style)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: GsDatabase.instance.infoCharactersInfo
                        .getAscensionMaterials(infos.id, idx)
                        .entries
                        .map<Widget>((e) {
                          final db = GsDatabase.instance.infoMaterials;
                          final item = db.getItemOrNull(e.key);
                          return GsRarityItemCard.withLabels(
                            image: item?.image ?? '',
                            rarity: item?.rarity ?? 1,
                            labelFooter: e.value.format(),
                          );
                        })
                        .separate(const SizedBox(width: kSeparator4))
                        .toList(),
                  )
                ],
              );
            }).whereNotNull(),
          ],
        ),
      ],
    );
  }

  Widget _getTalents(BuildContext context, InfoCharacterInfo info) {
    return GsDataBox.info(
      key: _talents,
      title: context.fromLabel(Labels.talents),
      children: info.talents
          .map<Widget>((e) {
            return Padding(
              padding: const EdgeInsets.all(kSeparator4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 46,
                        height: 46,
                        child: CachedImageWidget(e.icon),
                      ),
                      const SizedBox(width: kSeparator8),
                      Text(
                        e.name,
                        style: context.textTheme.titleSmall!
                            .copyWith(color: Colors.white),
                      ),
                      const SizedBox(width: kSeparator8),
                      Text(
                        '(${e.type})',
                        style: context.textTheme.description2
                            .copyWith(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  const SizedBox(height: kSeparator8),
                  TextParserWidget(
                    e.desc,
                    style: context.textTheme.titleSmall!
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
            );
          })
          .separate(
            Divider(
              color: context.themeColors.dimWhite,
              thickness: 0.4,
            ),
          )
          .toList(),
    );
  }

  Widget _getConstellations(BuildContext context, InfoCharacterInfo info) {
    return GsDataBox.info(
      key: _constellation,
      title: context.fromLabel(Labels.constellation),
      children: info.constellations
          .map<Widget>((e) {
            return Padding(
              padding: const EdgeInsets.all(kSeparator4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 46,
                        height: 46,
                        child: CachedImageWidget(e.icon),
                      ),
                      const SizedBox(width: kSeparator8),
                      Text(
                        e.name,
                        style: context.textTheme.titleSmall!
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: kSeparator8),
                  TextParserWidget(
                    e.desc,
                    style: context.textTheme.titleSmall!
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
            );
          })
          .separate(
            Divider(
              color: context.themeColors.dimWhite,
              thickness: 0.4,
            ),
          )
          .toList(),
    );
  }

  Widget _getAllMaterials(BuildContext context, InfoCharacterInfo details) {
    final im = GsDatabase.instance.infoMaterials;
    final ic = GsDatabase.instance.infoCharactersInfo;
    final tltMats = ic.getTalentMaterials(details.id);
    final ascMats = ic.getAscensionMaterials(details.id);
    final allMats = {...tltMats, ...ascMats}
        .entries
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
      Widget Function(MapEntry<InfoMaterial?, int> e) mapper,
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
                  .map((e) => MapEntry(im.getItemOrNull(e.key), e.value))
                  .where((e) => e.key != null)
                  .sortedBy((e) => existance(e.key?.id))
                  .thenBy((e) => e.key!.group.index)
                  .thenBy((e) => e.key!.subgroup)
                  .thenBy((e) => e.key!.rarity)
                  .thenBy((e) => e.key!.name)
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
      title: context.fromLabel(Labels.materials),
      child: Table(
        columnWidths: const {
          0: IntrinsicColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder(
          horizontalInside: BorderSide(
            color: context.themeColors.dimWhite,
            width: 0.4,
          ),
        ),
        children: [
          getTableRow(
            context.fromLabel(Labels.ascension),
            ascMats,
            (e) => GsRarityItemCard.withLabels(
              labelFooter: e.value.format(),
              rarity: e.key!.rarity,
              image: e.key!.image,
            ),
          ),
          getTableRow(
            context.fromLabel(Labels.talents),
            tltMats,
            (e) => GsRarityItemCard.withLabels(
              labelFooter: e.value.format(),
              rarity: e.key!.rarity,
              image: e.key!.image,
            ),
          ),
          getTableRow(
            context.fromLabel(Labels.total),
            allMats,
            (e) => CharacterAscensionMaterial(e.key!.id, e.value),
          ),
        ],
      ),
    );
  }

  Widget _getTags(
    BuildContext context,
    InfoCharacter info,
    InfoCharacterInfo? infos,
  ) {
    return Row(
      children: [
        context.fromLabel(Labels.rarityStar, info.rarity),
        context.fromLabel(info.weapon.label),
        if (info.region != GsRegion.none) context.fromLabel(info.region.label),
        context.fromLabel(info.element.label),
        if (infos != null) context.fromLabel(infos.ascension.ascStatType.label),
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
            style: context.textTheme.description2,
          ),
        );
      },
    );
  }
}
