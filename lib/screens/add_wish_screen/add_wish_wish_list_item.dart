import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/gs_icon_button.dart';

class AddWishWishListItem extends StatelessWidget {
  final int roll;
  final GsWish item;
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
        borderRadius: kListRadius,
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
            padding: const EdgeInsets.all(2).copyWith(left: 4),
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
