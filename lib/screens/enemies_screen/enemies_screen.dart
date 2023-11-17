import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/gs_grid_view.dart';
import 'package:tracker/common/widgets/gs_no_results_state.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/enemies_screen/enemy_list_item.dart';
import 'package:tracker/screens/screen_filters/screen_filter.dart';
import 'package:tracker/screens/screen_filters/screen_filter_builder.dart';

class EnemiesScreen extends StatelessWidget {
  static const id = 'enemies_screen';

  const EnemiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenFilterBuilder<InfoEnemy>(
      filter: ScreenFilters.infoEnemies,
      builder: (context, filter, button, toggle) {
        return ValueStreamBuilder<bool>(
          stream: GsDatabase.instance.loaded,
          builder: (context, snapshot) {
            final items = GsDatabase.instance.infoEnemies.getItems();
            final enemies = filter.match(items);
            final child = enemies.isEmpty
                ? const GsNoResultsState()
                : GsGridView.builder(
                    itemCount: enemies.length,
                    itemBuilder: (context, index) {
                      final item = enemies[index];
                      return EnemyListItem(item);
                    },
                  );
            return Scaffold(
              appBar: GsAppBar(
                label: context.fromLabel(Labels.enemies),
                actions: [button],
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
