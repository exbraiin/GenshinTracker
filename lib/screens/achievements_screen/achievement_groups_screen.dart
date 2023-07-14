import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/gs_grid_view.dart';
import 'package:tracker/common/widgets/gs_no_results_state.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/achievements_screen/achievement_group_list_item.dart';
import 'package:tracker/screens/achievements_screen/achievements_screen.dart';

class AchievementGroupsScreen extends StatelessWidget {
  static const id = 'achievement_groups_screen';

  const AchievementGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder<bool>(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        if (snapshot.data != true) return const SizedBox();
        final data = GsDatabase.instance.infoAchievementGroups;
        final list = data.getItems().toList();
        final saved = GsUtils.saveAchievements.countSaved();
        final total = GsUtils.saveAchievements.countTotal();
        return Scaffold(
          appBar: GsAppBar(
            label: '${context.fromLabel(Labels.achievements)}  ($saved/$total)',
          ),
          body: Container(
            decoration: kMainBgDecoration,
            child: list.isEmpty
                ? const GsNoResultsState()
                : GsGridView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final item = list[index];
                      return AchievementGroupListItem(
                        item,
                        onTap: () => Navigator.of(context)
                            .pushNamed(AchievementsScreen.id, arguments: item),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
