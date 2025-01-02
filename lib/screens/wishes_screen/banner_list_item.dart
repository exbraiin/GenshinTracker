import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';

class BannerListItem extends StatelessWidget {
  final GsBanner item;
  final bool selected;
  final bool disabled;
  final VoidCallback? onTap;

  const BannerListItem(
    this.item, {
    super.key,
    this.selected = false,
    this.disabled = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GsItemCardButton(
      onTap: onTap,
      label: item.name,
      selected: selected,
      banner: GsItemBanner.fromVersion(context, item.version),
      disable: disabled,
      imageUrlPath: item.image,
    );
  }
}
