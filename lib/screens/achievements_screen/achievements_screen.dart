import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/gs_no_results_state.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/achievements_screen/achievement_list_item.dart';
import 'package:tracker/screens/screen_filters/screen_filter.dart';
import 'package:tracker/screens/screen_filters/screen_filter_builder.dart';

class AchievementsScreen extends StatelessWidget {
  static const id = 'achievements_screen';

  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final item = args! as InfoAchievementGroup;

    return ScreenFilterBuilder<InfoAchievement>(
      filter: ScreenFilters.infoAchievement,
      builder: (context, filter, button, toggle) {
        return ValueStreamBuilder<bool>(
          stream: GsDatabase.instance.loaded,
          builder: (context, snapshot) {
            if (snapshot.data != true) return const SizedBox();
            final utils = GsUtils.saveAchievements;
            final saved = utils.countSaved((e) => e.group == item.id);
            final total = utils.countTotal((e) => e.group == item.id);
            final data = GsDatabase.instance.infoAchievements;
            final list =
                filter.match(data.getItems().where((e) => e.group == item.id));
            return Scaffold(
              appBar: GsAppBar(
                label: '${item.name}  ($saved / $total)',
                actions: [button],
              ),
              body: Container(
                decoration: kMainBgDecoration,
                child: list.isEmpty
                    ? const GsNoResultsState()
                    : ListView.separated(
                        padding: const EdgeInsets.all(kSeparator4),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final phases = list[index];
                          return AchievementListItem(phases);
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: kSeparator4),
                      ),
              ),
            );
          },
        );
      },
    );
  }
}
