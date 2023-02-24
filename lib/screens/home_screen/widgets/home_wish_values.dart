import 'package:dartx/dartx_io.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/gs_wish_state_icon.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/theme/theme.dart';

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

    final sw = GsDatabase.instance.saveWishes;
    final wishes = sw.getSaveWishesByBannerType(banner).sortedDescending();
    final summary = WishesSummary.fromList(wishes);

    return GsDataBox.summary(
      title: context.fromLabel(_bannerTitleLabel[banner]!),
      child: Column(
        children: [
          _summary(context, wishes, summary),
          Row(
            children: [
              const Spacer(flex: 3),
              Expanded(
                child: Center(
                  child: Text(
                    Lang.of(context).getValue(Labels.total),
                    style: style,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    Lang.of(context).getValue(Labels.per),
                    style: style,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    Lang.of(context).getValue(Labels.pity),
                    style: style,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: context.themeColors.almostWhite,
            thickness: 1,
            height: 8,
          ),
          _getInfo(
            context,
            summary.wishesInfo5,
            context.fromLabel(Labels.rarityStar, 5),
            context.themeColors.getRarityColor(5),
          ),
          if (banner == GsBanner.standard) ...[
            Divider(
              color: context.themeColors.almostWhite,
              thickness: 1,
              height: 8,
            ),
            _getInfo(
              context,
              summary.wishesInfo5Character,
              '   > ${context.fromLabel(Labels.character)}',
              context.themeColors.getRarityColor(5),
            ),
            Divider(
              color: context.themeColors.almostWhite,
              thickness: 1,
              height: 8,
            ),
            _getInfo(
              context,
              summary.wishesInfo5Weapon,
              '   > ${context.fromLabel(Labels.weapon)}',
              context.themeColors.getRarityColor(5),
            ),
          ],
          Divider(
            color: context.themeColors.almostWhite,
            thickness: 1,
            height: 8,
          ),
          _getInfo(
            context,
            summary.wishesInfo4,
            context.fromLabel(Labels.rarityStar, 4),
            context.themeColors.getRarityColor(4),
          ),
          Divider(
            color: context.themeColors.almostWhite,
            thickness: 1,
            height: 8,
          ),
          _getInfo(
            context,
            summary.wishesInfo4Character,
            '   > ${context.fromLabel(Labels.character)}',
            context.themeColors.getRarityColor(4),
          ),
          Divider(
            color: context.themeColors.almostWhite,
            thickness: 1,
            height: 8,
          ),
          _getInfo(
            context,
            summary.wishesInfo4Weapon,
            '   > ${context.fromLabel(Labels.weapon)}',
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
                    final pity = GsUtils.wishes.countPity(wishes, wish);
                    final showState = banner == GsBanner.character;
                    final state = showState
                        ? GsUtils.wishes.getWishState(wishes, wish)
                        : WishState.none;

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: kSeparator4,
                        horizontal: kSeparator4 * 2,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: state == WishState.won ? 2 : 1,
                          color: state == WishState.won
                              ? context.themeColors.primary
                              : context.themeColors.dimWhite,
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: item.name, style: style),
                            const WidgetSpan(
                              child: SizedBox(width: kSeparator4),
                            ),
                            TextSpan(
                              text: pity.toString(),
                              style: style.copyWith(
                                color: context.themeColors.getPityColor(pity),
                              ),
                            ),
                            if (state == WishState.guaranteed)
                              const WidgetSpan(
                                child: GsWishStateIcon(WishState.guaranteed),
                              ),
                          ],
                        ),
                      ),
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
        color: context.themeColors.mainColor1,
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
                  color: valueColor ?? context.themeColors.almostWhite,
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
    WishInfo info,
    String label,
    Color color,
  ) {
    final st = Theme.of(context).textTheme.titleSmall!;
    final style = st.copyWith(color: context.themeColors.almostWhite);
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
              info.wishes.length.toString(),
              style: style.copyWith(color: color),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              '${info.percentage.toStringAsFixed(1)}%',
              style: style.copyWith(color: color),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              info.average.toStringAsFixed(1),
              style: style.copyWith(color: color),
              textAlign: TextAlign.end,
            ),
          ),
        ),
      ],
    );
  }
}
