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
import 'package:tracker/screens/screen_filters/screen_filter_builder.dart';
import 'package:tracker/screens/weapons_screen/weapon_list_item.dart';

class WeaponsScreen extends StatelessWidget {
  static const id = 'weapons_screen';

  const WeaponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder<bool>(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        if (snapshot.data != true) return const SizedBox();

        return ScreenFilterBuilder<InfoWeapon>(
          filter: ScreenFilters.infoWeaponFilter,
          builder: (context, filter, button, toggle) {
            final items = GsDatabase.instance.infoWeapons.getItems();
            final weapons = filter.match(items);

            final child = weapons.isEmpty
                ? const GsNoResultsState()
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
                      onPressed: () => toggle('info'),
                    ),
                  ),
                  const SizedBox(width: kSeparator2),
                  button,
                ],
              ),
              body: Container(
                decoration: kMainBgDecoration,
                child: child,
              ),
            );
          },
        );
      },
    );
  }
}
