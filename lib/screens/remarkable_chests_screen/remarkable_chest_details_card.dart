import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_detailed_dialog.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/domain/gs_domain.dart';

class RemarkableChestDetailsCard extends StatelessWidget
    with GsDetailedDialogMixin {
  final InfoRemarkableChest item;

  const RemarkableChestDetailsCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return ItemDetailsCard.single(
      name: item.name,
      image: item.image,
      rarity: item.rarity,
      banner: GsItemBanner.fromVersion(item.version),
      info: Align(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  item.type == GsSetCategory.indoor
                      ? imageIndoorSet
                      : imageOutdoorSet,
                  width: 32,
                  height: 32,
                ),
                const SizedBox(width: kSeparator4),
                Text(context.fromLabel(item.type.label)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: kSeparator8),
              child: Text(
                item.category,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
      child: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return ItemDetailsCardContent.generate(context, [
      ItemDetailsCardContent(
        label: context.fromLabel(item.type.label),
        description: context.fromLabel(Labels.energyN, item.energy.format()),
      ),
      if (item.source.isNotEmpty)
        ItemDetailsCardContent(
          label: context.fromLabel(Labels.source),
          description: item.source,
        ),
    ]);
  }
}
