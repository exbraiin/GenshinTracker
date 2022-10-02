import 'package:dartx/dartx_io.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/common/widgets/wish_state_icon.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/wishes_screen/wish_utils.dart';

class HomeWishesValues extends StatelessWidget {
  final String title;
  final GsBanner banner;

  HomeWishesValues({
    required this.title,
    required this.banner,
  });

  @override
  Widget build(BuildContext context) {
    final st = Theme.of(context).textTheme.subtitle2!;
    final style = st.copyWith(color: GsColors.almostWhite);

    final sw = GsDatabase.instance.saveWishes;
    final wishes = sw.getSaveWishesByBannerType(banner).sortedDescending();
    final summary = WishesSummary.fromList(wishes);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(kSeparator4 * 2),
      decoration: BoxDecoration(
        color: GsColors.mainColor2,
        borderRadius: kMainRadius,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: style,
                ),
              ),
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
          Divider(color: GsColors.almostWhite, thickness: 1, height: 8),
          _getInfo(
            context,
            summary.wishesInfo5,
            context.fromLabel(Labels.rarityStar, 5),
            GsColors.getRarityColor(5),
          ),
          if (banner == GsBanner.standard) ...[
            Divider(color: GsColors.almostWhite, thickness: 1, height: 8),
            _getInfo(
              context,
              summary.wishesInfo5Character,
              '   > ' + context.fromLabel(Labels.character),
              GsColors.getRarityColor(5),
            ),
            Divider(color: GsColors.almostWhite, thickness: 1, height: 8),
            _getInfo(
              context,
              summary.wishesInfo5Weapon,
              '   > ' + context.fromLabel(Labels.weapon),
              GsColors.getRarityColor(5),
            ),
          ],
          Divider(color: GsColors.almostWhite, thickness: 1, height: 8),
          _getInfo(
            context,
            summary.wishesInfo4,
            context.fromLabel(Labels.rarityStar, 4),
            GsColors.getRarityColor(4),
          ),
          Divider(color: GsColors.almostWhite, thickness: 1, height: 8),
          _getInfo(
            context,
            summary.wishesInfo4Character,
            '   > ' + context.fromLabel(Labels.character),
            GsColors.getRarityColor(4),
          ),
          Divider(color: GsColors.almostWhite, thickness: 1, height: 8),
          _getInfo(
            context,
            summary.wishesInfo4Weapon,
            '   > ' + context.fromLabel(Labels.weapon),
            GsColors.getRarityColor(4),
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

  Widget _getWishesList({
    required TextStyle style,
    required WishesSummary summary,
    required List<SaveWish> wishes,
  }) {
    if (summary.wishesInfo5.total == 0) return SizedBox();
    var expanded = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            SizedBox(
              child: Center(
                child: IconButton(
                  onPressed: () => setState(() => expanded = !expanded),
                  padding: EdgeInsets.all(kSeparator4),
                  constraints: BoxConstraints.tightFor(),
                  icon: AnimatedRotation(
                    turns: expanded ? 0.5 : 1,
                    duration: Duration(milliseconds: 400),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              curve: Curves.easeOut,
              duration: Duration(milliseconds: 400),
              constraints: BoxConstraints(maxHeight: expanded ? 300 : 0),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: kSeparator4),
                child: Wrap(
                  spacing: kSeparator4,
                  runSpacing: kSeparator4,
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: summary.wishes5.reversed.map((wish) {
                    final item = getItemData(wish.itemId);
                    final pity = getPity(wishes, wish);
                    final showGuaranteed = banner == GsBanner.character;
                    final guaranteed = showGuaranteed &&
                        item.rarity == 5 &&
                        getGuaranteed(wishes, wish);

                    return Container(
                      padding: EdgeInsets.symmetric(
                        vertical: kSeparator4,
                        horizontal: kSeparator4 * 2,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: GsColors.dimWhite),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: item.name, style: style),
                            WidgetSpan(child: SizedBox(width: kSeparator4)),
                            TextSpan(
                              text: pity.toString(),
                              style: style.copyWith(color: GsColors.getPityColor(pity)),
                            ),
                            if (guaranteed)
                              WidgetSpan(
                                child: WishStateIcon(WishState.guaranteed),
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

  Widget _getInfo(
    BuildContext context,
    WishInfo info,
    String label,
    Color color,
  ) {
    final st = Theme.of(context).textTheme.subtitle2!;
    final style = st.copyWith(color: GsColors.almostWhite);
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
            ),
          ),
        ),
      ],
    );
  }
}
