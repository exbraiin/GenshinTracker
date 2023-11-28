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
import 'package:tracker/screens/serenitea_sets_screen/serenitea_set_details_card.dart';
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
        return ScreenFilterBuilder<InfoSereniteaSet>(
          filter: ScreenFilters.infoSereniteaSetFilter,
          builder: (context, filter, button, toggle) {
            final setsList = GsDatabase.instance.infoSereniteaSets.getItems();
            final filtered = filter.match(setsList);
            return Scaffold(
              appBar: GsAppBar(
                label: context.fromLabel(Labels.sereniteaSets),
                actions: [button],
              ),
              body: Container(
                decoration: kMainBgDecoration,
                child: _getListView(filtered),
              ),
            );
          },
        );
      },
    );
  }

  Widget _getListView(List<InfoSereniteaSet> list) {
    if (list.isEmpty) return const GsNoResultsState();
    return GsGridView.builder(
      childWidth: 280,
      childHeight: 160,
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return SereniteaSetListItem(
          item,
          onTap: () => SereniteaSetDetailsCard(item).show(context),
        );
      },
    );
  }
}
