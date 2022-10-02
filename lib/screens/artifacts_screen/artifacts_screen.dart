import 'package:flutter/material.dart';
import 'package:tracker/common/lang/labels.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/gs_grid_view.dart';
import 'package:tracker/common/widgets/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/artifacts_screen/artifact_list_item.dart';
import 'package:tracker/screens/screen_filters/screen_filter.dart';
import 'package:tracker/screens/screen_filters/screen_filter_drawer.dart';

class ArtifactsScreen extends StatelessWidget {
  static const id = 'artifacts_screen';

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        final items = GsDatabase.instance.infoArtifacts.getItems();
        return ScreenDrawerBuilder<InfoArtifact>(
          filter: () => infoArtifactFilter,
          builder: (context, filter, drawer) {
            final filtered = filter.match(items);
            return Scaffold(
              appBar: GsAppBar(label: context.fromLabel(Labels.artifacts)),
              body: GsGridView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) =>
                    ArtifactListItem(filtered[index]),
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
