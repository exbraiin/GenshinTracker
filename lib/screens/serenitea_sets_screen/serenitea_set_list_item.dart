import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_spacing.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/widgets/item_info_widget.dart';

class SereniteaSetListItem extends StatelessWidget {
  final bool selected;
  final InfoSereniteaSet item;
  final VoidCallback? onTap;

  const SereniteaSetListItem(
    this.item, {
    super.key,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final saved = GsDatabase.instance.saveSereniteaSets.getItemOrNull(item.id);
    return GsItemCardButton(
      label: item.name,
      rarity: item.rarity,
      selected: selected,
      banner: GsItemBanner.fromVersion(context, item.version),
      imageAspectRatio: 2,
      imageUrlPath: item.image,
      onTap: onTap,
      child: Stack(
        children: [
          Positioned(
            top: kSeparator2,
            left: kSeparator2,
            child: ItemCircleWidget.setCategory(
              item.category,
              size: ItemSize.small,
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
              .sortedBy((element) => element.rarity)
              .thenByDescending((element) => element.name)
              .mapIndexed(
                (i, e) => Positioned(
                  right: kSeparator2 + i * kSeparator8 * 2,
                  bottom: kSeparator2,
                  child: ItemCircleWidget(
                    image: GsUtils.characters.getImage(e.id),
                    rarity: e.rarity,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
