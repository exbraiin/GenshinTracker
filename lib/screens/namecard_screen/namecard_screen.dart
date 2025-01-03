import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/screens/namecard_screen/namecard_details_card.dart';
import 'package:tracker/screens/namecard_screen/namecard_list_item.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';

class NamecardScreen extends StatelessWidget {
  static const id = 'namecards_screen';

  const NamecardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InventoryListPage<GsNamecard>(
      icon: GsAssets.menuArchive,
      title: context.labels.namecards(),
      items: (db) => db.infoOf<GsNamecard>().items,
      itemBuilder: (context, state) => NamecardListItem(
        state.item,
        onTap: state.onSelect,
        selected: state.selected,
      ),
      itemCardBuilder: (context, item) => NamecardDetailsCard(
        item,
        key: ValueKey(item.id),
      ),
    );
  }
}
