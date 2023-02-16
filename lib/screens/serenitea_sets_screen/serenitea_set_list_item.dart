import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_assets.dart';
import 'package:tracker/common/graphics/gs_spacing.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/theme/theme.dart';

class SereniteaSetListItem extends StatelessWidget {
  final InfoSereniteaSet item;
  final VoidCallback? onTap;

  const SereniteaSetListItem(this.item, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final saved = GsDatabase.instance.saveSereniteaSets.getItemOrNull(item.id);
    return GsItemCardButton(
      label: item.name,
      rarity: item.rarity,
      banner: GsItemBanner.fromVersion(item.version),
      imageUrlPath: item.image,
      onTap: onTap,
      child: Stack(
        children: [
          Positioned(
            top: kSeparator2,
            left: kSeparator2,
            child: ItemRarityBubble(
              size: 30,
              color: item.category == GsSetCategory.indoor
                  ? context.themeColors.setIndoor
                  : context.themeColors.setOutdoor,
              asset: item.category == GsSetCategory.indoor
                  ? imageIndoorSet
                  : imageOutdoorSet,
            ),
          ),
          ...item.chars
              .map(GsDatabase.instance.infoCharacters.getItemOrNull)
              .whereNotNull()
              .where(
                (e) =>
                    !(saved?.chars.contains(e.id) ?? false) &&
                    GsUtils.characters.hasCaracter(e.id),
              )
              .mapIndexed(
                (i, e) => Positioned(
                  right: kSeparator2 + i * kSeparator8,
                  bottom: kSeparator2,
                  child: ItemRarityBubble(
                    image: e.image,
                    rarity: e.rarity,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

// final owns = GsUtils.characters.hasCaracter(char.id);
// final marked = saved?.chars.contains(char.id) ?? false;