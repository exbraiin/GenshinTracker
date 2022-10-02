import 'package:flutter/material.dart';
import 'package:tracker/common/widgets/item_card_button.dart';
import 'package:tracker/screens/wishes_screen/wish_utils.dart';

class AddWishItemDataListItem extends StatelessWidget {
  final ItemData item;
  final VoidCallback onAdd;

  AddWishItemDataListItem({
    required this.item,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return ItemCardButton(
      label: item.name,
      rarity: item.rarity,
      imageUrlPath: item.getUrlImg(),
      onTap: onAdd,
    );
  }
}
