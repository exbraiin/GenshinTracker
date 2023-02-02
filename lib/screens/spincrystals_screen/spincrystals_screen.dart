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
import 'package:tracker/screens/spincrystals_screen/spincrystal_list_item.dart';

class SpincrystalsScreen extends StatelessWidget {
  static const id = 'spincrystal_screen';

  const SpincrystalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder<bool>(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        if (snapshot.data != true) return const SizedBox();
        return ScreenDrawerBuilder<InfoSpincrystal>(
          filter: () => ScreenFilters.infoSpincrystalFilter,
          builder: (context, filter, drawer) {
            final items = GsDatabase.instance.infoSpincrystal.getItems();
            final spincrystals = filter.match(items);
            final child = spincrystals.isEmpty
                ? const GsNoResultsState()
                : GsGridView.builder(
                    itemCount: spincrystals.length,
                    itemBuilder: (context, index) {
                      final item = spincrystals[index];
                      return SpincrystalListItem(spincrystal: item);
                    },
                  );

            return Scaffold(
              appBar: GsAppBar(
                label: Lang.of(context).getValue(Labels.spincrystals),
              ),
              body: Padding(
                padding: const EdgeInsets.all(kSeparator4),
                child: child,
              ),
              endDrawer: drawer,
              endDrawerEnableOpenDragGesture: false,
            );
          },
        );
      },
    );
  }
}
