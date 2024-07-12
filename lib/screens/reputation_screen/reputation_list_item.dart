import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/domain/enums/enum_ext.dart';

class ReputationListItem extends StatelessWidget {
  final bool selected;
  final GsRegion item;
  final VoidCallback? onTap;

  const ReputationListItem(
    this.item, {
    super.key,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GsItemCardButton(
      rarity: 1,
      label: item.name,
      imageColor: item.element.color,
      imageUrlPath: item.image,
      selected: selected,
      onTap: onTap,
    );
  }
}
