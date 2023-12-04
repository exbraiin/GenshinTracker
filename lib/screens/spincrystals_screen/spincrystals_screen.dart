import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_assets.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/screen_filters/screen_filter.dart';
import 'package:tracker/screens/spincrystals_screen/spincrystal_details_card.dart';
import 'package:tracker/screens/spincrystals_screen/spincrystal_list_item.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';

class SpincrystalsScreen extends StatelessWidget {
  static const id = 'spincrystal_screen';

  const SpincrystalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InventoryListPage<InfoSpincrystal>(
      icon: menuIconInventory,
      title: context.fromLabel(Labels.spincrystals),
      filter: ScreenFilters.infoSpincrystalFilter,
      items: (db) => db.infoSpincrystal.getItems(),
      itemBuilder: (context, state) {
        return SpincrystalListItem(
          state.item,
          onTap: state.onSelect,
          selected: state.selected,
        );
      },
      itemCardBuilder: (context, item) => SpincrystalDetailsCard(item),
    );
  }
}
