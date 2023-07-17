import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/gs_no_results_state.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/common/widgets/value_notifier_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/achievements_screen/achievement_list_item.dart';
import 'package:tracker/screens/screen_filters/screen_filter.dart';
import 'package:tracker/screens/screen_filters/screen_filter_builder.dart';

class AchievementGroupsScreen extends StatelessWidget {
  static const id = 'achievement_groups_screen';

  const AchievementGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenFilterBuilder<InfoAchievement>(
      filter: ScreenFilters.infoAchievement,
      builder: (context, filter, button, toggle) {
        return ValueStreamBuilder<bool>(
          stream: GsDatabase.instance.loaded,
          builder: (context, snapshot) {
            if (snapshot.data != true) return const SizedBox();
            final data = GsDatabase.instance.infoAchievementGroups;
            final gList = data.getItems().toList();
            final saved = GsUtils.saveAchievements.countSaved();
            final total = GsUtils.saveAchievements.countTotal();
            return Scaffold(
              appBar: GsAppBar(
                label:
                    '${context.fromLabel(Labels.achievements)}  ($saved/$total)',
                actions: [button],
              ),
              body: ValueNotifierBuilder<String>(
                value: '',
                builder: (context, sNotifier, child) {
                  return Container(
                    decoration: kMainBgDecoration,
                    child: gList.isEmpty
                        ? const GsNoResultsState()
                        : ValueNotifierBuilder<InfoAchievementGroup>(
                            value: gList.first,
                            builder: (context, notifier, child) {
                              final item = notifier.value;
                              final data = GsDatabase.instance.infoAchievements;
                              final aList = filter.match(
                                data
                                    .getItems()
                                    .where((e) => e.group == item.id)
                                    .where(
                                      (element) => element.name
                                          .toLowerCase()
                                          .contains(sNotifier.value),
                                    ),
                              );
                              return Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: _getGroupsList(
                                      gList,
                                      notifier,
                                      sNotifier,
                                    ),
                                  ),
                                  const VerticalDivider(width: 1),
                                  Expanded(
                                    flex: 5,
                                    child: _getAchievementsList(item, aList),
                                  ),
                                ],
                              );
                            },
                          ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _getGroupsList(
    List<InfoAchievementGroup> list,
    ValueNotifier<InfoAchievementGroup> notifier,
    ValueNotifier<String> sNotifier,
  ) {
    return Column(
      children: [
        Container(
          height: 50,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(kSeparator4),
          child: TextField(
            style: const TextStyle(fontSize: 16),
            maxLines: 1,
            decoration: const InputDecoration.collapsed(hintText: 'Search'),
            onChanged: (value) => sNotifier.value = value,
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(4),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              return _buildItem(
                context,
                item,
                notifier.value == item,
                () => notifier.value = item,
              );
            },
            separatorBuilder: (context, index) =>
                const SizedBox(height: kSeparator4),
          ),
        ),
      ],
    );
  }

  Widget _getAchievementsList(
    InfoAchievementGroup group,
    List<InfoAchievement> list,
  ) {
    if (list.isEmpty) return const GsNoResultsState();
    return ListView.separated(
      key: ValueKey(list.length),
      padding: const EdgeInsets.all(kSeparator4),
      itemCount: list.length,
      itemBuilder: (context, index) => AchievementListItem(list[index]),
      separatorBuilder: (context, index) => const SizedBox(height: kSeparator4),
    );
  }

  Widget _buildItem(
    BuildContext context,
    InfoAchievementGroup item,
    bool selected,
    VoidCallback? select,
  ) {
    final utils = GsUtils.saveAchievements;
    final saved = utils.countSaved((e) => e.group == item.id);
    final total = utils.countTotal((e) => e.group == item.id);
    final percentage = saved / total.coerceAtLeast(1);
    return AnimatedContainer(
      height: 100,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: selected
            ? context.themeColors.mainColor2
            : context.themeColors.mainColor0,
        image: DecorationImage(
          fit: BoxFit.cover,
          opacity: 0.23,
          alignment: Alignment.centerRight,
          image: AssetImage(getRarityBgImage(1)),
        ),
        border: Border.all(
          color: const Color(0xFF626d83),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: select,
        child: Row(
          children: [
            Image.network(item.icon),
            const SizedBox(width: kSeparator4),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: context.textTheme.titleMedium,
                  ),
                  const SizedBox(height: kSeparator4),
                  Text(
                    '${(percentage * 100).toInt()}% ($saved/$total)',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: context.themeColors.dimWhite,
                    ),
                  ),
                  const SizedBox(height: kSeparator4),
                  _progressBar(percentage),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressBar(double percentage) {
    return Container(
      height: 4,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF626d83),
        borderRadius: BorderRadius.circular(4),
      ),
      child: AnimatedFractionallySizedBox(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        widthFactor: percentage,
        alignment: Alignment.centerLeft,
        child: Container(
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFFd8c090),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
