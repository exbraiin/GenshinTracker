import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_detailed_dialog.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/common/widgets/gs_number_field.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/theme/theme.dart';

class MaterialDetailsCard extends StatelessWidget with GsDetailedDialogMixin {
  final InfoMaterial item;

  const MaterialDetailsCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    item.weekdays;
    return ItemDetailsCard.single(
      name: item.name,
      image: item.image,
      rarity: item.rarity,
      banner: GsItemBanner.fromVersion(item.version),
      info: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.fromLabel(item.group.label)),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 180,
              padding: const EdgeInsets.all(kSeparator4),
              decoration: BoxDecoration(
                color: context.themeColors.mainColor2.withOpacity(0.3),
                borderRadius: kMainRadius,
                border: Border.all(
                  color: context.themeColors.mainColor1.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  GsNumberField.fromMaterial(item, fontSize: 14),
                  Text(
                    context.fromLabel(Labels.owned),
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      child: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    final mats = GsDatabase.instance.infoMaterials
        .getSubGroup(item)
        .sortedBy((e) => e.rarity)
        .thenBy((element) => element.id == item.id ? 0 : 1)
        .distinctBy((element) => element.rarity);

    return ItemDetailsCardContent.generate(context, [
      if (item.desc.isNotEmpty) ItemDetailsCardContent(description: item.desc),
      if (item.source.isNotEmpty)
        ItemDetailsCardContent(
          label: context.fromLabel(Labels.source),
          description: item.source,
        ),
      if (item.weekdays.isNotEmpty)
        ItemDetailsCardContent(
          label: context.fromLabel(Labels.weeklyTasks),
          description: item.weekdays.join(', '),
        ),
      if (mats.length > 1)
        ItemDetailsCardContent(
          label: context.fromLabel(Labels.materials),
          content: Wrap(
            spacing: kSeparator4,
            runSpacing: kSeparator4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: mats
                .map(
                  (e) => ItemRarityBubble(
                    image: e.image,
                    rarity: e.rarity,
                    tooltip: e.name,
                  ),
                )
                .toList(),
          ),
        ),
    ]);
  }
}
