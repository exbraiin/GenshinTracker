import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/gs_icon_button.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/theme/theme.dart';

class SpincrystalListItem extends StatelessWidget {
  final InfoSpincrystal item;
  final VoidCallback? onTap;

  const SpincrystalListItem(this.item, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final table = GsDatabase.instance.saveSpincrystals;
    final save = table.getItemOrNull(item.id);
    final owned = save?.obtained ?? false;
    return Opacity(
      opacity: owned ? 1 : kDisableOpacity,
      child: GsItemCardButton(
        label: item.name,
        rarity: item.rarity,
        onTap: onTap,
        banner: GsItemBanner.fromVersion(item.version),
        imageAssetPath: spincrystalAsset,
        child: Stack(
          children: [
            Positioned(
              top: kSeparator2,
              left: kSeparator2,
              child: ItemRarityBubble(
                size: 30,
                color: context.themeColors.mainColor2,
                child: Center(
                  child: Text(item.number.toString()),
                ),
              ),
            ),
            Positioned(
              top: kSeparator2,
              right: kSeparator2,
              child: GsIconButton(
                size: 20,
                color: owned
                    ? context.themeColors.goodValue
                    : context.themeColors.badValue,
                icon: owned ? Icons.check : Icons.close,
                onPress: () => table.updateSpincrystal(
                  item.number,
                  obtained: !owned,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
