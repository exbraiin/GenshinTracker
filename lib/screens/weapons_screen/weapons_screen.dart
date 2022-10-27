import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/gs_grid_view.dart';
import 'package:tracker/common/widgets/gs_no_results_state.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/screen_filters/screen_filter.dart';
import 'package:tracker/screens/screen_filters/screen_filter_drawer.dart';
import 'package:tracker/screens/weapons_screen/weapon_list_item.dart';

class WeaponsScreen extends StatelessWidget {
  static const id = 'weapons_screen';
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder<bool>(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        if (snapshot.data != true) return SizedBox();

        return ScreenDrawerBuilder<InfoWeapon>(
          filter: () => ScreenFilters.infoWeaponFilter,
          builder: (context, filter, drawer) {
            final items = GsDatabase.instance.infoWeapons.getItems();
            final weapons = filter.match(items);

            final child = weapons.isEmpty
                ? GsNoResultsState()
                : GsGridView.builder(
                    itemCount: weapons.length,
                    itemBuilder: (context, index) {
                      final item = weapons[index];
                      return WeaponListItem(
                        showExtra: filter.hasExtra('info'),
                        weapon: item,
                      );
                    },
                  );

            return Scaffold(
              key: _key,
              appBar: GsAppBar(
                label: Lang.of(context).getValue(Labels.weapons),
                actions: [
                  Tooltip(
                    message: Lang.of(context).getValue(Labels.showExtraInfo),
                    child: IconButton(
                      icon: Icon(
                        filter.hasExtra('info')
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      onPressed: () {
                        filter.toggleExtra('info');
                        drawer.onNotify();
                      },
                    ),
                  ),
                  SizedBox(width: kSeparator2),
                  IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () => _key.currentState?.openEndDrawer(),
                  ),
                ],
              ),
              body: child,
              endDrawer: drawer,
              endDrawerEnableOpenDragGesture: false,
            );
          },
        );
      },
    );
  }
}
