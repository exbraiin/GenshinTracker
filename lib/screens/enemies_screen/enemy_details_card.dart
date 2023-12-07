import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_detailed_dialog.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/widgets/item_info_widget.dart';

class EnemyDetailsCard extends StatelessWidget with GsDetailedDialogMixin {
  final InfoEnemy item;

  EnemyDetailsCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final db = GsDatabase.instance;
    return ItemDetailsCard.single(
      name: item.name,
      info: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.fromLabel(item.family.label),
            style: context.themeStyles.title18n,
          ),
          const SizedBox(height: kListSeparator),
          Text(
            item.title,
            style: context.themeStyles.label14n,
          ),
        ],
      ),
      image: item.splashImage.isNotEmpty ? item.splashImage : item.fullImage,
      rarity: item.rarityByType,
      banner: GsItemBanner.fromVersion(context, item.version),
      child: ItemDetailsCardContent.generate(context, [
        if (item.drops.isNotEmpty)
          ItemDetailsCardContent(
            label: context.fromLabel(Labels.materials),
            content: Wrap(
              spacing: kSeparator4,
              runSpacing: kSeparator4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: item.drops.map((e) {
                final item = db.infoMaterials.getItemOrNull(e);
                if (item == null) return const SizedBox();
                return ItemGridWidget.material(item);
              }).toList(),
            ),
          ),
      ]),
    );
  }
}
