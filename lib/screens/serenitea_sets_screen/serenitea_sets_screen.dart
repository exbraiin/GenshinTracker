import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/screens/serenitea_sets_screen/serenitea_set_details_card.dart';
import 'package:tracker/screens/serenitea_sets_screen/serenitea_set_list_item.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';

class SereniteaSetsScreen extends StatelessWidget {
  static const id = 'serenitea_sets_screen';

  const SereniteaSetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InventoryListPage<GsSereniteaSet>(
      childSize: const Size(126 * 2 + 6, 160),
      icon: GsAssets.menuPot,
      title: context.labels.sereniteaSets(),
      items: (db) => db.infoOf<GsSereniteaSet>().items,
      itemBuilder: (context, state) => SereniteaSetListItem(
        state.item,
        onTap: state.onSelect,
        selected: state.selected,
      ),
      itemCardBuilder: (context, item) => SereniteaSetDetailsCard(
        item,
        key: ValueKey(item.id),
      ),
    );
  }
}
