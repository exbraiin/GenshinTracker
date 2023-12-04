import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_assets.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/materials_screen/material_details_card.dart';
import 'package:tracker/screens/materials_screen/material_list_item.dart';
import 'package:tracker/screens/screen_filters/screen_filter.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';

class MaterialsScreen extends StatelessWidget {
  static const id = 'materials_screen';

  const MaterialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InventoryListPage<InfoMaterial>(
      icon: menuIconMaterials,
      filter: ScreenFilters.infoMaterialFilter,
      title: context.fromLabel(Labels.materials),
      items: (db) => db.infoMaterials.getItems(),
      itemBuilder: (context, state) => MaterialListItem(
        state.item,
        onTap: state.onSelect,
        selected: state.selected,
      ),
      itemCardBuilder: (context, item) => MaterialDetailsCard(item),
    );
  }
}
