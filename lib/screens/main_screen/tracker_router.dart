import 'package:flutter/material.dart';
import 'package:tracker/screens/achievements_screen/achievements_list_screen.dart';
import 'package:tracker/screens/achievements_screen/achievements_screen.dart';
import 'package:tracker/screens/add_wish_screen/add_wish_screen.dart';
import 'package:tracker/screens/artifacts_screen/artifacts_screen.dart';
import 'package:tracker/screens/character_ascension/character_ascension_screen.dart';
import 'package:tracker/screens/characters_screen/character_details_screen.dart';
import 'package:tracker/screens/characters_screen/characters_screen.dart';
import 'package:tracker/screens/home_screen/home_screen.dart';
import 'package:tracker/screens/materials_screen/materials_screen.dart';
import 'package:tracker/screens/recipes_screen/recipes_screen.dart';
import 'package:tracker/screens/reputation_screen/reputation_screen.dart';
import 'package:tracker/screens/serenitea_sets_screen/serenitea_sets_screen.dart';
import 'package:tracker/screens/spincrystals_screen/spincrystals_screen.dart';
import 'package:tracker/screens/weapons_screen/weapons_screen.dart';
import 'package:tracker/screens/wishes_screen/wishes_screen.dart';

class TrackerRouter {
  TrackerRouter._();

  static Map<String, Widget Function()> _routes = {
    HomeScreen.id: () => HomeScreen(),
    WishesScreen.id: () => WishesScreen(),
    AddWishScreen.id: () => AddWishScreen(),
    RecipesScreen.id: () => RecipesScreen(),
    WeaponsScreen.id: () => WeaponsScreen(),
    ArtifactsScreen.id: () => ArtifactsScreen(),
    CharactersScreen.id: () => CharactersScreen(),
    MaterialsScreen.id: () => MaterialsScreen(),
    ReputationScreen.id: () => ReputationScreen(),
    SereniteaSetsScreen.id: () => SereniteaSetsScreen(),
    CharacterDetailsScreen.id: () => CharacterDetailsScreen(),
    CharacterAscensionScreen.id: () => CharacterAscensionScreen(),
    SpincrystalsScreen.id: () => SpincrystalsScreen(),
    AchievementsScreen.id: () => AchievementsScreen(),
    AchievementsListScreen.id: () => AchievementsListScreen(),
  };

  static Route? onGenerate(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => _routes[settings.name]?.call() ?? SizedBox(),
      settings: settings,
    );
  }
}
