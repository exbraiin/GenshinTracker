import 'package:flutter/material.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/gs_grid_view.dart';
import 'package:tracker/common/widgets/gs_no_results_state.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/remarkable_chests_screen/remarkable_chests_list_item.dart';
import 'package:tracker/screens/screen_filters/screen_filter.dart';
import 'package:tracker/screens/screen_filters/screen_filter_drawer.dart';

class RemarkableChestsScreen extends StatelessWidget {
  static const id = 'remarkable_chests_screen';

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder<bool>(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        if (snapshot.data != true) return SizedBox();
        return ScreenDrawerBuilder<InfoRemarkableChest>(
          filter: () => ScreenFilters.infoRemarkableChestFilter,
          builder: (context, filter, drawer) {
            final items = GsDatabase.instance.infoRemarkableChests.getItems();
            final remarkableChests = filter.match(items);
            final child = remarkableChests.isEmpty
                ? GsNoResultsState()
                : GsGridView.builder(
                    itemCount: remarkableChests.length,
                    itemBuilder: (context, index) {
                      final item = remarkableChests[index];
                      return RemarkableChestListItem(item);
                    },
                  );
            return Scaffold(
              appBar: GsAppBar(
                label: context.fromLabel(Labels.remarkableChests),
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
