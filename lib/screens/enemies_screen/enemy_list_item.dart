import 'package:flutter/material.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/domain/gs_domain.dart';

class EnemyListItem extends StatelessWidget {
  final bool selected;
  final InfoEnemy item;
  final VoidCallback? onTap;

  const EnemyListItem(
    this.item, {
    super.key,
    this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GsItemCardButton(
      onTap: onTap,
      label: item.name,
      rarity: item.rarityByType,
      selected: selected,
      banner: GsItemBanner.fromVersion(context, item.version),
      imageUrlPath: item.image,
    );
  }
}