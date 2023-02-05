import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_assets.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/gs_grid_view.dart';
import 'package:tracker/common/widgets/gs_no_results_state.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/materials_screen/material_list_item.dart';
import 'package:tracker/screens/screen_filters/screen_filter.dart';
import 'package:tracker/screens/screen_filters/screen_filter_builder.dart';

class MaterialsScreen extends StatelessWidget {
  static const id = 'materials_screen';

  const MaterialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder<bool>(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        if (snapshot.data != true) return const SizedBox();
        return ScreenFilterBuilder<InfoMaterial>(
          filter: ScreenFilters.infoMaterialFilter,
          builder: (context, filter, button, toggle) {
            final items = GsDatabase.instance.infoMaterials.getItems();
            final materials = filter.match(items);
            final child = materials.isEmpty
                ? const GsNoResultsState()
                : GsGridView.builder(
                    itemCount: materials.length,
                    itemBuilder: (context, index) {
                      final item = materials[index];
                      return MaterialListItem(item);
                    },
                  );
            return Scaffold(
              appBar: GsAppBar(
                label: context.fromLabel(Labels.materials),
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
