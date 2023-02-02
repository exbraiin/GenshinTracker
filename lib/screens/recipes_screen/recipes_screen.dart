import 'package:flutter/material.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_no_results_state.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/gs_grid_view.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/recipes_screen/recipes_list_item.dart';
import 'package:tracker/screens/screen_filters/screen_filter.dart';
import 'package:tracker/screens/screen_filters/screen_filter_drawer.dart';

class RecipesScreen extends StatelessWidget {
  static const id = 'recipes_screen';

  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder<bool>(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        if (snapshot.data != true) return const SizedBox();

        return ScreenDrawerBuilder<InfoRecipe>(
          filter: () => ScreenFilters.infoRecipeFilter,
          builder: (context, filter, drawer) {
            final db = GsDatabase.instance;
            final recipes = db.infoRecipes.getItems();
            final sorted = filter.match(recipes);

            final child = sorted.isEmpty
                ? const GsNoResultsState()
                : GsGridView.builder(
                    itemCount: sorted.length,
                    itemBuilder: (context, index) {
                      final item = sorted[index];
                      return RecipesListItem(
                        recipe: item,
                        savedRecipe: db.saveRecipes.getItemOrNull(item.id),
                      );
                    },
                  );

            return Scaffold(
              appBar: GsAppBar(
                label: Lang.of(context).getValue(Labels.recipes),
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
