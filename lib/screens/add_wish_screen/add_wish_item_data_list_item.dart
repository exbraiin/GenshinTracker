import 'package:flutter/material.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/screens/wishes_screen/wish_utils.dart';

class AddWishItemDataListItem extends StatelessWidget {
  final ItemData item;
  final bool isItemFeatured;
  final VoidCallback onAdd;

  AddWishItemDataListItem({
    required this.item,
    required this.onAdd,
    required this.isItemFeatured,
  });

  @override
  Widget build(BuildContext context) {
    return GsItemCardButton(
      label: item.name,
      rarity: item.rarity,
      banner: isItemFeatured
          ? GsItemBanner(text: 'Featured')
          : GsItemBanner(text: ''),
      imageUrlPath: item.getUrlImg(),
      onTap: onAdd,
    );
  }
}
