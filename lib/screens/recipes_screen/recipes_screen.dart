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

class RecipesScreen extends StatefulWidget {
  static const id = 'recipes_screen';

  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
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

        return ScreenFilterBuilder<InfoRecipe>(
          filter: ScreenFilters.infoRecipeFilter,
          builder: (context, filter, button, toggle) {
            final db = GsDatabase.instance;
            final recipes = db.infoRecipes.getItems();
            final sorted = filter.match(recipes);
            if (_selected.value + 1 > sorted.length) {
              _selected.value = 0;
            }

            return Scaffold(
              appBar: GsAppBar(
                label: Lang.of(context).getValue(Labels.recipes),
                actions: [button],
              ),
              body: Container(
                decoration: kMainBgDecoration,
                child: sorted.isEmpty
                    ? const GsNoResultsState()
                    : _getListView(sorted),
              ),
            );
          },
        );
      },
    );
  }

  Widget _getListView(List<InfoRecipe> sorted) {
    final db = GsDatabase.instance;
    return ValueListenableBuilder<int>(
      valueListenable: _selected,
      builder: (context, value, child) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 7,
              child: GsGridView.builder(
                itemCount: sorted.length,
                itemBuilder: (context, index) {
                  final item = sorted[index];
                  return RecipesListItem(
                    recipe: item,
                    selected: value == index,
                    savedRecipe: db.saveRecipes.getItemOrNull(item.id),
                    onTap: () => _selected.value = index,
                  );
                },
              ),
            ),
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(kSeparator4),
                child: RecipeDetailsCard(sorted[value]),
              ),
            ),
          ],
        );
      },
    );
  }
}
