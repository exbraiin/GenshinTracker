import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/common/widgets/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/artifacts_screen/artifacts_screen.dart';
import 'package:tracker/screens/changelog_screen/changelog_screen.dart';
import 'package:tracker/screens/characters_screen/characters_screen.dart';
import 'package:tracker/screens/home_screen/home_screen.dart';
import 'package:tracker/screens/main_screen/save_toast.dart';
import 'package:tracker/screens/main_screen/tracker_router.dart';
import 'package:tracker/screens/materials_screen/materials_screen.dart';
import 'package:tracker/screens/recipes_screen/recipes_screen.dart';
import 'package:tracker/screens/reputation_screen/reputation_screen.dart';
import 'package:tracker/screens/serenitea_sets_screen/serenitea_sets_screen.dart';
import 'package:tracker/screens/spincrystals_screen/spincrystals_screen.dart';
import 'package:tracker/screens/tests_screen/tests_screen.dart';
import 'package:tracker/screens/weapons_screen/weapons_screen.dart';
import 'package:tracker/screens/wishes_screen/wishes_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
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
      color: GsColors.mainColor0,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 250),
            child: _pageWidget(),
          ),
          Material(
            child: _buttonsWidget(),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: StreamBuilder<bool>(
              initialData: false,
              stream: GsDatabase.instance.saving.distinct(),
              builder: (context, snapshot) => Toast(snapshot.data!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _button(int index, Menu menu) {
    final asset = menu.icon;
    final label = Lang.of(context).getValue(menu.label);
    final selected = _page.value == index;
    return AnimatedContainer(
      height: 60,
      width: double.infinity,
      curve: Curves.easeInOutCubic,
      duration: Duration(milliseconds: 400),
      margin:
          EdgeInsets.fromLTRB(kSeparator4, 0, selected ? 0 : kSeparator4, 0),
      decoration: BoxDecoration(
        color: selected ? GsColors.mainColor1 : GsColors.mainColor2,
        borderRadius: BorderRadius.horizontal(
          left: kMainRadius.topLeft,
          right: selected ? Radius.zero : kMainRadius.topRight,
        ),
        boxShadow: mainShadow,
      ),
      child: InkWell(
        onTap: () {
          if (_page.value == index) {
            final key = _menus[index].page.key as GlobalKey;
            final nv = key.currentState;
            if (nv != null && nv is NavigatorState) {
              nv.popUntil((route) => route.isFirst);
            }
          }
          _page.value = index;
        },
        child: Row(
          children: [
            Container(
              height: 32,
              width: 32,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                image: asset.isNotEmpty
                    ? DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage(asset),
                      )
                    : null,
              ),
            ),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonsWidget() {
    return Container(
      width: 250,
      color: GsColors.mainColor0,
      child: Column(
        children: [
          Container(
            height: 56,
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Image.asset(
                  imageAppIcon,
                  height: 46,
                  width: 46,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 4),
                Text(
                  Lang.of(context).getValue(Labels.appTitle),
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<int>(
              valueListenable: _page,
              builder: (context, value, child) {
                return ListView(
                  padding: EdgeInsets.symmetric(vertical: kSeparator4),
                  children: _menus
                      .mapIndexed((i, m) => _button(i, m))
                      .separate(SizedBox(height: kSeparator2))
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _pageWidget() {
    return ValueStreamBuilder<bool>(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        if (!snapshot.data!) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 1.6,
            ),
          );
        }

        return ValueListenableBuilder<int>(
          valueListenable: _page,
          key: ValueKey('main_page_selector'),
          builder: (context, index, child) {
            return _PageAnimator(
              key: ValueKey('main_$index'),
              child: _menus[index].page,
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
    icon: menuIconInventory,
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
  if (kDebugMode)
    Menu(
      label: Labels.changelog,
      icon: menuIconAchievements,
      initialPage: ChangelogScreen.id,
    ),
  if (kDebugMode)
    Menu(
      label: Labels.wsNone,
      icon: menuIconAchievements,
      initialPage: TestsScreen.id,
    ),
];

class Menu {
  final String label;
  final String icon;
  final String initialPage;
  final Object? initialArgument;
  final Widget page;
  final key = GlobalKey();

  Menu({
    required this.label,
    required this.icon,
    required this.initialPage,
    this.initialArgument,
  }) : page = Navigator(
          key: GlobalKey(),
          initialRoute: initialPage,
          onGenerateRoute: (settings) {
            if (initialPage == settings.name) {
              settings = settings.copyWith(arguments: initialArgument);
            }
            return TrackerRouter.onGenerate(settings);
          },
        );
}

class _PageAnimator extends StatefulWidget {
  final Widget child;

  _PageAnimator({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<_PageAnimator> createState() => _PageAnimatorState();
}

class _PageAnimatorState extends State<_PageAnimator> {
  var opacity = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame
        .then((value) => setState(() => opacity = 1));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      child: widget.child,
      curve: Curves.easeIn,
      duration: Duration(milliseconds: 400),
    );
  }
}
