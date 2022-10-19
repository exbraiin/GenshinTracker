import 'package:flutter/material.dart';
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
    final info = args as InfoCharacter?;

    return ValueStreamBuilder<bool>(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        if (!snapshot.data! || info == null) return SizedBox();
        final ic = GsDatabase.instance.infoDetails;
        final details = ic.exists(info.id) ? ic.getItem(info.id) : null;
        return Scaffold(
          appBar: GsAppBar(
            label: info.name,
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  getElementBgImage(info.element),
                  fit: BoxFit.cover,
                ),
              ),
              ListView(
                padding: EdgeInsets.all(kSeparator4),
                children: [
                  _getInfo(context, info, details),
                  _getAttributes(context, info, details),
                  if (details != null) ...[
                    SizedBox(height: kSeparator8),
                    _getAscension(context, info, details),
                    SizedBox(height: kSeparator8),
                    _getTalents(context, info, details),
                    SizedBox(height: kSeparator8),
                    _getConstellations(context, info, details),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getInfo(
    BuildContext context,
    InfoCharacter info,
    InfoCharacterDetails? desc,
  ) {
    final db = GsDatabase.instance.saveCharacters;
    final ascension = db.getCharAscension(info.id);
    return SizedBox(
      height: 260,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: kMainRadius.copyWith(
                bottomRight: Radius.circular(24),
              ),
              image: DecorationImage(
                image: AssetImage(getRarityBgImage(info.rarity)),
                fit: BoxFit.contain,
              ),
            ),
            child: ClipRRect(
              borderRadius: kMainRadius.copyWith(
                bottomRight: Radius.circular(24),
              ),
              child: CachedImageWidget(info.image),
            ),
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
                  desc?.description ?? '',
                  style: context.textTheme.description2,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 460,
            child: CachedImageWidget(
              desc?.fullImage,
              fit: BoxFit.fitWidth,
            ),
          )
        ],
      ),
    );
  }

  Widget _getAttributes(
    BuildContext context,
    InfoCharacter info,
    InfoCharacterDetails? desc,
  ) {
    final style = context.textTheme.subtitle2!;
    final stLabel = style.copyWith(color: GsColors.dimWhite);
    final stStyle = style.copyWith(color: Colors.white);
    final unknown = context.fromLabel(Labels.wsNone);
    return _InfoCard(
      title: 'Attributes',
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
                Text('Name', style: stLabel),
                Text(info.name, style: stStyle),
                Text('Birthday', style: stLabel),
                Text(desc?.birthday.toPrettyDate() ?? unknown, style: stStyle),
              ]
                  .map((e) => Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 16, 8),
                        child: e,
                      ))
                  .toList(),
            ),
            TableRow(
              children: [
                Text('Constellation', style: stLabel),
                Text(desc?.constellation ?? unknown, style: stStyle),
                Text('Title', style: stLabel),
                Text(desc?.title ?? unknown, style: stStyle),
              ]
                  .map((e) => Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 16, 8),
                        child: e,
                      ))
                  .toList(),
            ),
            TableRow(
              children: [
                Text('Vision', style: stLabel),
                Text(info.element.toPrettyString(context), style: stStyle),
                Text('Affiliation', style: stLabel),
                Text(desc?.affiliation ?? unknown, style: stStyle),
              ]
                  .map((e) => Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 16, 8),
                        child: e,
                      ))
                  .toList(),
            ),
            TableRow(
              children: [
                Text('Weapon', style: stLabel),
                Text(info.weapon.toPrettyString(context), style: stStyle),
                Text('Version', style: stLabel),
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
                Text('Special Dish', style: stLabel),
                Text(desc?.specialDish ?? unknown, style: stStyle),
                Text('Release Date', style: stLabel),
                Text(desc?.releaseDate.toPrettyDate() ?? unknown,
                    style: stStyle),
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

  Widget _getAscension(
    BuildContext context,
    InfoCharacter info,
    InfoCharacterDetails desc,
  ) {
    final style = context.textTheme.subtitle2!.copyWith(color: Colors.white);
    final values = desc.ascension
        .expand((e) => [
              ...e.valuesAfter.keys,
              ...e.valuesBefore.keys,
            ])
        .toSet()
        .take(4);
    return _InfoCard(
      title: 'Ascension',
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
                    child: Text('Level', style: style),
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
                Center(child: Text('Materials', style: style)),
              ],
            ),
            ...desc.ascension.map(
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

  Widget _getTalents(
    BuildContext context,
    InfoCharacter info,
    InfoCharacterDetails desc,
  ) {
    return _InfoCard(
      title: 'Talents',
      children: desc.talents
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

  Widget _getConstellations(
    BuildContext context,
    InfoCharacter info,
    InfoCharacterDetails desc,
  ) {
    return _InfoCard(
      title: 'Contellation',
      children: desc.constellations
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

class _InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  _InfoCard({required this.title, this.children = const []});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kSeparator8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: kMainRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textTheme.bigTitle3.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'NotoSans',
            ),
          ),
          Divider(
            color: GsColors.dimWhite,
          ),
          ...children,
        ],
      ),
    );
  }
}
