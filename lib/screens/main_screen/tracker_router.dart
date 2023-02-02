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
import 'package:tracker/screens/namecard_screen/namecard_screen.dart';
import 'package:tracker/screens/recipes_screen/recipe_details_screen.dart';
import 'package:tracker/screens/recipes_screen/recipes_screen.dart';
import 'package:tracker/screens/remarkable_chests_screen/remarkable_chests_screen.dart';
import 'package:tracker/screens/reputation_screen/reputation_screen.dart';
import 'package:tracker/screens/serenitea_sets_screen/serenitea_sets_screen.dart';
import 'package:tracker/screens/spincrystals_screen/spincrystals_screen.dart';
import 'package:tracker/screens/weapons_screen/weapon_details_screen.dart';
import 'package:tracker/screens/weapons_screen/weapons_screen.dart';
import 'package:tracker/screens/weekly_screen/weekly_screen.dart';
import 'package:tracker/screens/wishes_screen/wishes_screen.dart';

class TrackerRouter {
  TrackerRouter._();

  static final Map<String, Widget Function()> _routes = {
    HomeScreen.id: () => const HomeScreen(),
    WeeklyScreen.id: () => const WeeklyScreen(),
    WishesScreen.id: () => const WishesScreen(),
    AddWishScreen.id: () => const AddWishScreen(),
    RecipesScreen.id: () => const RecipesScreen(),
    RecipeDetailsScreen.id: () => const RecipeDetailsScreen(),
    RemarkableChestsScreen.id: () => const RemarkableChestsScreen(),
    WeaponsScreen.id: () => const WeaponsScreen(),
    WeaponDetailsScreen.id: () => const WeaponDetailsScreen(),
    ArtifactsScreen.id: () => const ArtifactsScreen(),
    ArtifactDetailsScreen.id: () => const ArtifactDetailsScreen(),
    CharactersScreen.id: () => const CharactersScreen(),
    NamecardScreen.id: () => const NamecardScreen(),
    MaterialsScreen.id: () => const MaterialsScreen(),
    ReputationScreen.id: () => const ReputationScreen(),
    SereniteaSetsScreen.id: () => const SereniteaSetsScreen(),
    CharacterDetailsScreen.id: () => CharacterDetailsScreen(),
    CharacterAscensionScreen.id: () => const CharacterAscensionScreen(),
    SpincrystalsScreen.id: () => const SpincrystalsScreen(),
    ChangelogScreen.id: () => const ChangelogScreen(),
  };

  static Route? onGenerate(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) =>
          _routes[settings.name]?.call() ??
          const Center(
            child: Text(
              'No route defined!',
              style: TextStyle(color: Colors.white),
            ),
          ),
      settings: settings,
    );
  }
}
