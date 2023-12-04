import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/namecard_screen/namecard_details_card.dart';
import 'package:tracker/screens/namecard_screen/namecard_list_item.dart';
import 'package:tracker/screens/screen_filters/screen_filter.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';

class NamecardScreen extends StatelessWidget {
  static const id = 'namecards_screen';

  const NamecardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InventoryListPage<InfoNamecard>(
      icon: menuIconArchive,
      title: context.fromLabel(Labels.namecards),
      filter: ScreenFilters.infoNamecardFilter,
      items: (db) => db.infoNamecards.getItems(),
      itemBuilder: (context, state) => NamecardListItem(
        state.item,
        onTap: state.onSelect,
        selected: state.selected,
      ),
      itemCardBuilder: (context, item) => NamecardDetailsCard(item),
    );
  }
}
