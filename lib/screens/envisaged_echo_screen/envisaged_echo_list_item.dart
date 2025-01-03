import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';
import 'package:tracker/screens/widgets/item_info_widget.dart';

class EnvisagedEchoListItem extends StatelessWidget {
  final bool selected;
  final GsEnvisagedEcho item;
  final VoidCallback? onTap;

  const EnvisagedEchoListItem(
    this.item, {
    super.key,
    this.selected = false,
    this.onTap,
  });

  EnvisagedEchoListItem.fromState(ItemState<GsEnvisagedEcho> state, {super.key})
      : item = state.item,
        selected = state.selected,
        onTap = state.onSelect;

  @override
  Widget build(BuildContext context) {
    final db = Database.instance;
    final owned = GsUtils.echos.hasItem(item.id);
    final char = db.infoOf<GsCharacter>().getItem(item.character);

    return GsItemCardButton(
      label: item.name,
      rarity: item.rarity,
      disable: !owned,
      onTap: onTap,
      selected: selected,
      banner: GsItemBanner.fromVersion(context, item.version),
      imageUrlPath: item.icon,
      child: Stack(
        children: [
          Positioned(
            right: kSeparator2,
            bottom: kSeparator2,
            child: ItemCircleWidget(
              image: char?.image ?? '',
              rarity: char?.rarity ?? 1,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
