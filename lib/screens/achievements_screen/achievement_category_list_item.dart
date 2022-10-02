import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/common/widgets/item_card_button.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_database.test.dart';
import 'package:tracker/screens/achievements_screen/achievements_list_screen.dart';

class AchievementCategoryListItem extends StatelessWidget {
  final AchievementCategory group;

  AchievementCategoryListItem(this.group);

  @override
  Widget build(BuildContext context) {
    final owned = GsDatabase.instance.saveAchievements.owned(group);
    return ItemCardButton(
      label: group.name,
      onTap: () => Navigator.of(context).pushNamed(
        AchievementsListScreen.id,
        arguments: group,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 24,
          margin: EdgeInsets.all(2),
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: GsColors.mainColor0.withOpacity(0.6),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Align(
            widthFactor: 1,
            child: Text(
              '$owned / ${group.total}',
              style: context.textTheme.cardLabel,
            ),
          ),
        ),
      ),
    );
  }
}
