import 'package:dartx/dartx_io.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_wish_state_icon.dart';
import 'package:tracker/domain/enums/enum_ext.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/widgets/item_info_widget.dart';
import 'package:tracker/screens/widgets/primogem_icon.dart';

const _arrow = '→';

class HomeWishesValues extends StatelessWidget {
  final GeBannerType banner;

  const HomeWishesValues({
    super.key,
    required this.banner,
  });

  @override
  Widget build(BuildContext context) {
    final st = Theme.of(context).textTheme.titleSmall!;
    final style = st.copyWith(color: context.themeColors.almostWhite);

    final sw = GsUtils.wishes;
    final wishes = sw.getSaveWishesByBannerType(banner).sortedDescending();

    final summary = WishesSummary.fromBannerType(banner);

    final maxPity = banner == GeBannerType.weapon ? 80 : 90;
    final title = switch (banner) {
      GeBannerType.weapon => Labels.weaponWishes,
      GeBannerType.standard => Labels.stndWishes,
      GeBannerType.beginner => Labels.noviceWishes,
      GeBannerType.character => Labels.charWishes,
      GeBannerType.chronicled => Labels.chronicledWishes,
    };

    return GsDataBox.info(
      title: Row(
        children: [
          Expanded(child: Text(context.fromLabel(title))),
          Text(
            (wishes.length * GsUtils.details.primogemsPerWish).format(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(width: kSeparator2),
          const PrimogemIcon(size: 18, offset: Offset(0, -1)),
        ],
      ),
      child: Column(
        children: [
          _summary(context, wishes, summary, maxPity),
          const SizedBox(height: kSeparator8),
          _getCharGraph(
            context: context,
            summary: summary,
            wishes: wishes,
            maxPity: maxPity,
          ),
          const SizedBox(height: kSeparator8),
          Row(
            children: [
              const Spacer(flex: 3),
              Expanded(
                child: Center(
                  child: Text(
                    context.fromLabel(Labels.total),
                    style: style,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    context.fromLabel(Labels.per),
                    style: style,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    context.fromLabel(Labels.pity),
                    style: style,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: context.themeColors.divider,
            thickness: 1,
            height: 8,
          ),
          _getPullInfo(
            context,
            summary.info5,
            context.fromLabel(Labels.rarityStar, 5),
            context.themeColors.getRarityColor(5),
          ),
          if (banner == GeBannerType.standard) ...[
            Divider(
              color: context.themeColors.divider,
              thickness: 1,
              height: 8,
            ),
            _getPullInfo(
              context,
              summary.info5Character,
              '   $_arrow ${context.fromLabel(Labels.character)}',
              context.themeColors.getRarityColor(5),
            ),
            Divider(
              color: context.themeColors.divider,
              thickness: 1,
              height: 8,
            ),
            _getPullInfo(
              context,
              summary.info5Weapon,
              '   $_arrow ${context.fromLabel(Labels.weapon)}',
              context.themeColors.getRarityColor(5),
            ),
          ],
          if (banner == GeBannerType.character ||
              banner == GeBannerType.weapon) ...[
            Divider(
              color: context.themeColors.divider,
              thickness: 1,
              height: 8,
            ),
            _getWonInfo(
              context,
              summary.info5,
              '   $_arrow ${context.fromLabel(banner.getWonLabel(5))}',
              context.themeColors.getRarityColor(5),
            ),
          ],
          Divider(
            color: context.themeColors.divider,
            thickness: 1,
            height: 8,
          ),
          _getPullInfo(
            context,
            summary.info4,
            context.fromLabel(Labels.rarityStar, 4),
            context.themeColors.getRarityColor(4),
          ),
          Divider(
            color: context.themeColors.divider,
            thickness: 1,
            height: 8,
          ),
          _getPullInfo(
            context,
            summary.info4Character,
            '   $_arrow ${context.fromLabel(Labels.character)}',
            context.themeColors.getRarityColor(4),
          ),
          Divider(
            color: context.themeColors.divider,
            thickness: 1,
            height: 8,
          ),
          _getPullInfo(
            context,
            summary.info4Weapon,
            '   $_arrow ${context.fromLabel(Labels.weapon)}',
            context.themeColors.getRarityColor(4),
          ),
          _getWishesList(
            style: style,
            summary: summary,
            wishes: wishes,
            maxPity: maxPity,
          ),
        ],
      ),
    );
  }

  Row _summary(
    BuildContext context,
    List<GiWish> wishes,
    WishesSummary summary,
    int maxPity,
  ) {
    final last = summary.info5.last;
    final show = banner == GeBannerType.character;
    final pityColor = context.themeColors.getPityColor(last, maxPity);
    final guaranteed = show && GsUtils.wishes.isNextGaranteed(wishes);
    return Row(
      children: [
        Expanded(
          child: _summaryContainer(
            context,
            wishes.length.format(),
            context.fromLabel(Labels.lifetimePulls),
            valueColor: context.themeColors.almostWhite,
          ),
        ),
        Expanded(
          child: _summaryContainer(
            context,
            summary.info5.last.format(),
            context.fromLabel(Labels.l5sPity),
            valueColor: pityColor,
            wasGuaranteed: guaranteed,
          ),
        ),
        Expanded(
          child: _summaryContainer(
            context,
            summary.info4.last.format(),
            context.fromLabel(Labels.l4sPity),
            valueColor: context.themeColors.getRarityColor(4),
          ),
        ),
      ],
    );
  }

  Widget _getCharGraph({
    required BuildContext context,
    required WishesSummary summary,
    required List<GiWish> wishes,
    required int maxPity,
  }) {
    if (summary.info5.wishes.isEmpty) return const SizedBox();
    final map = <int, int>{};
    for (final wish in summary.info5.wishes) {
      final pity = wish.pity;
      if (pity > maxPity) continue;
      map[pity] = (map[pity] ?? 0) + 1;
    }

    final max = map.values.max() ?? 0;
    return Container(
      height: 40,
      margin: const EdgeInsets.all(kSeparator4),
      child: LayoutBuilder(
        builder: (context, layout) {
          final width = layout.maxWidth / maxPity;
          final height = layout.maxHeight / max;
          return Stack(
            children: [
              Positioned.fill(
                child: Divider(
                  color: context.themeColors.mainColor1,
                ),
              ),
              Row(
                children: List<Widget>.generate(maxPity, (index) {
                  final pity = index + 1;
                  final amount = map[pity] ?? 0;
                  final color = context.themeColors.getPityColor(pity, maxPity);
                  late final radius = (width - 2) / 2;
                  return Stack(
                    children: [
                      SizedBox(width: width),
                      if (amount > 0)
                        Center(
                          child: Tooltip(
                            preferBelow: false,
                            message: 'Pity: ${index + 1}\nTotal: $amount',
                            child: MouseHoverBuilder(
                              builder: (context, value, child) {
                                return AnimatedContainer(
                                  width: width - 2,
                                  height: amount * height,
                                  decoration: BoxDecoration(
                                    color: value ? Colors.white : color,
                                    borderRadius: BorderRadius.circular(width),
                                  ),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 1),
                                  duration: const Duration(milliseconds: 400),
                                );
                              },
                            ),
                          ),
                        ),
                      if (pity % 10 == 0 && pity != maxPity)
                        Center(
                          child: Container(
                            width: width - 2,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            child: Container(
                              width: radius,
                              height: radius,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _getWishesList({
    required TextStyle style,
    required WishesSummary summary,
    required List<GiWish> wishes,
    required int maxPity,
  }) {
    if (summary.info5.total == 0) return const SizedBox();
    var expanded = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            SizedBox(
              child: Center(
                child: IconButton(
                  onPressed: () => setState(() => expanded = !expanded),
                  padding: const EdgeInsets.all(kSeparator4),
                  constraints: const BoxConstraints.tightFor(),
                  icon: AnimatedRotation(
                    turns: expanded ? 0.5 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 400),
              constraints: BoxConstraints(maxHeight: expanded ? 300 : 0),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: kSeparator4),
                child: Wrap(
                  spacing: kGridSeparator,
                  runSpacing: kGridSeparator,
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: summary.info5.wishes.reversed.map((wish) {
                    final item = wish.item;
                    final pity = wish.pity;
                    final state = wish.state;
                    final pityColor =
                        context.themeColors.getPityColor(pity, maxPity);

                    return Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            item.character != null
                                ? ItemGridWidget.character(item.character!)
                                : item.weapon != null
                                    ? ItemGridWidget.weapon(item.weapon!)
                                    : const SizedBox(),
                            if (state == WishState.won)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Icon(
                                  Icons.star_rounded,
                                  size: 20,
                                  color: Colors.yellow,
                                  shadows: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.8),
                                      offset: const Offset(1, 1),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: kSeparator2),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: pity.toString(),
                                style: style.copyWith(
                                  color: pityColor,
                                ),
                              ),
                              if (state == WishState.guaranteed)
                                WidgetSpan(
                                  child: GsWishStateIcon(
                                    state,
                                    color: pityColor,
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _summaryContainer(
    BuildContext context,
    String value,
    String label, {
    Color? valueColor,
    bool wasGuaranteed = false,
  }) {
    return Container(
      height: 56,
      margin: const EdgeInsets.all(kSeparator2),
      padding: const EdgeInsets.all(kSeparator4),
      decoration: BoxDecoration(
        color: context.themeColors.mainColor1.withOpacity(0.4),
        borderRadius: kGridRadius,
      ),
      child: Center(
        child: Text.rich(
          TextSpan(
            children: [
              if (wasGuaranteed)
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(
                      Icons.arrow_circle_up_rounded,
                      color: valueColor,
                      size: 18,
                    ),
                  ),
                ),
              TextSpan(
                text: value,
                style: context.textTheme.titleSmall!.copyWith(
                  fontSize: 18,
                  color: valueColor ?? context.themeColors.dimWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextSpan(text: '\n'),
              TextSpan(
                text: label,
                style: context.textTheme.titleSmall!.copyWith(
                  fontSize: 12,
                  color: context.themeColors.dimWhite,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _getInfo(
    BuildContext context,
    String label,
    Color color,
    List<num?> data,
  ) {
    final st = Theme.of(context).textTheme.titleSmall!;
    final style = st.copyWith(color: context.themeColors.dimWhite);
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: style.copyWith(color: color),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              data[0]?.toString() ?? '',
              style: style.copyWith(color: color),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              data[1] != null ? '${data[1]!.toStringAsFixed(1)}%' : '',
              style: style.copyWith(color: color),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              data[2]?.toStringAsFixed(1) ?? '',
              style: style.copyWith(color: color),
              textAlign: TextAlign.end,
            ),
          ),
        ),
      ],
    );
  }

  Widget _getPullInfo(
    BuildContext context,
    WishesInfo info,
    String label,
    Color color,
  ) {
    return _getInfo(
      context,
      label,
      color,
      [info.wishes.length, info.percentage, info.average],
    );
  }

  Widget _getWonInfo(
    BuildContext context,
    WishesInfo info,
    String label,
    Color color,
  ) {
    final total = info.wishes
        .where((e) => e.state == WishState.won || e.state == WishState.lost);
    final won = total.count((e) => e.state == WishState.won);
    final percent = won / total.length.coerceAtLeast(1) * 100;
    return _getInfo(
      context,
      label,
      color,
      [won, percent, null],
    );
  }
}
