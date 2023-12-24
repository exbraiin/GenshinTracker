import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/screens/version_screen/version_details_card.dart';
import 'package:tracker/screens/version_screen/version_list_item.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';

class VersionScreen extends StatelessWidget {
  static const id = 'version_screen';

  const VersionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InventoryListPage<GsVersion>(
      childSize: const Size(126 * 2 + 6, 160),
      icon: menuIconBook,
      sortOrder: SortOrder.descending,
      title: context.fromLabel(Labels.version),
      items: (db) => db.infoOf<GsVersion>().items,
      itemBuilder: (context, state) => VersionListItem(
        state.item,
        onTap: state.onSelect,
        selected: state.selected,
      ),
      itemCardBuilder: (context, item) => VersionDetailsCard(
        item,
        key: ValueKey(item.id),
      ),
    );
  }
}
