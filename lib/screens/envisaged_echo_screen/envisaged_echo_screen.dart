import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/screens/envisaged_echo_screen/envisaged_echo_details_card.dart';
import 'package:tracker/screens/envisaged_echo_screen/envisaged_echo_list_item.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';

class EnvisagedEchoScreen extends StatelessWidget {
  static const id = 'envisaged_echo_screen';

  const EnvisagedEchoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InventoryListPage<GsEnvisagedEcho>(
      icon: GsAssets.menuMap,
      title: context.labels.envisagedEchoes(),
      items: (db) => db.infoOf<GsEnvisagedEcho>().items,
      itemBuilder: (context, state) => EnvisagedEchoListItem(
        state.item,
        selected: state.selected,
        onTap: state.onSelect,
      ),
      itemCardBuilder: (context, item) => EnvisagedEchoDetailsCard(
        item,
        key: ValueKey(item.id),
      ),
    );
  }
}
