import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/widgets/item_info_widget.dart';

class MaterialListItem extends StatelessWidget {
  final bool selected;
  final GsMaterial item;
  final VoidCallback? onTap;

  const MaterialListItem(
    this.item, {
    super.key,
    this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final region = Database.instance.infoOf<GsRegion>().getItem(item.region.id);
    return GsItemCardButton(
      label: item.name,
      rarity: item.rarity,
      onTap: onTap,
      selected: selected,
      banner: GsItemBanner.fromVersion(context, item.version),
      imageUrlPath: item.image,
      child: Stack(
        children: [
          if (region != null)
            Positioned(
              right: kSeparator2,
              bottom: kSeparator2,
              child: ItemCircleWidget.city(region),
            ),
        ],
      ),
    );
  }
}
