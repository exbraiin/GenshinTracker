import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/common/widgets/value_notifier_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

typedef _MatsMap = Map<String, int> Function(int l);
typedef _StatsMap = Map<GsAttributeStat, String? Function(int l)>;

class AscensionTable extends StatelessWidget {
  final TextStyle? style;
  final bool alwaysShowMats;
  final List<int> _levels;
  final _MatsMap _mats;
  final _StatsMap _statsBuilder;

  AscensionTable.weapon(
    InfoWeapon item,
    InfoWeaponInfo info, {
    super.key,
    this.style,
    this.alwaysShowMats = false,
  })  : _levels = GsUtils.weaponMaterials
            .weaponAscension(item.rarity)
            .map((e) => e.level)
            .toList(),
        _mats =
            ((l) => GsUtils.weaponMaterials.getAscensionMaterials(item.id, l)),
        _statsBuilder = {
          GsAttributeStat.atk: (l) => info.ascAtkValues.elementAtOrNull(l),
          item.statType: (l) => info.ascStatValues.elementAtOrNull(l),
        };

  AscensionTable.character(
    InfoCharacter item,
    InfoCharacterInfo info, {
    super.key,
    this.style = const TextStyle(color: Colors.white),
    this.alwaysShowMats = false,
  })  : _levels = GsUtils.characterMaterials
            .characterAscension()
            .map((e) => e.level)
            .toList(),
        _mats = ((l) =>
            GsUtils.characterMaterials.getAscensionMaterials(item.id, l)),
        _statsBuilder = {
          GsAttributeStat.hp: (l) =>
              info.ascension.ascHpValues.elementAtOrNull(l),
          GsAttributeStat.atk: (l) =>
              info.ascension.ascAtkValues.elementAtOrNull(l),
          GsAttributeStat.def: (l) =>
              info.ascension.ascDefValues.elementAtOrNull(l),
          info.ascension.ascStatType: (l) =>
              info.ascension.ascStatValues.elementAtOrNull(l),
        };

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.titleSmall!
        .copyWith(color: Colors.black)
        .merge(this.style);
    final header = style.copyWith(fontWeight: FontWeight.bold);
    final painter = TextPainter(
      text: TextSpan(
        text: context.fromLabel(Labels.level),
        style: header,
      ),
      textDirection: TextDirection.rtl,
    );
    painter.layout();
    final pw = painter.width + 4 + 8;

    final dimColor = style.color!.withOpacity(0.2);
    BoxDecoration decor({bool endCol = false, bool endRow = false}) {
      final border = BorderSide(color: dimColor);
      return BoxDecoration(
        border: Border(
          top: border,
          left: border,
          right: endCol ? border : BorderSide.none,
          bottom: endRow ? border : BorderSide.none,
        ),
      );
    }

    final validStats =
        _statsBuilder.keys.where((e) => e != GsAttributeStat.none);
    return ValueNotifierBuilder<bool>(
      value: false,
      builder: (context, notifier, child) {
        return Column(
          children: [
            const SizedBox(height: kSeparator4),
            Row(
              children: [
                Container(
                  width: pw,
                  decoration: decor(),
                  padding: const EdgeInsets.all(kSeparator4),
                  child: Text(
                    context.fromLabel(Labels.level),
                    style: header,
                    textAlign: TextAlign.center,
                  ),
                ),
                ...validStats.mapIndexed((i, e) {
                  final isLast = i == validStats.length - 1 && !alwaysShowMats;
                  return Expanded(
                    child: Container(
                      decoration: decor(endCol: isLast),
                      padding: const EdgeInsets.all(kSeparator4),
                      child: Text(
                        context.fromLabel(e.label),
                        style: header,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }),
                if (alwaysShowMats)
                  Expanded(
                    child: Container(
                      decoration: decor(endCol: true),
                      padding: const EdgeInsets.all(kSeparator4),
                      child: Text(
                        context.fromLabel(Labels.materials),
                        style: header,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
              ],
            ),
            ..._levels.mapIndexed((lvlIdx, lvl) {
              final endRow = lvlIdx == _levels.length - 1;
              final mats = _mats(lvlIdx);
              return Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: pw,
                        height: alwaysShowMats ? 58 : null,
                        decoration: decor(endRow: endRow),
                        padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                        alignment: Alignment.centerRight,
                        child: Text(
                          lvl.compact(),
                          style: style,
                          textAlign: TextAlign.end,
                        ),
                      ),
                      ...validStats.mapIndexed((attIdx, att) {
                        final endCol =
                            attIdx == validStats.length - 1 && !alwaysShowMats;
                        return Expanded(
                          child: Container(
                            height: alwaysShowMats ? 58 : null,
                            alignment: Alignment.center,
                            decoration: decor(endRow: endRow, endCol: endCol),
                            padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                            child: Text(
                              _statsBuilder[att]?.call(lvlIdx) ?? '-',
                              style: style,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }),
                      if (alwaysShowMats)
                        Expanded(
                          child: Container(
                            height: 58,
                            decoration: decor(endCol: true, endRow: endRow),
                            padding: const EdgeInsets.all(kSeparator4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: mats.entries
                                  .map<Widget>((e) {
                                    final db =
                                        GsDatabase.instance.infoMaterials;
                                    final item = db.getItemOrNull(e.key);
                                    return ItemRarityBubble.withLabel(
                                      image: item?.image ?? '',
                                      rarity: item?.rarity ?? 1,
                                      label: e.value.compact(),
                                    );
                                  })
                                  .separate(const SizedBox(width: kSeparator4))
                                  .toList(),
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (!alwaysShowMats && notifier.value && mats.isNotEmpty)
                    Container(
                      decoration: decor(endCol: true, endRow: endRow),
                      padding: const EdgeInsets.all(kSeparator4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: mats.entries
                            .map<Widget>((e) {
                              final db = GsDatabase.instance.infoMaterials;
                              final item = db.getItemOrNull(e.key);
                              return ItemRarityBubble.withLabel(
                                image: item?.image ?? '',
                                rarity: item?.rarity ?? 1,
                                label: e.value.compact(),
                              );
                            })
                            .separate(const SizedBox(width: kSeparator4))
                            .toList(),
                      ),
                    ),
                ],
              );
            }),
            if (!alwaysShowMats)
              IconButton(
                color: dimColor,
                onPressed: () => notifier.value = !notifier.value,
                icon: Icon(
                  notifier.value
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                ),
              ),
          ],
        );
      },
    );
  }
}
