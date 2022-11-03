import 'package:flutter/material.dart';
import 'package:tracker/screens/add_wish_screen/add_wish_screen.dart';
import 'package:tracker/screens/artifacts_screen/artifact_details_screen.dart';
import 'package:tracker/screens/artifacts_screen/artifacts_screen.dart';
import 'package:tracker/screens/changelog_screen/changelog_screen.dart';
import 'package:tracker/screens/character_ascension_screen/character_ascension_screen.dart';
import 'package:tracker/screens/characters_screen/character_details_screen.dart';
import 'package:tracker/screens/characters_screen/characters_screen.dart';
import 'package:tracker/screens/home_screen/home_screen.dart';
import 'package:tracker/screens/materials_screen/materials_screen.dart';
import 'package:tracker/screens/recipes_screen/recipe_details_screen.dart';
import 'package:tracker/screens/recipes_screen/recipes_screen.dart';
import 'package:tracker/screens/reputation_screen/reputation_screen.dart';
import 'package:tracker/screens/serenitea_sets_screen/serenitea_sets_screen.dart';
import 'package:tracker/screens/spincrystals_screen/spincrystals_screen.dart';
import 'package:tracker/screens/tests_screen/tests_screen.dart';
import 'package:tracker/screens/weapons_screen/weapon_details_screen.dart';
import 'package:tracker/screens/weapons_screen/weapons_screen.dart';
import 'package:tracker/screens/wishes_screen/wishes_screen.dart';

class TrackerRouter {
  TrackerRouter._();

  static Map<String, Widget Function()> _routes = {
    HomeScreen.id: () => HomeScreen(),
    WishesScreen.id: () => WishesScreen(),
    AddWishScreen.id: () => AddWishScreen(),
    RecipesScreen.id: () => RecipesScreen(),
    RecipeDetailsScreen.id: () => RecipeDetailsScreen(),
    WeaponsScreen.id: () => WeaponsScreen(),
    WeaponDetailsScreen.id: () => WeaponDetailsScreen(),
    ArtifactsScreen.id: () => ArtifactsScreen(),
    ArtifactDetailsScreen.id: () => ArtifactDetailsScreen(),
    CharactersScreen.id: () => CharactersScreen(),
    MaterialsScreen.id: () => MaterialsScreen(),
    ReputationScreen.id: () => ReputationScreen(),
    SereniteaSetsScreen.id: () => SereniteaSetsScreen(),
    CharacterDetailsScreen.id: () => CharacterDetailsScreen(),
    CharacterAscensionScreen.id: () => CharacterAscensionScreen(),
    SpincrystalsScreen.id: () => SpincrystalsScreen(),
    ChangelogScreen.id: () => ChangelogScreen(),
    TestsScreen.id: () => TestsScreen(),
  };

  static Route? onGenerate(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => _routes[settings.name]?.call() ?? SizedBox(),
      settings: settings,
    );
  }
}
