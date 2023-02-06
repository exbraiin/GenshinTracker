import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_assets.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/gs_grid_view.dart';
import 'package:tracker/common/widgets/gs_no_results_state.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/remarkable_chests_screen/remarkable_chest_details_card.dart';
import 'package:tracker/screens/remarkable_chests_screen/remarkable_chests_list_item.dart';
import 'package:tracker/screens/screen_filters/screen_filter.dart';
import 'package:tracker/screens/screen_filters/screen_filter_builder.dart';

class RemarkableChestsScreen extends StatelessWidget {
  static const id = 'remarkable_chests_screen';

  const RemarkableChestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder<bool>(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        if (snapshot.data != true) return const SizedBox();
        return ScreenFilterBuilder<InfoRemarkableChest>(
          filter: ScreenFilters.infoRemarkableChestFilter,
          builder: (context, filter, button, toggle) {
            final items = GsDatabase.instance.infoRemarkableChests.getItems();
            final remarkableChests = filter.match(items);
            final child = remarkableChests.isEmpty
                ? const GsNoResultsState()
                : GsGridView.builder(
                    itemCount: remarkableChests.length,
                    itemBuilder: (context, index) {
                      final item = remarkableChests[index];
                      return RemarkableChestListItem(
                        item,
                        onTap: () =>
                            RemarkableChestDetailsCard(item).show(context),
                      );
                    },
                  );
            return Scaffold(
              appBar: GsAppBar(
                label: context.fromLabel(Labels.remarkableChests),
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
