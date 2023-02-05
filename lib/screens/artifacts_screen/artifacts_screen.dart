import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_assets.dart';
import 'package:tracker/common/graphics/gs_spacing.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/gs_grid_view.dart';
import 'package:tracker/common/widgets/gs_no_results_state.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/artifacts_screen/artifact_details_card.dart';
import 'package:tracker/screens/artifacts_screen/artifact_list_item.dart';
import 'package:tracker/screens/screen_filters/screen_filter.dart';
import 'package:tracker/screens/screen_filters/screen_filter_builder.dart';

class ArtifactsScreen extends StatefulWidget {
  static const id = 'artifacts_screen';

  const ArtifactsScreen({super.key});

  @override
  State<ArtifactsScreen> createState() => _ArtifactsScreenState();
}

class _ArtifactsScreenState extends State<ArtifactsScreen> {
  final _selected = ValueNotifier(0);

  @override
  void dispose() {
    _selected.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        final items = GsDatabase.instance.infoArtifacts.getItems();
        return ScreenFilterBuilder<InfoArtifact>(
          filter: ScreenFilters.infoArtifactFilter,
          builder: (context, filter, button, toggle) {
            final filtered = filter.match(items);
            if (_selected.value + 1 > filtered.length) {
              _selected.value = 0;
            }

            final child = filtered.isEmpty
                ? const GsNoResultsState()
                : ValueListenableBuilder<int>(
                    valueListenable: _selected,
                    builder: (context, value, child) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 7,
                            child: GsGridView.builder(
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                return ArtifactListItem(
                                  filtered[index],
                                  selected: value == index,
                                  onTap: () => _selected.value = index,
                                );
                              },
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(kSeparator8),
                              child: ArtifactDetailsCard(filtered[value]),
                            ),
                          ),
                        ],
                      );
                    },
                  );

            return Scaffold(
              appBar: GsAppBar(
                label: context.fromLabel(Labels.artifacts),
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
