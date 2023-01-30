import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

class HomeWishesSummary extends StatelessWidget {
  final String title;
  final GsBanner banner;

  final int minPity;
  final int maxPity;

  HomeWishesSummary({
    required this.title,
    required this.banner,
    this.minPity = 75,
    this.maxPity = 90,
  });

  @override
  Widget build(BuildContext context) {
    final st = Theme.of(context).textTheme.subtitle2!;
    final style = st.copyWith(color: GsColors.almostWhite);
    final subStyle = st.copyWith(
      fontSize: 14,
      color: GsColors.dimWhite,
    );
    final bigNumberStyle = style.copyWith(fontSize: 24);

    final sw = GsDatabase.instance.saveWishes;
    final wishes = sw.getSaveWishesByBannerType(banner).sortedDescending();
    final summary = WishesSummary.fromList(wishes);
    final showGuaranteed = banner == GsBanner.character;
    final garanteed = showGuaranteed && GsUtils.wishes.isNextGaranteed(wishes);

    final pityColor = GsColors.getPityColor(summary.last5, maxPity);

    return GsDataBox.summary(
      title: title,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(kSeparator4 * 2),
            decoration: BoxDecoration(
              color: GsColors.mainColor1,
              borderRadius: kMainRadius,
            ),
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    style: style,
                    children: [
                      TextSpan(
                        text: Lang.of(context).getValue(Labels.lifetimePulls) +
                            '\n',
                        style: style.copyWith(fontSize: 18),
                      ),
                      WidgetSpan(child: SizedBox(height: 18)),
                      WidgetSpan(child: primoWidget(16, 1)),
                      TextSpan(
                        text: (wishes.length * 160).format(),
                        style: subStyle,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Text('${wishes.length}', style: bigNumberStyle),
              ],
            ),
          ),
          SizedBox(height: kSeparator4),
          Container(
            padding: EdgeInsets.all(kSeparator4 * 2),
            decoration: BoxDecoration(
              color: GsColors.mainColor1,
              borderRadius: kMainRadius,
            ),
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    style: style,
                    children: [
                      TextSpan(
                        text: Lang.of(context).getValue(Labels.l5sPity) + '\n',
                        style: style.copyWith(fontSize: 18),
                      ),
                      WidgetSpan(child: SizedBox(height: 18)),
                      TextSpan(
                        text: 'Guaranteed at $maxPity',
                        style: subStyle,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                if (garanteed)
                  Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Icon(
                      Icons.arrow_circle_up_rounded,
                      color: pityColor,
                    ),
                  ),
                Text(
                  '${summary.last5}',
                  style: bigNumberStyle.copyWith(color: pityColor),
                ),
              ],
            ),
          ),
          SizedBox(height: kSeparator4),
          Container(
            padding: EdgeInsets.all(kSeparator4 * 2),
            decoration: BoxDecoration(
              color: GsColors.mainColor1,
              borderRadius: kMainRadius,
            ),
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    style: style,
                    children: [
                      TextSpan(
                        text: Lang.of(context).getValue(Labels.l4sPity) + '\n',
                        style: style.copyWith(fontSize: 18),
                      ),
                      WidgetSpan(child: SizedBox(height: 18)),
                      TextSpan(
                        text: 'Guaranteed at ${10}',
                        style: subStyle,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Text(
                  '${summary.last4}',
                  style: bigNumberStyle.copyWith(
                      color: GsColors.getRarityColor(4)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
