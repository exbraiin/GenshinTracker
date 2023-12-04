import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/enemies_screen/enemy_list_item.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';

class EnemyScreen extends StatelessWidget {
  static const id = 'enemies_screen';

  const EnemyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InventoryListPage<InfoEnemy>(
      icon: menuIconEnemies,
      title: context.fromLabel(Labels.enemies),
      items: (db) => db.infoEnemies.getItems(),
      itemBuilder: (context, state) => EnemyListItem(
        state.item,
        // onTap: state.onSelect,
        // selected: state.selected,
      ),
    );
  }
}
