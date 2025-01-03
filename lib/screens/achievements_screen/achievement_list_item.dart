import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/domain/enums/enum_ext.dart';
import 'package:tracker/domain/gs_database.dart';

class AchievementListItem extends StatelessWidget {
  final GsAchievement item;

  const AchievementListItem(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final db = Database.instance.saveOf<GiAchievement>();
    final obtained = db.getItem(item.id)?.obtained ?? 0;

    return GsDataBox.info(
      title: Row(
        children: [
          Text(item.name),
          const SizedBox(width: kSeparator8),
          const Spacer(),
          if (item.hidden) ...[
            GsItemCardLabel.chip(label: context.labels.achHidden()),
            const SizedBox(width: kSeparator4),
          ],
          if (item.type != GeAchievementType.none) ...[
            GsItemCardLabel.chip(label: item.type.label(context)),
            const SizedBox(width: kSeparator4),
          ],
          GsItemCardLabel.chip(label: item.version),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: kSeparator4),
          ...item.phases.mapIndexed<Widget>((idx, e) {
            return InkWell(
              onTap: () =>
                  GsUtils.achievements.update(item.id, obtained: idx + 1),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  kSeparator4,
                  kSeparator4,
                  0,
                  kSeparator4,
                ),
                child: Row(
                  children: [
                    Icon(
                      obtained > idx
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_off_rounded,
                      color: context.themeColors.almostWhite,
                    ),
                    const SizedBox(width: kSeparator8),
                    Expanded(
                      child: Text(
                        e.desc,
                        strutStyle: const StrutStyle(height: 1.185),
                      ),
                    ),
                    GsItemCardLabel(
                      label: e.reward.format(),
                      asset: GsAssets.imagePrimogem,
                    ),
                  ],
                ),
              ),
            );
          }).separate(
            Divider(
              height: kSeparator4,
              color: context.themeColors.divider,
            ),
          ),
        ],
      ),
    );
  }
}
