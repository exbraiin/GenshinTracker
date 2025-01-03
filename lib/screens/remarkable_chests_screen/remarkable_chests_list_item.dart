import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/widgets/item_info_widget.dart';

class RemarkableChestListItem extends StatelessWidget {
  final bool selected;
  final GsFurnitureChest item;
  final VoidCallback? onTap;

  const RemarkableChestListItem(
    this.item, {
    super.key,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final db = Database.instance;
    final owned = db.saveOf<GiFurnitureChest>().exists(item.id);

    return GsItemCardButton(
      label: item.name,
      rarity: item.rarity,
      disable: !owned,
      onTap: onTap,
      selected: selected,
      banner: GsItemBanner.fromVersion(context, item.version),
      imageUrlPath: item.image,
      child: Stack(
        children: [
          Positioned(
            top: kSeparator2,
            left: kSeparator2,
            child: ItemCircleWidget.setCategory(
              item.type,
              size: ItemSize.small,
            ),
          ),
          if (item.region != GeRegionType.none)
            Positioned(
              right: kSeparator2,
              bottom: kSeparator2,
              child: ItemCircleWidget.region(item.region),
            ),
        ],
      ),
    );
  }
}
