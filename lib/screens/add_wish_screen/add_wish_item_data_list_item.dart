import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';

class AddWishItemDataListItem extends StatelessWidget {
  final GsWish item;
  final bool isItemFeatured;
  final VoidCallback onAdd;

  const AddWishItemDataListItem({
    super.key,
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
          ? GsItemBanner(text: context.labels.featured())
          : const GsItemBanner(text: ''),
      imageUrlPath: item.image,
      onTap: onAdd,
    );
  }
}
