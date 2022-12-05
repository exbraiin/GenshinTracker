import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/cards/gs_rarity_item_card.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/common/widgets/text_style_parser.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/character_ascension_screen/character_ascension_material.dart';

class WeaponDetailsScreen extends StatelessWidget {
  static const id = 'weapon_details_screen';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final info = args as InfoWeapon;
    final db = GsDatabase.instance.infoWeaponsDetails;
    final details = db.getItemOrNull(info.id);

    final hasEffect = details?.effectName.isNotEmpty ?? false;

    return Scaffold(
      appBar: GsAppBar(label: info.name),
      body: ValueStreamBuilder<bool>(
        stream: GsDatabase.instance.loaded,
        builder: (context, snapshot) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(kSeparator4),
            child: Column(
              children: [
                _getInfo(context, info),
                if (details != null) ...[
                  SizedBox(height: kSeparator8),
                  if (hasEffect) _getEffect(context, details),
                  if (hasEffect) SizedBox(height: kSeparator8),
                  _getAscension(context, details),
                  SizedBox(height: kSeparator8),
                  _getAllMaterials(context, details),
                ]
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _getInfo(BuildContext context, InfoWeapon info) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GsRarityItemCard(
          size: 120,
          image: info.image,
          rarity: info.rarity,
        ),
        SizedBox(width: kSeparator8),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.fromLabel(GsAttributeStat.atk.label),
                        style: context.textTheme.description,
                      ),
                      SizedBox(height: kSeparator2),
                      Text(
                        '${info.atk}',
                        style: context.textTheme.bigTitle3,
                      ),
                      if (info.statType != GsAttributeStat.none) ...[
                        SizedBox(height: kSeparator8),
                        Text(
                          context.fromLabel(info.statType.label),
                          style: context.textTheme.description,
                        ),
                        SizedBox(height: kSeparator2),
                        Text(
                          '${info.statType.toIntOrPercentage(info.statValue)}',
                          style: context.textTheme.bigTitle3,
                        ),
                      ]
                    ],
                  ),
                  SizedBox(width: kSeparator8 * 2),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              info.name,
                              style: Theme.of(context).textTheme.bigTitle2,
                            ),
                            SizedBox(width: kSeparator8),
                            if (info.statType != GsAttributeStat.none)
                              Image.asset(
                                info.statType.assetPath,
                                width: 18,
                                height: 18,
                              ),
                          ],
                        ),
                        Text(
                          info.description,
                          style: context.textTheme.description2,
                        ),
                        SizedBox(height: kSeparator8),
                        _getTags(context, info),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 360),
      ],
    );
  }

  Widget _getAscension(BuildContext context, InfoWeaponDetails info) {
    final style = context.textTheme.subtitle2!.copyWith(color: Colors.white);
    final values = info.ascension
        .expand((e) => [
              ...e.valuesAfter.keys,
              ...e.valuesBefore.keys,
            ])
        .toSet()
        .take(4);
    return GsDataBox.info(
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

  Widget _getAllMaterials(BuildContext context, InfoWeaponDetails info) {
    final ascMats = info.allMaterials;
    final db = GsDatabase.instance.infoMaterials;

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
                  .sortedBy((e) => e.key!.group.index)
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
            context.fromLabel(Labels.total),
            ascMats,
            (e) => CharacterAscensionMaterial(e.key!.id, e.value),
          ),
        ],
      ),
    );
  }

  Widget _getEffect(BuildContext context, InfoWeaponDetails info) {
    var r = 0;
    return GsDataBox.info(
      title: info.effectName,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: List.generate(
                  info.effectValues.length,
                  (index) => _getTextButton(
                    context,
                    'Refinement ${index + 1}',
                    selected: index == r,
                    onTap: () => setState(() => r = index),
                  ),
                ),
              ),
              SizedBox(width: kSeparator8 * 2),
              Expanded(
                child: info.effectValues.isNotEmpty
                    ? TextParserWidget(
                        _getEffectText(
                          info.effectDescription,
                          info.effectValues[r],
                        ),
                        style: context.textTheme.subtitle2!
                            .copyWith(color: Colors.white),
                      )
                    : SizedBox(),
              ),
              SizedBox(height: kSeparator4),
            ],
          );
        },
      ),
    );
  }

  Widget _getTextButton(
    BuildContext context,
    String text, {
    VoidCallback? onTap,
    bool selected = false,
  }) {
    var hover = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return InkWell(
          onTap: onTap,
          onHover: (h) => setState(() => hover = h),
          child: Text(
            '${hover || selected ? '✦' : '✧'} $text',
            style: context.textTheme.description2
                .copyWith(color: selected ? Colors.orange : null),
          ),
        );
      },
    );
  }

  Widget _getTags(BuildContext context, InfoWeapon info) {
    return Row(
      children: [
        context.fromLabel(Labels.rarityStar, info.rarity),
        context.fromLabel(info.type.label),
        context.fromLabel(info.statType.label),
      ]
          .map<Widget>((e) => GsDataBox.label(e))
          .separate(SizedBox(width: kSeparator4))
          .toList(),
    );
  }

  String _getEffectText(String description, List<String> effectValues) {
    var value = description;
    for (var i = 0; i < effectValues.length; ++i) {
      final data = '<color=skill>${effectValues[i]}</color>';
      value = value.replaceAll('{$i}', data);
    }
    return value;
  }
}
