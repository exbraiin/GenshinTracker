import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/gs_grid_view.dart';
import 'package:tracker/common/widgets/gs_no_results_state.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/recipes_screen/recipe_details_card.dart';
import 'package:tracker/screens/recipes_screen/recipes_list_item.dart';
import 'package:tracker/screens/screen_filters/screen_filter.dart';
import 'package:tracker/screens/screen_filters/screen_filter_builder.dart';

class RecipesScreen extends StatelessWidget {
  static const id = 'recipes_screen';

  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder<bool>(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        if (snapshot.data != true) return const SizedBox();

        return ScreenFilterBuilder<InfoRecipe>(
          filter: ScreenFilters.infoRecipeFilter,
          builder: (context, filter, button, toggle) {
            final db = GsDatabase.instance;
            final recipes = db.infoRecipes.getItems();
            final sorted = filter.match(recipes);

            return Scaffold(
              appBar: GsAppBar(
                label: Lang.of(context).getValue(Labels.recipes),
                actions: [button],
              ),
              body: Container(
                decoration: kMainBgDecoration,
                child: _getListView(sorted),
              ),
            );
          },
        );
      },
    );
  }

  Widget _getListView(List<InfoRecipe> sorted) {
    if (sorted.isEmpty) return const GsNoResultsState();
    final db = GsDatabase.instance;
    return GsGridView.builder(
      itemCount: sorted.length,
      itemBuilder: (context, index) {
        final item = sorted[index];
        return RecipesListItem(
          recipe: item,
          savedRecipe: db.saveRecipes.getItemOrNull(item.id),
          onTap: () => RecipeDetailsCard(item).show(context),
        );
      },
    );
  }
}
