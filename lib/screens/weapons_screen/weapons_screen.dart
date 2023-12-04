import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/screen_filters/screen_filter.dart';
import 'package:tracker/screens/weapons_screen/weapon_details_card.dart';
import 'package:tracker/screens/weapons_screen/weapon_list_item.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';

class WeaponsScreen extends StatelessWidget {
  static const id = 'weapons_screen';

  const WeaponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InventoryListPage<InfoWeapon>(
      icon: menuIconWeapons,
      title: context.fromLabel(Labels.weapons),
      filter: ScreenFilters.infoWeaponFilter,
      items: (db) => db.infoWeapons.getItems(),
      itemBuilder: (context, state) => WeaponListItem(
        showItem: !state.filter!.isSectionEmpty('weekdays'),
        showExtra: state.filter!.hasExtra('info'),
        item: state.item,
        selected: state.selected,
        onTap: state.onSelect,
      ),
      itemCardBuilder: (context, item) => WeaponDetailsCard(item),
      actions: (extras, toggle) => [
        Tooltip(
          message: context.fromLabel(Labels.showExtraInfo),
          child: IconButton(
            icon: Icon(
              extras.contains('info')
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
              color: Colors.white.withOpacity(0.5),
            ),
            onPressed: () => toggle('info'),
          ),
        ),
      ],
    );
  }
}
