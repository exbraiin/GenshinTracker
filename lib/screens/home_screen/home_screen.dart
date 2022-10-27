import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/domain/gs_database.exporter.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/home_screen/widgets/home_ascension_widget.dart';
import 'package:tracker/screens/home_screen/widgets/home_birthdays_widget.dart';
import 'package:tracker/screens/home_screen/widgets/home_friends_widget.dart';
import 'package:tracker/screens/home_screen/widgets/home_recipes_widget.dart';
import 'package:tracker/screens/home_screen/widgets/home_reputation_widget.dart';
import 'package:tracker/screens/home_screen/widgets/home_resource_cal_widget.dart';
import 'package:tracker/screens/home_screen/widgets/home_spincrystal_widget.dart';
import 'package:tracker/screens/home_screen/widgets/home_wish_values.dart';
import 'package:tracker/screens/home_screen/widgets/home_wishes_summary.dart';

class HomeScreen extends StatelessWidget {
  static const id = 'home_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GsAppBar(
        label: Lang.of(context).getValue(Labels.home),
        actions: [
          IconButton(
            onPressed: () => GsDatabaseExporter.export(),
            icon: Icon(Icons.save_alt_rounded),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(kSeparator4),
        child: _widgets(context),
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
              HomeWishesSummary(
                title: Lang.of(context).getValue(Labels.charWishes),
                banner: GsBanner.character,
              ),
              HomeWishesValues(
                title: Lang.of(context).getValue(Labels.charWishes),
                banner: GsBanner.character,
              ),
              HomeWishesSummary(
                title: Lang.of(context).getValue(Labels.noviceWishes),
                banner: GsBanner.beginner,
              ),
              HomeWishesValues(
                title: Lang.of(context).getValue(Labels.noviceWishes),
                banner: GsBanner.beginner,
              ),
              HomeBirthdaysWidget(),
            ].separate(SizedBox(height: kSeparator4)).toList(),
          ),
        ),
        SizedBox(width: kSeparator4),
        Expanded(
          child: Column(
            children: <Widget>[
              HomeWishesSummary(
                title: Lang.of(context).getValue(Labels.weaponWishes),
                banner: GsBanner.weapon,
                minPity: 50,
                maxPity: 80,
              ),
              HomeWishesValues(
                title: Lang.of(context).getValue(Labels.weaponWishes),
                banner: GsBanner.weapon,
              ),
              HomeRecipesWidget(),
              HomeSpincrystalsWidget(),
              HomeReputationWidget(),
            ].separate(SizedBox(height: kSeparator4)).toList(),
          ),
        ),
        SizedBox(width: kSeparator4),
        Expanded(
          child: Column(
            children: [
              HomeWishesSummary(
                title: Lang.of(context).getValue(Labels.stndWishes),
                banner: GsBanner.standard,
              ),
              HomeWishesValues(
                title: Lang.of(context).getValue(Labels.stndWishes),
                banner: GsBanner.standard,
              ),
              HomeFriendsWidget(),
              HomeAscensionWidget(),
              HomeResourceCalcWidget(),
            ].separate(SizedBox(height: kSeparator4)).toList(),
          ),
        ),
      ],
    );
  }
}
