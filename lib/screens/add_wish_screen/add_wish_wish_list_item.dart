import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/gs_icon_button.dart';
import 'package:tracker/domain/gs_database.utils.dart';

class AddWishWishListItem extends StatelessWidget {
  final int roll;
  final ItemData item;
  final VoidCallback? onRemove;

  const AddWishWishListItem({
    super.key,
    required this.item,
    required this.roll,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        borderRadius: kMainRadius,
        color: context.themeColors.getRarityColor(item.rarity),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.name,
              maxLines: 1,
              style:
                  context.textTheme.titleSmall!.copyWith(color: Colors.white),
            ),
          ),
          Text(
            '$roll',
            style: context.textTheme.titleSmall!.copyWith(color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.all(2),
            child: GsIconButton(
              icon: Icons.remove,
              onPress: onRemove,
            ),
          ),
        ],
      ),
    );
  }
}
