import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

class AchievementGroupListItem extends StatelessWidget {
  final InfoAchievementGroup item;
  final VoidCallback? onTap;

  const AchievementGroupListItem(
    this.item, {
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final utils = GsUtils.saveAchievements;
    final saved = utils.countSaved((e) => e.group == item.id);
    final total = utils.countTotal((e) => e.group == item.id);
    final percentage = saved / total.coerceAtLeast(1);

    return GsItemCardButton(
      onTap: onTap,
      label: item.name,
      banner: GsItemBanner.fromVersion(item.version),
      imageUrlPath: item.icon,
      child: Stack(
        children: [
          Positioned(
            top: kSeparator2,
            left: kSeparator2,
            child: ItemRarityBubble(
              size: 30,
              color: context.themeColors.mainColor2,
              child: Center(
                child: Text(item.achievements.format()),
              ),
            ),
          ),
          Positioned(
            top: kSeparator2,
            right: kSeparator2,
            child: GsItemCardLabel(
              asset: imagePrimogem,
              label: item.rewards.format(),
            ),
          ),
          Positioned(
            left: kSeparator8 * 2,
            right: kSeparator8 * 2,
            bottom: kSeparator4,
            child: Column(
              children: [
                GsItemCardLabel(
                  label: '${(percentage * 100).toInt()}%',
                ),
                Container(
                  height: 4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF626d83),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: percentage,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFd8c090),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
