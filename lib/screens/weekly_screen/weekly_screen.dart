import 'dart:math' as math;

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/common/widgets/gs_no_results_state.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';
import 'package:tracker/domain/enums/gs_weekday.dart';
import 'package:tracker/domain/gs_database.dart';

class WeeklyScreen extends StatefulWidget {
  static const id = 'weekly_screen';

  const WeeklyScreen({super.key});

  @override
  State<WeeklyScreen> createState() => _WeeklyScreenState();
}

class _WeeklyScreenState extends State<WeeklyScreen> {
  var _owned = true;
  var _weekday = 0;

  @override
  void initState() {
    super.initState();
    _weekday = DateTime.now().weekday;
  }

  @override
  Widget build(BuildContext context) {
    final index = DateTime.now().weekday - 1;
    final weekday = GsWeekday.values[_weekday - 1];

    return Scaffold(
      appBar: GsAppBar(
        label: context.fromLabel(Labels.weeklyTasks),
        actions: [
          IconButton(
            icon: Icon(
              _owned ? Icons.visibility_rounded : Icons.visibility_off_rounded,
              color: Colors.white.withOpacity(0.5),
            ),
            onPressed: () => setState(() => _owned = !_owned),
          ),
          _getDropdown(context, index),
        ],
      ),
      body: Container(
        decoration: kMainBgDecoration,
        child: ListView(
          padding: const EdgeInsets.all(kSeparator4),
          children: GsUtils.items
              .getItemsByMaterial(weekday)
              .entries
              .map((entry) {
                final e = entry.key;
                final characters = entry.value
                    .where(
                      (e) =>
                          e.character != null &&
                          (!_owned || GsUtils.characters.hasCaracter(e.id)),
                    )
                    .sortedByDescending((element) => element.rarity)
                    .thenBy((element) => element.name);

                final weapons = entry.value
                    .where(
                      (e) =>
                          e.weapon != null &&
                          (!_owned || GsUtils.weapons.hasWeapon(e.id)),
                    )
                    .sortedBy((element) => element.rarity)
                    .thenBy((element) => element.name);

                final noContent = characters.isEmpty && weapons.isEmpty;
                return GsDataBox.info(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: CachedImageWidget(e.image),
                          ),
                          const SizedBox(width: kSeparator4),
                          Text(
                            e.name,
                            style: context.themeStyles.title20n,
                          ),
                        ],
                      ),
                      Divider(color: context.themeColors.divider),
                      if (noContent) const GsNoResultsState.small(),
                      Wrap(
                        spacing: kSeparator4,
                        runSpacing: kSeparator4,
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: characters.map((info) {
                          final exists =
                              GsUtils.characters.hasCaracter(info.id);
                          return Opacity(
                            opacity: exists ? 1 : kDisableOpacity,
                            child: ItemRarityBubble(
                              image: GsUtils.characters.getImage(info.id),
                              rarity: info.rarity,
                              tooltip: info.name,
                              size: 60,
                            ),
                          );
                        }).toList(),
                      ),
                      Wrap(
                        spacing: kSeparator4,
                        runSpacing: kSeparator4,
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: weapons.map((info) {
                          return Opacity(
                            opacity: GsUtils.weapons.hasWeapon(info.id)
                                ? 1
                                : kDisableOpacity,
                            child: ItemRarityBubble(
                              image: info.image,
                              rarity: info.rarity,
                              tooltip: info.name,
                              size: 60,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              })
              .toGrid(
                crossCount: 2,
                mainSpacing: kSeparator4,
                crossSpacing: kSeparator4,
                crossAxisAlignment: CrossAxisAlignment.start,
              )
              .toList(),
        ),
      ),
    );
  }

  Padding _getDropdown(BuildContext context, int now) {
    return Padding(
      padding: const EdgeInsets.all(kSeparator4),
      child: DropdownButton(
        style: context.themeStyles.label12n,
        value: _weekday - 1,
        underline: const SizedBox(),
        focusColor: Colors.transparent,
        iconEnabledColor: Colors.white,
        iconDisabledColor: Colors.white,
        items: GsWeekday.values.mapIndexed((idx, item) {
          late final color = context.themeColors.badValue;
          return DropdownMenuItem(
            value: idx,
            alignment: Alignment.center,
            child: Text(
              item.label,
              style: TextStyle(color: idx == now ? color : null),
            ),
          );
        }).toList(),
        onChanged: (int? i) => setState(() => _weekday = (i ?? 0) + 1),
        alignment: Alignment.center,
        borderRadius: kMainRadius,
        elevation: 1,
      ),
    );
  }
}

extension on Iterable<Widget> {
  static Iterable<E> _separated<E>(
    int count,
    E Function(int) itemBuilder,
    E Function(int) separatorBuilder,
  ) {
    return List.generate(math.max(0, count * 2 - 1), (i) {
      final itemIndex = i ~/ 2;
      if (i.isEven) return itemBuilder(itemIndex);
      return separatorBuilder(itemIndex);
    });
  }

  Iterable<Widget> toGrid({
    int crossCount = 2,
    double mainSpacing = 12,
    double crossSpacing = 12,
    bool shrinkRows = true,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) sync* {
    yield* _separated(
      (length / crossCount).ceil(),
      (i) => Row(
        crossAxisAlignment: crossAxisAlignment,
        children: _separated(
          shrinkRows
              ? crossCount
              : (length - i * crossCount).clamp(0, crossCount),
          (n) => i * crossCount + n < length
              ? Expanded(child: elementAt(i * crossCount + n))
              : const Spacer(),
          (n) => SizedBox(width: crossSpacing),
        ).toList(),
      ),
      (i) => SizedBox(height: mainSpacing),
    );
  }
}
