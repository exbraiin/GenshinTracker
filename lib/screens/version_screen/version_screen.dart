import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/gs_grid_view.dart';
import 'package:tracker/common/widgets/gs_no_results_state.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/version_screen/version_list_item.dart';

class VersionScreen extends StatelessWidget {
  static const id = 'version_screen';

  const VersionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder<bool>(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        if (snapshot.data != true) return const SizedBox();

        final db = GsDatabase.instance;
        final items = db.infoVersion
            .getItems()
            .sortedByDescending((element) => element.releaseDate);

        return Scaffold(
          appBar: GsAppBar(
            label: context.fromLabel(Labels.version),
          ),
          body: Container(
            decoration: kMainBgDecoration,
            child: _getListView(items),
          ),
        );
      },
    );
  }

  Widget _getListView(List<InfoVersion> list) {
    if (list.isEmpty) return const GsNoResultsState();
    return GsGridView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return VersionListItem(item);
      },
    );
  }
}
