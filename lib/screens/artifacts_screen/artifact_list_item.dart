import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/widgets/item_info_widget.dart';

class ArtifactListItem extends StatelessWidget {
  final GsArtifact item;
  final bool selected;
  final VoidCallback? onTap;

  const ArtifactListItem(
    this.item, {
    super.key,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final region = Database.instance.infoOf<GsRegion>().getItem(item.region.id);
    return GsItemCardButton(
      label: item.name,
      rarity: item.rarity,
      selected: selected,
      banner: GsItemBanner.fromVersion(context, item.version),
      imageUrlPath: item.pieces.firstOrNull?.icon,
      onTap: onTap,
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
