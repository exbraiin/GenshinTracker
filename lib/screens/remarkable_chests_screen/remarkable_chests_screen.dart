import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_assets.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/remarkable_chests_screen/remarkable_chest_details_card.dart';
import 'package:tracker/screens/remarkable_chests_screen/remarkable_chests_list_item.dart';
import 'package:tracker/screens/screen_filters/screen_filter.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';

class RemarkableChestsScreen extends StatelessWidget {
  static const id = 'remarkable_chests_screen';

  const RemarkableChestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InventoryListPage<InfoRemarkableChest>(
      icon: menuIconRecipes,
      title: context.fromLabel(Labels.remarkableChests),
      filter: ScreenFilters.infoRemarkableChestFilter,
      items: (db) => db.infoRemarkableChests.getItems(),
      itemBuilder: (context, state) => RemarkableChestListItem(
        state.item,
        selected: state.selected,
        onTap: state.onSelect,
      ),
      itemCardBuilder: (context, item) => RemarkableChestDetailsCard(
        item,
        key: ValueKey(item.id),
      ),
    );
  }
}
