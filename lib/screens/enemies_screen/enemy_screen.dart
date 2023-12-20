import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/screens/enemies_screen/enemy_details_card.dart';
import 'package:tracker/screens/enemies_screen/enemy_list_item.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';

class EnemyScreen extends StatelessWidget {
  static const id = 'enemies_screen';

  const EnemyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InventoryListPage<GsEnemy>(
      icon: menuIconEnemies,
      title: context.fromLabel(Labels.enemies),
      items: (db) => db.infoOf<GsEnemy>().items,
      itemBuilder: (context, state) => EnemyListItem(
        state.item,
        onTap: state.onSelect,
        selected: state.selected,
      ),
      itemCardBuilder: (context, item) => EnemyDetailsCard(
        item,
        key: ValueKey(item.id),
      ),
    );
  }
}
