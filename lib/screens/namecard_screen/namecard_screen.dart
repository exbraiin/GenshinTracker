import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/gs_grid_view.dart';
import 'package:tracker/common/widgets/gs_no_results_state.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/namecard_screen/namecard_details_card.dart';
import 'package:tracker/screens/namecard_screen/namecard_list_item.dart';
import 'package:tracker/screens/screen_filters/screen_filter.dart';
import 'package:tracker/screens/screen_filters/screen_filter_builder.dart';

class NamecardScreen extends StatelessWidget {
  static const id = 'namecards_screen';

  const NamecardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder<bool>(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        final items = GsDatabase.instance.infoNamecards.getItems();
        return ScreenFilterBuilder<InfoNamecard>(
          filter: ScreenFilters.infoNamecardFilter,
          builder: (context, filter, button, toggle) {
            final filtered = filter.match(items);
            return Scaffold(
              appBar: GsAppBar(
                label: context.fromLabel(Labels.namecards),
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

  Widget _getListView(List<InfoNamecard> sorted) {
    if (sorted.isEmpty) return const GsNoResultsState();
    return GsGridView.builder(
      itemCount: sorted.length,
      itemBuilder: (context, index) {
        final item = sorted[index];
        return NamecardListItem(
          item,
          onTap: () => NamecardDetailsCard(item).show(context),
        );
      },
    );
  }
}
