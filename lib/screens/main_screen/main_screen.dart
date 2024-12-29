import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/achievements_screen/achievement_groups_screen.dart';
import 'package:tracker/screens/artifacts_screen/artifacts_screen.dart';
import 'package:tracker/screens/characters_screen/characters_screen.dart';
import 'package:tracker/screens/envisaged_echo_screen/envisaged_echo_screen.dart';
import 'package:tracker/screens/events_screen/event_screen.dart';
import 'package:tracker/screens/home_screen/home_screen.dart';
import 'package:tracker/screens/main_screen/save_toast.dart';
import 'package:tracker/screens/main_screen/tracker_router.dart';
import 'package:tracker/screens/materials_screen/materials_screen.dart';
import 'package:tracker/screens/namecard_screen/namecard_screen.dart';
import 'package:tracker/screens/recipes_screen/recipes_screen.dart';
import 'package:tracker/screens/remarkable_chests_screen/remarkable_chests_screen.dart';
import 'package:tracker/screens/reputation_screen/reputation_screen.dart';
import 'package:tracker/screens/serenitea_sets_screen/serenitea_sets_screen.dart';
import 'package:tracker/screens/settings_screen/settings_screen.dart';
import 'package:tracker/screens/spincrystals_screen/spincrystals_screen.dart';
import 'package:tracker/screens/version_screen/version_screen.dart';
import 'package:tracker/screens/weapons_screen/weapons_screen.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';
import 'package:tracker/screens/wishes_screen/wishes_screen.dart';

const _menuWidth = 80.0;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final ValueNotifier<int> _page;

  @override
  void initState() {
    super.initState();
    _page = ValueNotifier(0);
  }

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.themeColors.mainColor0,
      child: Stack(
        children: [
          Positioned.fill(
            left: _menuWidth,
            child: _pageWidget(),
          ),
          Positioned.fill(
            right: null,
            child: _buttonsWidget(),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: StreamBuilder<bool>(
              initialData: false,
              stream: Database.instance.saving.distinct(),
              builder: (context, snapshot) => Toast(show: snapshot.data!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonsWidget() {
    Widget button(int idx, _Menu menu) {
      final selected = idx == _page.value;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(kSeparator2),
        decoration: BoxDecoration(
          color: idx == 0
              ? context.themeColors.primary
              : context.themeColors.mainColor0,
          borderRadius: kGridRadius,
          border: Border.all(
            color: selected
                ? context.themeColors.almostWhite.withOpacity(0.4)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: InkWell(
          onTap: () {
            if (_page.value == idx) {
              final key = _menus[idx].navigator.key as GlobalKey?;
              final ctx = key?.currentContext;
              if (ctx != null) Navigator.of(ctx).maybePop();
            }
            _page.value = idx;
          },
          child: Image.asset(menu.icon, height: 40, width: 40),
        ),
      );
    }

    return InventoryBox(
      width: _menuWidth - kGridSeparator,
      margin: const EdgeInsets.all(kGridSeparator),
      child: ValueListenableBuilder(
        valueListenable: _page,
        builder: (context, value, child) {
          return ListView(
            children: _menus
                .mapIndexed(button)
                .separate(const SizedBox(height: kListSeparator))
                .toList(),
          );
        },
      ),
    );
  }

  Widget _pageWidget() {
    return ValueStreamBuilder<bool>(
      stream: Database.instance.loaded,
      builder: (context, snapshot) {
        if (!snapshot.data!) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 1.6,
            ),
          );
        }

        return ValueListenableBuilder(
          valueListenable: _page,
          key: const ValueKey('main_page_selector'),
          builder: (context, index, child) {
            return AnimatedSwitcher(
              key: const ValueKey('switcher'),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              duration: const Duration(milliseconds: 300),
              child: _menus[index].navigator,
            );
          },
        );
      },
    );
  }
}

final _menus = [
  _Menu(
    icon: imageAppIconSmall,
    initialPage: HomeScreen.id,
  ),
  _Menu(
    icon: menuIconWish,
    initialPage: WishesScreen.id,
  ),
  _Menu(
    icon: menuIconAchievements,
    initialPage: AchievementGroupsScreen.id,
  ),
  _Menu(
    icon: menuIconCharacters,
    initialPage: CharactersScreen.id,
  ),
  _Menu(
    icon: menuIconWeapons,
    initialPage: WeaponsScreen.id,
  ),
  _Menu(
    icon: menuIconRecipes,
    initialPage: RecipesScreen.id,
  ),
  _Menu(
    icon: menuIconMap,
    initialPage: RemarkableChestsScreen.id,
  ),
  _Menu(
    icon: menuIconEchos,
    initialPage: EnvisagedEchoScreen.id,
  ),
  _Menu(
    icon: menuIconInventory,
    initialPage: SpincrystalsScreen.id,
  ),
  _Menu(
    icon: menuIconSereniteaPot,
    initialPage: SereniteaSetsScreen.id,
  ),
  _Menu(
    icon: menuIconReputation,
    initialPage: ReputationScreen.id,
  ),
  _Menu(
    icon: menuIconArtifacts,
    initialPage: ArtifactsScreen.id,
  ),
  _Menu(
    icon: menuIconArchive,
    initialPage: NamecardScreen.id,
  ),
  _Menu(
    icon: menuIconMaterials,
    initialPage: MaterialsScreen.id,
  ),
  _Menu(
    icon: menuIconEvent,
    initialPage: EventScreen.id,
  ),
  _Menu(
    icon: menuIconFeedback,
    initialPage: VersionScreen.id,
  ),
  if (!kReleaseMode)
    _Menu(
      icon: menuIconFeedback,
      initialPage: SettingsScreen.id,
    ),
];

class _Menu {
  final String icon;
  final String initialPage;
  final Object? initialArgument;
  final Navigator navigator;

  _Menu({
    required this.icon,
    required this.initialPage,
    this.initialArgument,
  }) : navigator = Navigator(
          key: GlobalKey(),
          initialRoute: initialPage,
          onGenerateRoute: (settings) {
            if (initialPage == settings.name) {
              settings = RouteSettings(
                name: settings.name,
                arguments: initialArgument,
              );
            }
            return TrackerRouter.onGenerate(settings);
          },
        );
}
