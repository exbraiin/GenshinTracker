import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

class ArtifactListItem extends StatelessWidget {
  final InfoArtifact item;
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
    final region = GsDatabase.instance.infoCities.getItemOrNull(item.region.id);
    return GsItemCardButton(
      label: item.name,
      rarity: item.rarity,
      selected: selected,
      banner: GsItemBanner.fromVersion(item.version),
      imageUrlPath: item.image,
      onTap: onTap,
      child: Stack(
        children: [
          if (region != null)
            Positioned(
              right: kSeparator2,
              bottom: kSeparator2,
              child: ItemRarityBubble(
                color: region.element.color,
                image: region.image,
              ),
            ),
        ],
      ),
    );
  }
}
