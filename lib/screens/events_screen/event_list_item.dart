import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';

class EventListItem extends StatelessWidget {
  final bool selected;
  final GsEvent item;
  final VoidCallback? onTap;

  const EventListItem(
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
      selected: selected,
      banner: GsItemBanner.fromVersion(context, item.version),
      imageUrlPath: item.image,
    );
  }
}
