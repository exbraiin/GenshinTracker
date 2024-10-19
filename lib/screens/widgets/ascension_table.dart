import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/value_notifier_builder.dart';
import 'package:tracker/domain/enums/enum_ext.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/widgets/item_info_widget.dart';

typedef _MatsMap = Map<String, int> Function(int l);

class AscensionTable extends StatelessWidget {
  final TextStyle? style;
  final bool alwaysShowMats;
  final List<int> _levels;
  final _MatsMap _mats;
  final List<
      ({
        String Function(BuildContext ctx) label,
        String? Function(BuildContext ctx, int l) value,
      })> _statsBuilder;

  AscensionTable.weapon(
    GsWeapon item, {
    super.key,
    this.style,
    this.alwaysShowMats = false,
  })  : _levels = GsUtils.weaponMaterials
            .weaponAscension(item.rarity)
            .map((e) => e.level)
            .toList(),
        _mats =
            ((l) => GsUtils.weaponMaterials.getAscensionMaterials(item.id, l)),
        _statsBuilder = [
          (
            label: (ctx) => ctx.labels.wsAtk(),
            value: (ctx, l) => item.ascAtkValues.split(',').elementAtOrNull(l),
          ),
          if (item.statType != GeWeaponAscStatType.none)
            (
              label: (ctx) => item.statType.label(ctx),
              value: (ctx, l) =>
                  item.ascStatValues.split(',').elementAtOrNull(l),
            ),
        ];

  AscensionTable.character(
    GsCharacter item, {
    super.key,
    this.style = const TextStyle(color: Colors.white),
    this.alwaysShowMats = false,
  })  : _levels = GsUtils.characterMaterials
            .characterAscension()
            .map((e) => e.level)
            .toList(),
        _mats = ((l) =>
            GsUtils.characterMaterials.getAscensionMaterials(item.id, l)),
        _statsBuilder = [
          (
            label: (ctx) => ctx.labels.wsHp(),
            value: (ctx, l) => item.ascHpValues.split(',').elementAtOrNull(l),
          ),
          (
            label: (ctx) => ctx.labels.wsAtk(),
            value: (ctx, l) => item.ascAtkValues.split(',').elementAtOrNull(l),
          ),
          (
            label: (ctx) => ctx.labels.wsDef(),
            value: (ctx, l) => item.ascDefValues.split(',').elementAtOrNull(l),
          ),
          (
            label: (ctx) => item.ascStatType.label(ctx),
            value: (ctx, l) => item.ascStatValues.split(',').elementAtOrNull(l),
          ),
        ];

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.titleSmall!
        .copyWith(color: Colors.black)
        .merge(this.style);
    final header = style.copyWith(fontWeight: FontWeight.bold);
    final painter = TextPainter(
      text: TextSpan(
        text: context.labels.level(),
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
                    context.labels.level(),
                    style: header,
                    textAlign: TextAlign.center,
                  ),
                ),
                ..._statsBuilder.mapIndexed((i, e) {
                  final isLast =
                      i == _statsBuilder.length - 1 && !alwaysShowMats;
                  return Expanded(
                    child: Container(
                      decoration: decor(endCol: isLast),
                      padding: const EdgeInsets.all(kSeparator4),
                      child: Text(
                        e.label(context),
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
                        context.labels.materials(),
                        style: header,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
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
                      ..._statsBuilder.mapIndexed((attIdx, att) {
                        final endCol = attIdx == _statsBuilder.length - 1 &&
                            !alwaysShowMats;
                        return Expanded(
                          child: Container(
                            height: alwaysShowMats ? 58 : null,
                            alignment: Alignment.center,
                            decoration: decor(endRow: endRow, endCol: endCol),
                            padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                            child: Text(
                              att.value.call(context, lvlIdx) ?? '-',
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
                                        Database.instance.infoOf<GsMaterial>();
                                    final item = db.getItem(e.key);
                                    if (item == null) return const SizedBox();
                                    return ItemGridWidget.material(
                                      item,
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
                              final db = Database.instance.infoOf<GsMaterial>();
                              final item = db.getItem(e.key);
                              if (item == null) return const SizedBox();
                              return ItemGridWidget.material(
                                item,
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
