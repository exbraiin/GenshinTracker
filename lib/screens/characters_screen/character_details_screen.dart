import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/text_style_parser.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/cards/gs_rarity_item_card.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/domain_ext/enum/gs_attribute_stat_ext.dart';
import 'package:tracker/domain_ext/enum/gs_element_ext.dart';
import 'package:tracker/domain_ext/enum/gs_region_ext.dart';
import 'package:tracker/domain_ext/enum/gs_weapon_ext.dart';
import 'package:tracker/screens/character_ascension_screen/character_ascension_material.dart';
import 'package:tracker/screens/recipes_screen/recipe_details_screen.dart';

class CharacterDetailsScreen extends StatelessWidget {
  final _talents = GlobalKey();
  final _ascension = GlobalKey();
  final _materials = GlobalKey();
  final _attributes = GlobalKey();
  final _constellation = GlobalKey();
  static const id = 'character_details_screen';

  CharacterDetailsScreen();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final details = args as InfoCharacter;

    return ValueStreamBuilder<bool>(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        if (!snapshot.data!) return SizedBox();
        return Scaffold(
          appBar: GsAppBar(
            label: details.name,
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  getElementBgImage(details.element),
                  fit: BoxFit.cover,
                ),
              ),
              SingleChildScrollView(
                padding: EdgeInsets.all(kSeparator4),
                child: Column(
                  children: [
                    _getInfo(context, details),
                    _getAttributes(context, details),
                    SizedBox(height: kSeparator8),
                    _getAscension(context, details),
                    SizedBox(height: kSeparator8),
                    _getTalents(context, details),
                    SizedBox(height: kSeparator8),
                    _getConstellations(context, details),
                    SizedBox(height: kSeparator8),
                    _getAllMaterials(context, details),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getInfo(BuildContext context, InfoCharacter info) {
    final db = GsDatabase.instance.saveCharacters;
    final ascension = db.getCharAscension(info.id);
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
                image: info.image,
                rarity: info.rarity,
              ),
              SizedBox(height: kSeparator8),
              _getTextButton(
                context,
                context.fromLabel(Labels.attributes),
                () => Scrollable.ensureVisible(
                  _attributes.currentContext!,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                ),
              ),
              SizedBox(height: kSeparator4),
              _getTextButton(
                context,
                context.fromLabel(Labels.ascension),
                () => Scrollable.ensureVisible(
                  _ascension.currentContext!,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                ),
              ),
              SizedBox(height: kSeparator4),
              _getTextButton(
                context,
                context.fromLabel(Labels.talents),
                () => Scrollable.ensureVisible(
                  _talents.currentContext!,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                ),
              ),
              SizedBox(height: kSeparator4),
              _getTextButton(
                context,
                context.fromLabel(Labels.constellations),
                () => Scrollable.ensureVisible(
                  _constellation.currentContext!,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                ),
              ),
              SizedBox(height: kSeparator4),
              _getTextButton(
                context,
                context.fromLabel(Labels.materials),
                () => Scrollable.ensureVisible(
                  _materials.currentContext!,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                ),
              ),
            ],
          ),
          SizedBox(width: 18),
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
                    SizedBox(width: 8),
                    Image.asset(
                      info.element.assetPath,
                      width: 24,
                      height: 24,
                    ),
                  ],
                ),
                InkWell(
                  onTap: GsDatabase.instance.saveWishes
                              .getOwnedCharacter(info.id) !=
                          0
                      ? () => db.increaseAscension(info.id)
                      : null,
                  child: Text(
                    '${'✦' * ascension}${'✧' * (6 - ascension)}',
                    style: context.textTheme.bigTitle3,
                  ),
                ),
                SizedBox(height: kSeparator4),
                Text(
                  info.description,
                  style: context.textTheme.description2,
                ),
                SizedBox(height: kSeparator8),
                _getTags(context, info),
              ],
            ),
          ),
          SizedBox(
            width: 310,
            child: CachedImageWidget(
              info.fullImage,
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          )
        ],
      ),
    );
  }

  Widget _getAttributes(BuildContext context, InfoCharacter info) {
    final style = context.textTheme.subtitle2!;
    final stLabel = style.copyWith(color: GsColors.dimWhite);
    final stStyle = style.copyWith(color: Colors.white);
    final db = GsDatabase.instance.infoRecipes;
    final dish = db.getItemOrNull(info.specialDish);
    return GsDataBox.info(
      key: _attributes,
      title: context.fromLabel(Labels.attributes),
      children: [
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: {
            0: IntrinsicColumnWidth(),
            2: IntrinsicColumnWidth(),
          },
          border: TableBorder(
            horizontalInside: BorderSide(
              color: GsColors.dimWhite,
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
              ]
                  .map((e) => Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 16, 8),
                        child: e,
                      ))
                  .toList(),
            ),
            TableRow(
              children: [
                Text(context.fromLabel(Labels.constellation), style: stLabel),
                Text(info.constellation, style: stStyle),
                Text(context.fromLabel(Labels.title), style: stLabel),
                Text(info.title, style: stStyle),
              ]
                  .map((e) => Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 16, 8),
                        child: e,
                      ))
                  .toList(),
            ),
            TableRow(
              children: [
                Text(context.fromLabel(Labels.vision), style: stLabel),
                Text(context.fromLabel(info.element.label), style: stStyle),
                Text(context.fromLabel(Labels.affiliation), style: stLabel),
                Text(info.affiliation, style: stStyle),
              ]
                  .map((e) => Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 16, 8),
                        child: e,
                      ))
                  .toList(),
            ),
            TableRow(
              children: [
                Text(context.fromLabel(Labels.weapon), style: stLabel),
                Text(context.fromLabel(info.weapon.label), style: stStyle),
                Text(context.fromLabel(Labels.version), style: stLabel),
                Text(info.version, style: stStyle),
              ]
                  .map((e) => Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 16, 8),
                        child: e,
                      ))
                  .toList(),
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
                            onTap: () => Navigator.of(context).pushNamed(
                              RecipeDetailsScreen.id,
                              arguments: dish,
                            ),
                          ),
                          SizedBox(width: kSeparator8),
                          Text(dish.name, style: stStyle),
                        ],
                      )
                    : Text(context.fromLabel(Labels.wsNone), style: stStyle),
                Text(context.fromLabel(Labels.releaseDate), style: stLabel),
                Text(info.releaseDate.toPrettyDate(), style: stStyle),
              ]
                  .map((e) => Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 16, 8),
                        child: e,
                      ))
                  .toList(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _getAscension(BuildContext context, InfoCharacter info) {
    final style = context.textTheme.subtitle2!.copyWith(color: Colors.white);
    final values = info.ascension
        .expand((e) => [
              ...e.valuesAfter.keys,
              ...e.valuesBefore.keys,
            ])
        .toSet()
        .take(4);
    return GsDataBox.info(
      key: _ascension,
      title: context.fromLabel(Labels.ascension),
      children: [
        Table(
          columnWidths: {
            0: IntrinsicColumnWidth(),
            5: IntrinsicColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: TableBorder(
            horizontalInside: BorderSide(
              color: GsColors.dimWhite,
              width: 0.4,
            ),
          ),
          children: [
            TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: kSeparator4),
                  child: Center(
                    child: Text(context.fromLabel(Labels.level), style: style),
                  ),
                ),
                ...values.map(
                  (e) => Center(
                    child: Text(
                      context.fromLabel(e.label),
                      style: style,
                    ),
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
            ...info.ascension.map(
              (e) => TableRow(
                children: [
                  Container(
                    height: 64 + 24,
                    margin: EdgeInsets.symmetric(vertical: kSeparator4),
                    child: Center(
                      child: Text(
                        e.level.toString(),
                        style: context.textTheme.subtitle2!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  ...values.map((v) => Center(
                        child: Text(
                          v.toAscensionStat(e),
                          style: context.textTheme.subtitle2!
                              .copyWith(color: Colors.white),
                        ),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (e.materials.isNotEmpty)
                        ...e.materials.entries.map<Widget>((e) {
                          final db = GsDatabase.instance.infoMaterials;
                          final item = db.getItemOrNull(e.key);
                          return GsRarityItemCard.withLabels(
                            image: item?.image ?? '',
                            rarity: item?.rarity ?? 1,
                            labelFooter: e.value.format(),
                          );
                        }).separate(SizedBox(width: kSeparator4)),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _getTalents(BuildContext context, InfoCharacter info) {
    return GsDataBox.info(
      key: _talents,
      title: context.fromLabel(Labels.talents),
      children: info.talents
          .map<Widget>((e) {
            return Padding(
              padding: EdgeInsets.all(kSeparator4),
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
                      SizedBox(width: kSeparator8),
                      Text(
                        e.name,
                        style: context.textTheme.subtitle2!
                            .copyWith(color: Colors.white),
                      ),
                      SizedBox(width: kSeparator8),
                      Text(
                        '(${e.type})',
                        style: context.textTheme.description2
                            .copyWith(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  SizedBox(height: kSeparator8),
                  TextParserWidget(
                    e.desc,
                    style: context.textTheme.subtitle2!
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
            );
          })
          .separate(Divider(
            color: GsColors.dimWhite,
            thickness: 0.4,
          ))
          .toList(),
    );
  }

  Widget _getConstellations(BuildContext context, InfoCharacter info) {
    return GsDataBox.info(
      key: _constellation,
      title: context.fromLabel(Labels.constellation),
      children: info.constellations
          .map<Widget>((e) {
            return Padding(
              padding: EdgeInsets.all(kSeparator4),
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
                      SizedBox(width: kSeparator8),
                      Text(
                        e.name,
                        style: context.textTheme.subtitle2!
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: kSeparator8),
                  TextParserWidget(
                    e.desc,
                    style: context.textTheme.subtitle2!
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
            );
          })
          .separate(Divider(
            color: GsColors.dimWhite,
            thickness: 0.4,
          ))
          .toList(),
    );
  }

  Widget _getAllMaterials(BuildContext context, InfoCharacter info) {
    final tltMats = info.allTalentMaterials;
    final ascMats = info.allAscensionMaterials;
    final totalMats = info.allMaterials;

    final db = GsDatabase.instance.infoMaterials;

    int existance(String? id) {
      if (id == null) return 0;
      final a = tltMats.containsKey(id) ? 1 : 0;
      final b = ascMats.containsKey(id) ? 1 : 0;
      final c = totalMats.containsKey(id) ? 1 : 0;
      return a + b + c;
    }

    TableRow _getTableRow(
      String label,
      Map<String, int> mats,
      Widget Function(MapEntry<InfoMaterial?, int> e) mapper,
    ) {
      return TableRow(
        children: [
          Padding(
            padding: EdgeInsets.all(kSeparator8),
            child: Text(
              label,
              style: context.textTheme.subtitle2!.copyWith(color: Colors.white),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: kSeparator4),
            child: Wrap(
              spacing: kSeparator4,
              runSpacing: kSeparator4,
              textDirection: TextDirection.rtl,
              children: mats.entries
                  .map((e) => MapEntry(db.getItemOrNull(e.key), e.value))
                  .where((e) => e.key != null)
                  .sortedBy((e) => existance(e.key?.id))
                  .thenBy((e) => e.key!.group)
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
        columnWidths: {
          0: IntrinsicColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder(
          horizontalInside: BorderSide(
            color: GsColors.dimWhite,
            width: 0.4,
          ),
        ),
        children: [
          _getTableRow(
            context.fromLabel(Labels.ascension),
            ascMats,
            (e) => GsRarityItemCard.withLabels(
              labelFooter: e.value.format(),
              rarity: e.key!.rarity,
              image: e.key!.image,
            ),
          ),
          _getTableRow(
            context.fromLabel(Labels.talents),
            tltMats,
            (e) => GsRarityItemCard.withLabels(
              labelFooter: e.value.format(),
              rarity: e.key!.rarity,
              image: e.key!.image,
            ),
          ),
          _getTableRow(
            context.fromLabel(Labels.total),
            totalMats,
            (e) => CharacterAscensionMaterial(e.key!.id, e.value),
          ),
        ],
      ),
    );
  }

  Widget _getTags(BuildContext context, InfoCharacter info) {
    return Row(
      children: [
        context.fromLabel(Labels.rarityStar, info.rarity),
        context.fromLabel(info.weapon.label),
        if (info.region != GsRegion.none) context.fromLabel(info.region.label),
        context.fromLabel(info.element.label),
        context.fromLabel(info.specialStat.label),
      ]
          .map<Widget>((e) => GsDataBox.label(e))
          .separate(SizedBox(width: kSeparator4))
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
