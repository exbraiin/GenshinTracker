import 'package:dartx/dartx_io.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/common/widgets/gs_wish_state_icon.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/widgets/primogem_icon.dart';

const _arrow = '→';
const _bannerTitleLabel = {
  GsBanner.character: Labels.charWishes,
  GsBanner.beginner: Labels.noviceWishes,
  GsBanner.weapon: Labels.weaponWishes,
  GsBanner.standard: Labels.stndWishes,
};

class HomeWishesValues extends StatelessWidget {
  final int maxPity;
  final String title;
  final GsBanner banner;

  const HomeWishesValues({
    super.key,
    required this.title,
    required this.banner,
    this.maxPity = 90,
  });

  @override
  Widget build(BuildContext context) {
    final st = Theme.of(context).textTheme.titleSmall!;
    final style = st.copyWith(color: context.themeColors.almostWhite);

    final sw = GsUtils.wishes;
    final wishes = sw.getSaveWishesByBannerType(banner).sortedDescending();
    final summary = WishesSummary.fromList(wishes);

    return GsDataBox.info(
      title: Row(
        children: [
          Expanded(child: Text(context.fromLabel(_bannerTitleLabel[banner]!))),
          Text(
            (wishes.length * GsDomain.primogemsPerWish).format(),
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
          _summary(context, wishes, summary),
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
            summary.wishesInfo5,
            context.fromLabel(Labels.rarityStar, 5),
            context.themeColors.getRarityColor(5),
          ),
          if (banner == GsBanner.standard) ...[
            Divider(
              color: context.themeColors.divider,
              thickness: 1,
              height: 8,
            ),
            _getPullInfo(
              context,
              summary.wishesInfo5Character,
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
              summary.wishesInfo5Weapon,
              '   $_arrow ${context.fromLabel(Labels.weapon)}',
              context.themeColors.getRarityColor(5),
            ),
          ],
          if (banner == GsBanner.character || banner == GsBanner.weapon) ...[
            Divider(
              color: context.themeColors.divider,
              thickness: 1,
              height: 8,
            ),
            _getWonInfo(
              context,
              summary.wishesInfo5,
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
            summary.wishesInfo4,
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
            summary.wishesInfo4Character,
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
            summary.wishesInfo4Weapon,
            '   $_arrow ${context.fromLabel(Labels.weapon)}',
            context.themeColors.getRarityColor(4),
          ),
          _getWishesList(
            style: style,
            summary: summary,
            wishes: wishes,
          ),
        ],
      ),
    );
  }

  Row _summary(
    BuildContext context,
    List<SaveWish> wishes,
    WishesSummary summary,
  ) {
    final show = banner == GsBanner.character;
    final pityColor = context.themeColors.getPityColor(summary.last5);
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
            summary.last5.format(),
            context.fromLabel(Labels.l5sPity),
            valueColor: pityColor,
            wasGuaranteed: guaranteed,
          ),
        ),
        Expanded(
          child: _summaryContainer(
            context,
            summary.last4.format(),
            context.fromLabel(Labels.l4sPity),
            valueColor: context.themeColors.getRarityColor(4),
          ),
        ),
      ],
    );
  }

  Widget _getWishesList({
    required TextStyle style,
    required WishesSummary summary,
    required List<SaveWish> wishes,
  }) {
    if (summary.wishesInfo5.total == 0) return const SizedBox();
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
                  spacing: kSeparator4,
                  runSpacing: kSeparator4,
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: summary.wishes5.reversed.map((wish) {
                    final item = GsUtils.items.getItemData(wish.itemId);
                    final showState = banner == GsBanner.character ||
                        banner == GsBanner.weapon;
                    final state = showState
                        ? GsUtils.wishes.getWishState(wishes, wish)
                        : WishState.none;
                    final pityColor =
                        context.themeColors.getPityColor(wish.pity, maxPity);

                    return Column(
                      children: [
                        ItemRarityBubble(
                          rarity: item.rarity,
                          image: item.image,
                          tooltip: item.name,
                          borderColor: state == WishState.won
                              ? context.themeColors.goodValue
                              : null,
                        ),
                        const SizedBox(height: kSeparator2),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: wish.pity.toString(),
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
      padding: const EdgeInsets.all(kSeparator4 * 2),
      decoration: BoxDecoration(
        color: context.themeColors.mainColor1.withOpacity(0.4),
        borderRadius: kMainRadius,
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
                      size: 20,
                    ),
                  ),
                ),
              TextSpan(
                text: value,
                style: context.textTheme.titleSmall!.copyWith(
                  fontSize: 20,
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
    WishInfo info,
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
    WishInfo info,
    String label,
    Color color,
  ) {
    final total = info.wishes
        .map((e) => MapEntry(e, GsUtils.wishes.getWishState(info.wishes, e)))
        .where((e) => e.value == WishState.won || e.value == WishState.lost);
    final won = total.count((e) => e.value == WishState.won);
    return _getInfo(
      context,
      label,
      color,
      [won, won / total.length * 100, null],
    );
  }
}
