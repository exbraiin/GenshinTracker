import 'package:flutter/material.dart';
import 'package:tracker/screens/achievements_screen/achievement_groups_screen.dart';
import 'package:tracker/screens/add_wish_screen/add_wish_screen.dart';
import 'package:tracker/screens/artifacts_screen/artifacts_screen.dart';
import 'package:tracker/screens/characters_screen/characters_screen.dart';
import 'package:tracker/screens/envisaged_echo_screen/envisaged_echo_screen.dart';
import 'package:tracker/screens/events_screen/event_screen.dart';
import 'package:tracker/screens/home_screen/home_screen.dart';
import 'package:tracker/screens/materials_screen/materials_screen.dart';
import 'package:tracker/screens/namecard_screen/namecard_screen.dart';
import 'package:tracker/screens/recipes_screen/recipes_screen.dart';
import 'package:tracker/screens/remarkable_chests_screen/remarkable_chests_screen.dart';
import 'package:tracker/screens/serenitea_sets_screen/serenitea_sets_screen.dart';
import 'package:tracker/screens/spincrystals_screen/spincrystals_screen.dart';
import 'package:tracker/screens/version_screen/version_screen.dart';
import 'package:tracker/screens/weapons_screen/weapons_screen.dart';
import 'package:tracker/screens/wishes_screen/wishes_screen.dart';

class TrackerRouter {
  TrackerRouter._();

  static final Map<String, Widget Function()> _routes = {
    HomeScreen.id: () => const HomeScreen(),
    WishesScreen.id: () => const WishesScreen(),
    AddWishScreen.id: () => const AddWishScreen(),
    RecipesScreen.id: () => const RecipesScreen(),
    RemarkableChestsScreen.id: () => const RemarkableChestsScreen(),
    EnvisagedEchoScreen.id: () => const EnvisagedEchoScreen(),
    WeaponsScreen.id: () => const WeaponsScreen(),
    ArtifactsScreen.id: () => const ArtifactsScreen(),
    CharactersScreen.id: () => const CharactersScreen(),
    NamecardScreen.id: () => const NamecardScreen(),
    MaterialsScreen.id: () => const MaterialsScreen(),
    EventScreen.id: () => const EventScreen(),
    SereniteaSetsScreen.id: () => const SereniteaSetsScreen(),
    SpincrystalsScreen.id: () => const SpincrystalsScreen(),
    VersionScreen.id: () => const VersionScreen(),
    AchievementGroupsScreen.id: () => const AchievementGroupsScreen(),
  };

  static Route? onGenerate(RouteSettings settings) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation.drive(CurveTween(curve: Curves.easeIn)),
          child: _routes[settings.name]?.call() ??
              const Center(
                child: Text(
                  'No route defined!',
                  style: TextStyle(color: Colors.white),
                ),
              ),
        );
      },
      settings: settings,
    );
  }
}
