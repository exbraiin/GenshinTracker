import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/artifacts_screen/artifacts_screen.dart';
import 'package:tracker/screens/characters_screen/characters_screen.dart';
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
import 'package:tracker/screens/weekly_screen/weekly_screen.dart';
import 'package:tracker/screens/wishes_screen/wishes_screen.dart';
import 'package:tracker/theme/theme.dart';

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
    _page = ValueNotifier<int>(0);
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
          Padding(
            padding: const EdgeInsets.only(left: 80),
            child: _pageWidget(),
          ),
          _buttonsWidget(),
          Positioned(
            right: 0,
            bottom: 0,
            child: StreamBuilder<bool>(
              initialData: false,
              stream: GsDatabase.instance.saving.distinct(),
              builder: (context, snapshot) => Toast(show: snapshot.data!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonsWidget() {
    var hover = false;
    Widget button(int idx, Menu menu) {
      final selected = idx == _page.value;
      return Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            width: double.infinity,
            padding: const EdgeInsets.all(kSeparator2),
            decoration: BoxDecoration(
              color: idx == 0
                  ? context.themeColors.primary
                  : selected
                      ? context.themeColors.mainColor1
                      : context.themeColors.mainColor2,
              borderRadius: kMainRadius,
              border: Border.all(
                color:
                    selected ? context.themeColors.primary : Colors.transparent,
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
          ),
          if (idx != 0)
            Positioned.fill(
              top: null,
              child: IgnorePointer(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: hover ? 1 : 0,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.all(kSeparator2),
                    decoration: BoxDecoration(
                      color: context.themeColors.mainColor0.withOpacity(0.4),
                      borderRadius: kMainRadius.copyWith(
                        topLeft: Radius.zero,
                        topRight: Radius.zero,
                      ),
                    ),
                    child: Text(
                      context.fromLabel(menu.label),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    }

    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => hover = true),
          onExit: (_) => setState(() => hover = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: hover ? 160 : 80,
            decoration: BoxDecoration(
              color: context.themeColors.mainColor0,
              border: Border(
                right: BorderSide(
                  color: context.themeColors.mainColor2,
                  width: 2,
                ),
              ),
            ),
            child: ValueListenableBuilder<int>(
              valueListenable: _page,
              builder: (context, value, child) {
                return ListView(
                  padding: const EdgeInsets.all(kSeparator4),
                  children: _menus
                      .mapIndexed(button)
                      .separate(const SizedBox(height: kSeparator2))
                      .toList(),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _pageWidget() {
    return ValueStreamBuilder<bool>(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        if (!snapshot.data!) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 1.6,
            ),
          );
        }

        return ValueListenableBuilder<int>(
          valueListenable: _page,
          key: const ValueKey('main_page_selector'),
          builder: (context, index, child) {
            return _PageAnimator(
              key: ValueKey('main_$index'),
              child: _menus[index].navigator,
            );
          },
        );
      },
    );
  }
}

final _menus = [
  Menu(
    label: Labels.home,
    icon: imageAppIconSmall,
    initialPage: HomeScreen.id,
  ),
  Menu(
    label: Labels.charWishes,
    icon: menuIconWish,
    initialPage: WishesScreen.id,
    initialArgument: GsBanner.character,
  ),
  Menu(
    label: Labels.weaponWishes,
    icon: menuIconWish,
    initialPage: WishesScreen.id,
    initialArgument: GsBanner.weapon,
  ),
  Menu(
    label: Labels.stndWishes,
    icon: menuIconWish,
    initialPage: WishesScreen.id,
    initialArgument: GsBanner.standard,
  ),
  Menu(
    label: Labels.noviceWishes,
    icon: menuIconWish,
    initialPage: WishesScreen.id,
    initialArgument: GsBanner.beginner,
  ),
  Menu(
    label: Labels.characters,
    icon: menuIconCharacters,
    initialPage: CharactersScreen.id,
  ),
  Menu(
    label: Labels.weapons,
    icon: menuIconWeapons,
    initialPage: WeaponsScreen.id,
  ),
  Menu(
    label: Labels.artifacts,
    icon: menuIconArtifacts,
    initialPage: ArtifactsScreen.id,
  ),
  Menu(
    label: Labels.recipes,
    icon: menuIconRecipes,
    initialPage: RecipesScreen.id,
  ),
  Menu(
    label: Labels.remarkableChests,
    icon: menuIconMap,
    initialPage: RemarkableChestsScreen.id,
  ),
  Menu(
    label: Labels.materials,
    icon: menuIconMaterials,
    initialPage: MaterialsScreen.id,
  ),
  Menu(
    label: Labels.spincrystals,
    icon: menuIconInventory,
    initialPage: SpincrystalsScreen.id,
  ),
  Menu(
    label: Labels.sereniteaSets,
    icon: menuIconSereniteaPot,
    initialPage: SereniteaSetsScreen.id,
  ),
  Menu(
    label: Labels.reputation,
    icon: menuIconReputation,
    initialPage: ReputationScreen.id,
  ),
  Menu(
    label: Labels.namecards,
    icon: menuIconArchive,
    initialPage: NamecardScreen.id,
  ),
  Menu(
    label: Labels.weeklyTasks,
    icon: menuIconBook,
    initialPage: WeeklyScreen.id,
  ),
  Menu(
    label: Labels.version,
    icon: menuIconFeedback,
    initialPage: VersionScreen.id,
  ),
  if (!kReleaseMode)
    Menu(
      label: 'Settings',
      icon: menuIconFeedback,
      initialPage: SettingsScreen.id,
    ),
];

class Menu {
  final String label;
  final String icon;
  final String initialPage;
  final Object? initialArgument;
  final Navigator navigator;

  Menu({
    required this.label,
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

class _PageAnimator extends StatefulWidget {
  final Widget child;

  const _PageAnimator({
    super.key,
    required this.child,
  });

  @override
  State<_PageAnimator> createState() => _PageAnimatorState();
}

class _PageAnimatorState extends State<_PageAnimator> {
  var _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame
        .then((value) => setState(() => _opacity = 1));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 400),
      child: widget.child,
    );
  }
}
