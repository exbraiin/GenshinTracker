import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_database.test.dart';
import 'package:tracker/screens/achievements_screen/achievement_group_list_item.dart';

class AchievementsListScreen extends StatelessWidget {
  static const id = 'achievements_list_screen';

  AchievementsListScreen();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final group = args as AchievementCategory?;
    return ValueStreamBuilder<bool>(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        if (!snapshot.data! || group == null) return SizedBox();
        final owned = GsDatabase.instance.saveAchievements.owned(group);
        return Scaffold(
          appBar: GsAppBar(
            label: group.name + ' ($owned/${group.total})',
          ),
          body: ListView.separated(
            padding: EdgeInsets.all(kSeparator4),
            itemCount: group.groups.length,
            itemBuilder: (context, index) =>
                AchievementGroupListItem(group.groups[index]),
            separatorBuilder: (context, index) => SizedBox(height: kSeparator2),
          ),
        );
      },
    );
  }
}
