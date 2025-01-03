import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/widgets/item_info_widget.dart';

class SpincrystalListItem extends StatelessWidget {
  final bool selected;
  final GsSpincrystal item;
  final VoidCallback? onTap;

  const SpincrystalListItem(
    this.item, {
    super.key,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final table = Database.instance.saveOf<GiSpincrystal>();
    final save = table.getItem(item.id);
    final owned = save?.obtained ?? false;
    return GsItemCardButton(
      label: item.name,
      rarity: 4,
      onTap: onTap,
      disable: !owned,
      selected: selected,
      banner: GsItemBanner.fromVersion(context, item.version),
      imageAssetPath: GsAssets.spincrystal,
      child: Stack(
        children: [
          Positioned(
            top: kSeparator2,
            left: kSeparator2,
            child: ItemCircleWidget(
              size: ItemSize.small,
              child: Center(child: Text(item.number.toString())),
            ),
          ),
          if (item.region != GeRegionType.none)
            Positioned(
              right: kSeparator2,
              bottom: kSeparator2,
              child: ItemCircleWidget.region(item.region),
            ),
        ],
      ),
    );
  }
}
