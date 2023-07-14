import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/home_screen/widgets/home_achievements_widget.dart';
import 'package:tracker/screens/home_screen/widgets/home_ascension_widget.dart';
import 'package:tracker/screens/home_screen/widgets/home_birthdays_widget.dart';
import 'package:tracker/screens/home_screen/widgets/home_friends_widget.dart';
import 'package:tracker/screens/home_screen/widgets/home_last_banner_widget.dart';
import 'package:tracker/screens/home_screen/widgets/home_player_info_widget.dart';
import 'package:tracker/screens/home_screen/widgets/home_recipes_widget.dart';
import 'package:tracker/screens/home_screen/widgets/home_remarkable_chests_widget.dart';
import 'package:tracker/screens/home_screen/widgets/home_reputation_widget.dart';
import 'package:tracker/screens/home_screen/widgets/home_resource_cal_widget.dart';
import 'package:tracker/screens/home_screen/widgets/home_serenitea_widget.dart';
import 'package:tracker/screens/home_screen/widgets/home_spincrystal_widget.dart';
import 'package:tracker/screens/home_screen/widgets/home_wish_values.dart';

class HomeScreen extends StatefulWidget {
  static const id = 'home_screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _notifier = ValueNotifier(true);

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GsAppBar(
        label: Lang.of(context).getValue(Labels.home),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: _notifier,
            builder: (context, value, child) {
              return IconButton(
                icon: Icon(
                  value
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                  color: Colors.white.withOpacity(0.5),
                ),
                onPressed: () => _notifier.value = !_notifier.value,
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: ValueListenableBuilder<bool>(
              valueListenable: _notifier,
              builder: (context, value, child) {
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: value ? 0.05 : 1,
                  child: child,
                );
              },
              child: CachedImageWidget(
                GsUtils.versions.getCurrentVersion()?.image,
                fit: BoxFit.cover,
                scaleToSize: false,
                showPlaceholder: false,
              ),
            ),
          ),
          Positioned.fill(
            child: ValueListenableBuilder<bool>(
              valueListenable: _notifier,
              builder: (context, value, child) {
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: value ? 1 : 0,
                  child: child,
                );
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(kSeparator4),
                child: _widgets(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _widgets(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: <Widget>[
              HomeWishesValues(
                title: Lang.of(context).getValue(Labels.charWishes),
                banner: GsBanner.character,
              ),
              HomeWishesValues(
                title: Lang.of(context).getValue(Labels.noviceWishes),
                banner: GsBanner.beginner,
              ),
              const HomeAchievementsWidget(),
              const HomeRemarkableChestsWidget(),
              const HomeReputationWidget(),
            ].separate(const SizedBox(height: kSeparator4)).toList(),
          ),
        ),
        const SizedBox(width: kSeparator4),
        Expanded(
          child: Column(
            children: <Widget>[
              HomeWishesValues(
                title: Lang.of(context).getValue(Labels.weaponWishes),
                banner: GsBanner.weapon,
                maxPity: 80,
              ),
              HomeWishesValues(
                title: Lang.of(context).getValue(Labels.stndWishes),
                banner: GsBanner.standard,
              ),
              const HomeSpincrystalsWidget(),
              const HomeResourceCalcWidget(),
            ].separate(const SizedBox(height: kSeparator4)).toList(),
          ),
        ),
        const SizedBox(width: kSeparator4),
        Expanded(
          child: Column(
            children: [
              const HomePlayerInfoWidget(),
              const HomeFriendsWidget(),
              const HomeAscensionWidget(),
              const HomeBirthdaysWidget(),
              const HomeLastBannerWidget(),
              const HomeRecipesWidget(),
              const HomeSereniteaWidget(),
            ].separate(const SizedBox(height: kSeparator4)).toList(),
          ),
        ),
      ],
    );
  }
}
