import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

class AchievementListItem extends StatelessWidget {
  final InfoAchievement item;

  const AchievementListItem(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final db = GsDatabase.instance.saveAchievements;
    final obtained = db.getItemOrNull(item.id)?.obtained ?? 0;

    return GsDataBox.info(
      title: Row(
        children: [
          Text(item.name),
          const SizedBox(width: kSeparator8),
          GsItemCardLabel(label: item.version),
          if (item.type != GsAchievementType.none) ...[
            const SizedBox(width: kSeparator4),
            GsItemCardLabel(label: context.fromLabel(item.type.label)),
          ],
          if (item.hidden) ...[
            const SizedBox(width: kSeparator4),
            GsItemCardLabel(label: context.fromLabel(Labels.achHidden)),
          ],
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: kSeparator8 * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: kSeparator4),
            ...item.phases.mapIndexed<Widget>((idx, e) {
              return InkWell(
                onTap: () =>
                    GsUtils.saveAchievements.update(item.id, obtained: idx + 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: kSeparator4),
                  child: Row(
                    children: [
                      Expanded(child: Text(e.desc)),
                      GsItemCardLabel(
                        label: e.reward.format(),
                        asset: imagePrimogem,
                      ),
                      const SizedBox(width: kSeparator8),
                      Icon(
                        obtained > idx
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_off_rounded,
                        color: context.themeColors.almostWhite,
                      ),
                    ],
                  ),
                ),
              );
            }).separate(
              Divider(
                height: kSeparator4,
                color: context.themeColors.mainColor2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
