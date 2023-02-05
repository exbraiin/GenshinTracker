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

class SereniteaSetsScreen extends StatefulWidget {
  static const id = 'serenitea_sets_screen';

  const SereniteaSetsScreen({super.key});

  @override
  State<SereniteaSetsScreen> createState() => _SereniteaSetsScreenState();
}

class _SereniteaSetsScreenState extends State<SereniteaSetsScreen> {
  final _selected = ValueNotifier(0);

  @override
  void dispose() {
    _selected.dispose();
    super.dispose();
  }

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
            if (_selected.value + 1 > filtered.length) {
              _selected.value = 0;
            }

            final child = filtered.isEmpty
                ? const GsNoResultsState()
                : _getListView(filtered);
            return Scaffold(
              appBar: GsAppBar(
                label: Lang.of(context).getValue(Labels.sereniteaSets),
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

  Widget _getListView(List<InfoSereniteaSet> list) {
    return ValueListenableBuilder<int>(
      valueListenable: _selected,
      builder: (context, selected, child) {
        final item = list[selected];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 7,
              child: GsGridView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final item = list[index];
                  return SereniteaSetListItem(
                    item,
                    onTap: () => _selected.value = index,
                  );
                },
              ),
            ),
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(kSeparator4),
                child: SereniteaSetDetailsCard(item),
              ),
            ),
          ],
        );
      },
    );
  }
}
