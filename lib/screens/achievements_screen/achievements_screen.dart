import 'package:flutter/material.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/gs_grid_view.dart';
import 'package:tracker/common/widgets/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/achievements_screen/achievement_category_list_item.dart';

class AchievementsScreen extends StatelessWidget {
  static const id = 'achievements_screen';

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder<bool>(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        if (!snapshot.data!) return SizedBox();
        final info = GsDatabase.instance.infoAchievements;
        final save = GsDatabase.instance.saveAchievements;
        final achievements = info.getItems().toList();
        return Scaffold(
          appBar: GsAppBar(
            label: Lang.of(context).getValue(Labels.achievements) +
                ' (${save.total}/${info.total})',
          ),
          body: GsGridView.builder(
            itemCount: achievements.length,
            itemBuilder: (context, index) =>
                AchievementCategoryListItem(achievements[index]),
          ),
        );
      },
    );
  }
}
