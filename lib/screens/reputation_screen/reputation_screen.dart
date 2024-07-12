import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/screens/reputation_screen/reputation_details_card.dart';
import 'package:tracker/screens/reputation_screen/reputation_list_item.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';

class ReputationScreen extends StatelessWidget {
  static const id = 'reputation_screen';

  const ReputationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InventoryListPage<GsRegion>(
      icon: menuIconReputation,
      title: context.fromLabel(Labels.reputation),
      items: (db) => db.infoOf<GsRegion>().items,
      itemBuilder: (context, state) => ReputationListItem(
        state.item,
        selected: state.selected,
        onTap: state.onSelect,
      ),
      itemCardBuilder: (context, item) => ReputationDetailsCard(item: item),
    );
  }
}
