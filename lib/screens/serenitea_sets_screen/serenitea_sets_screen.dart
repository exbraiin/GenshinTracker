import 'package:flutter/material.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/gs_grid_view.dart';
import 'package:tracker/common/widgets/gs_no_results_state.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/screen_filters/screen_filter.dart';
import 'package:tracker/screens/screen_filters/screen_filter_drawer.dart';
import 'package:tracker/screens/serenitea_sets_screen/serenitea_set_list_item.dart';

class SereniteaSetsScreen extends StatelessWidget {
  static const id = 'serenitea_sets_screen';

  const SereniteaSetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder<bool>(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        if (snapshot.data != true) return const SizedBox();
        return ScreenDrawerBuilder<InfoSereniteaSet>(
          filter: () => ScreenFilters.infoSereniteaSetFilter,
          builder: (context, filter, drawer) {
            final setsList = GsDatabase.instance.infoSereniteaSets.getItems();
            final filtered = filter.match(setsList);

            final child = filtered.isEmpty
                ? const GsNoResultsState()
                : GsGridView.builder(
                    childWidth: 400,
                    childHeight: 200,
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return SereniteaSetListItem(
                        item,
                        GsDatabase.instance.saveSereniteaSets
                            .getItemOrNull(item.id),
                      );
                    },
                  );
            return Scaffold(
              appBar: GsAppBar(
                label: Lang.of(context).getValue(Labels.sereniteaSets),
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
