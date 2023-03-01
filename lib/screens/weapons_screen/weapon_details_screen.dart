import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/cards/gs_rarity_item_card.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/common/widgets/text_style_parser.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/character_ascension_screen/character_ascension_material.dart';
import 'package:tracker/screens/characters_screen/character_details_screen.dart';
import 'package:tracker/theme/theme.dart';

class WeaponDetailsScreen extends StatelessWidget {
  static const id = 'weapon_details_screen';

  const WeaponDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final info = args! as InfoWeapon;
    final db = GsDatabase.instance.infoWeaponsInfo;
    final details = db.getItemOrNull(info.id);

    final hasEffect = details?.effectName.isNotEmpty ?? false;

    return Scaffold(
      appBar: GsAppBar(label: info.name),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: context.themeColors
              .getRarityColor(info.rarity)
              .withOpacity(kDisableOpacity),
          image: DecorationImage(
            opacity: 0.1,
            fit: BoxFit.cover,
            image: AssetImage(getRarityBgImage(info.rarity)),
          ),
        ),
        child: ValueStreamBuilder<bool>(
          stream: GsDatabase.instance.loaded,
          builder: (context, snapshot) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(kSeparator4),
              child: Column(
                children: [
                  _getInfo(context, info),
                  if (details != null) ...[
                    const SizedBox(height: kSeparator8),
                    if (hasEffect) _getEffect(context, details),
                    if (hasEffect) const SizedBox(height: kSeparator8),
                    _getAscension(context, info.rarity, details),
                    const SizedBox(height: kSeparator8),
                    _getAllMaterials(context, details),
                  ]
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _getInfo(BuildContext context, InfoWeapon info) {
    var first = true;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StatefulBuilder(
          builder: (context, setState) {
            return GsRarityItemCard(
              size: 120,
              image: first ? info.image : info.imageAscension,
              rarity: info.rarity,
              onTap: () => setState(() => first = !first),
            );
          },
        ),
        const SizedBox(width: kSeparator8),
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
                      const SizedBox(height: kSeparator2),
                      Text(
                        '${info.atk}',
                        style: context.textTheme.bigTitle3,
                      ),
                      if (info.statType != GsAttributeStat.none) ...[
                        const SizedBox(height: kSeparator8),
                        Text(
                          context.fromLabel(info.statType.label),
                          style: context.textTheme.description,
                        ),
                        const SizedBox(height: kSeparator2),
                        Text(
                          info.statType.toIntOrPercentage(info.statValue),
                          style: context.textTheme.bigTitle3,
                        ),
                      ]
                    ],
                  ),
                  const SizedBox(width: kSeparator8 * 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              info.name,
                              style: Theme.of(context).textTheme.bigTitle2,
                            ),
                            const SizedBox(width: kSeparator8),
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
                        const SizedBox(height: kSeparator8),
                        _getTags(context, info),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 360),
      ],
    );
  }

  Widget _getAscension(BuildContext context, int rarity, InfoWeaponInfo info) {
    final style = context.textTheme.titleSmall!.copyWith(color: Colors.white);
    final ascension =
        GsDatabase.instance.infoWeaponsInfo.weaponAscension(rarity);
    return GsDataBox.info(
      title: context.fromLabel(Labels.ascension),
      child: IntValueStream(
        builder: (context, notifier, child) {
          final idx = notifier.value;
          final mats = GsDatabase.instance.infoWeaponsInfo
              .getAscensionMaterials(info.id, idx);
          final atk = info.ascAtkValues.elementAtOrNull(idx);
          final stat = info.ascStatValues.elementAtOrNull(idx);
          return Column(
            children: [
              Row(
                children: ascension
                    .mapIndexed<Widget>((idx, cfg) {
                      return Opacity(
                        opacity: notifier.value == idx ? 1 : kDisableOpacity,
                        child: ItemRarityBubble(
                          color: context.themeColors
                              .getRarityColor(rarity)
                              .withOpacity(kDisableOpacity),
                          child: IgnorePointer(
                            child: Center(child: Text(cfg.level.toString())),
                          ),
                          onTap: () => notifier.value = idx,
                        ),
                      );
                    })
                    .separate(const SizedBox(width: kSeparator8))
                    .toList(),
              ),
              const SizedBox(height: kSeparator2),
              Divider(color: context.themeColors.dimWhite),
              if (atk != null || stat != null)
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: IntrinsicColumnWidth(),
                  },
                  children: [
                    TableRow(
                      children: [
                        Text(
                          context.fromLabel(GsAttributeStat.atk.label),
                          style: style,
                        ),
                        const SizedBox(width: kSeparator8, height: 24),
                        Text(atk ?? '-', style: style),
                      ],
                    ),
                    if (info.ascStatType != GsAttributeStat.none)
                      TableRow(
                        children: [
                          Text(
                            context.fromLabel(info.ascStatType.label),
                            style: style,
                          ),
                          const SizedBox(width: kSeparator8, height: 24),
                          Text(stat ?? '-', style: style),
                        ],
                      ),
                    if (mats.isNotEmpty)
                      TableRow(
                        children: [
                          Text(
                            context.fromLabel(Labels.materials),
                            style: style,
                          ),
                          const SizedBox(width: kSeparator8, height: 24),
                          Row(
                            children: mats.entries
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
                          ),
                        ],
                      ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _getAllMaterials(BuildContext context, InfoWeaponInfo info) {
    final im = GsDatabase.instance.infoMaterials;
    final iw = GsDatabase.instance.infoWeaponsInfo;
    final ascMats = iw.getAscensionMaterials(info.id);

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
            context.fromLabel(Labels.total),
            ascMats,
            (e) => CharacterAscensionMaterial(e.key!.id, e.value),
          ),
        ],
      ),
    );
  }

  Widget _getEffect(BuildContext context, InfoWeaponInfo info) {
    var r = 0;
    final levels = _getEffectLevels(info.effectDesc);
    return GsDataBox.info(
      title: info.effectName,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: List.generate(
                  levels,
                  (index) => _getTextButton(
                    context,
                    'Refinement ${index + 1}',
                    selected: index == r,
                    onTap: () => setState(() => r = index),
                  ),
                ),
              ),
              const SizedBox(width: kSeparator8 * 2),
              Expanded(
                child: TextParserWidget(
                  _getEffectText(info.effectDesc, r),
                  style: context.textTheme.titleSmall!
                      .copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(height: kSeparator4),
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
                .copyWith(color: selected ? context.themeColors.primary : null),
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
          .map<Widget>((e) => GsItemCardLabel(label: e))
          .separate(const SizedBox(width: kSeparator4))
          .toList(),
    );
  }

  int _getEffectLevels(String content) {
    final match = RegExp('{.+?}').firstMatch(content);
    final matches = match?.input.substring(match.start, match.end);
    return matches?.toString().split(',').length ?? 0;
  }

  String _getEffectText(String content, int level) {
    var text = content.toString();
    final matches = RegExp('{.+?}').allMatches(content).reversed;
    for (var match in matches) {
      final temp = content
          .substring(match.start, match.end)
          .removePrefix('{')
          .removeSuffix('}');
      final value = temp.toString().split(',').map((e) => e.trim());
      var replacement = value.elementAtOrNull(level) ?? '';
      replacement = '<color=skill>$replacement</color>';
      text = text.replaceRange(match.start, match.end, replacement);
    }
    return text;
  }
}
