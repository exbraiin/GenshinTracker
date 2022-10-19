import 'package:flutter/material.dart';
import 'package:tracker/common/cards/gs_info_container.dart';
import 'package:tracker/common/cards/gs_rarity_item_card.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/labels.dart';
import 'package:tracker/common/text_style_parser.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/common/widgets/file_image.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/character_ascension_screen/character_ascension_material.dart';

class CharacterDetailsScreen extends StatelessWidget {
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
              ListView(
                padding: EdgeInsets.all(kSeparator4),
                children: [
                  _getInfo(context, details),
                  _getAttributes(context, details),
                  SizedBox(height: kSeparator8),
                  _getAscension(context, details),
                  SizedBox(height: kSeparator8),
                  _getTalents(context, details),
                  SizedBox(height: kSeparator8),
                  _getConstellations(context, details),
                ],
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
          GsRarityItemCard(
            size: 120,
            image: info.image,
            rarity: info.rarity,
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
              ],
            ),
          ),
          SizedBox(
            width: 360,
            child: CachedImageWidget(
              info.fullImage,
              fit: BoxFit.fitWidth,
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
    return GsInfoContainer(
      title: context.fromLabel(Labels.attributes),
      children: [
        Table(
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
                Text(info.element.toPrettyString(context), style: stStyle),
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
                Text(info.weapon.toPrettyString(context), style: stStyle),
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
                Text(info.specialDish, style: stStyle),
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
    return GsInfoContainer(
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
                      e.toPrettyString(context),
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
                          e.valuesAfter[v] == null && e.valuesBefore[v] != null
                              ? v.toIntOrPercentage(e.valuesBefore[v]!)
                              : e.valuesAfter[v] != null &&
                                      e.valuesBefore[v] == null
                                  ? v.toIntOrPercentage(e.valuesAfter[v]!)
                                  : '${v.toIntOrPercentage(e.valuesBefore[v]!)} → '
                                      '${v.toIntOrPercentage(e.valuesAfter[v]!)}',
                          style: context.textTheme.subtitle2!
                              .copyWith(color: Colors.white),
                        ),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (e.materials.isNotEmpty)
                        ...e.materials.entries
                            .map<Widget>((e) =>
                                CharacterAscensionMaterial(e.key, e.value))
                            .separate(SizedBox(width: kSeparator4)),
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
    return GsInfoContainer(
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
                  parseTextStyle2(
                    e.desc,
                    context.textTheme.subtitle2!.copyWith(color: Colors.white),
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
    return GsInfoContainer(
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
                  parseTextStyle2(
                    e.desc,
                    context.textTheme.subtitle2!.copyWith(color: Colors.white),
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
}
