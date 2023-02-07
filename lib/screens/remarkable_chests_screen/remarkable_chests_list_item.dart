import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/gs_icon_button.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

class RemarkableChestListItem extends StatelessWidget {
  final InfoRemarkableChest item;
  final VoidCallback? onTap;

  String get _setImage => item.type == GsSetCategory.indoor
      ? imageIndoorSet
      : item.type == GsSetCategory.outdoor
          ? imageOutdoorSet
          : '';

  const RemarkableChestListItem(this.item, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final db = GsDatabase.instance;
    final owned = db.saveRemarkableChests.exists(item.id);

    return GsItemCardButton(
      label: item.name,
      rarity: item.rarity,
      disable: !owned,
      onTap: onTap,
      banner: GsItemBanner.fromVersion(item.version),
      imageUrlPath: item.image,
      child: Stack(
        children: [
          Positioned(
            top: kSeparator2,
            left: kSeparator2,
            child: ItemRarityBubble(
              size: 30,
              asset: _setImage,
              color: item.type == GsSetCategory.indoor
                  ? GsColors.setIndoor
                  : item.type == GsSetCategory.outdoor
                      ? GsColors.setOutdoor
                      : GsColors.mainColor1,
            ),
          ),
          Positioned(
            top: kSeparator2,
            right: kSeparator2,
            child: GsIconButton(
              size: 20,
              color: owned ? Colors.green : GsColors.missing,
              icon: owned ? Icons.check : Icons.close,
              onPress: () => db.saveRemarkableChests
                  .updateRemarkableChest(item.id, obtained: !owned),
            ),
          ),
        ],
      ),
    );
  }
}
