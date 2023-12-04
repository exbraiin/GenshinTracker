import 'package:flutter/widgets.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/domain/gs_domain.dart';

class VersionListItem extends StatelessWidget {
  final bool selected;
  final InfoVersion item;
  final VoidCallback? onTap;

  const VersionListItem(
    this.item, {
    super.key,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GsItemCardButton(
      label: item.id,
      imageUrlPath: item.image,
      selected: selected,
      banner: GsItemBanner.fromVersion(context, item.id),
      onTap: onTap,
    );
  }
}
