import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/reputation_screen/reputation_list_item.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';

class ReputationScreen extends StatelessWidget {
  static const id = 'reputation_screen';

  const ReputationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InventoryListPage<InfoCity>(
      childSize: const Size(350, 110),
      icon: menuIconReputation,
      title: context.fromLabel(Labels.reputation),
      items: (db) => db.infoCities.getItems(),
      itemBuilder: (context, state) => ReputationListItem(state.item),
    );
  }
}
