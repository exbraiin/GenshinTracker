import 'package:flutter/material.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/domain/gs_database.utils.dart';

class AddWishItemDataListItem extends StatelessWidget {
  final ItemData item;
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
          ? const GsItemBanner(text: 'Featured')
          : const GsItemBanner(text: ''),
      imageUrlPath: item.getUrlImg(),
      onTap: onAdd,
    );
  }
}
