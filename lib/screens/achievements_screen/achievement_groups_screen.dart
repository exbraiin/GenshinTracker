import 'package:cached_network_image/cached_network_image.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_no_results_state.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/common/widgets/value_notifier_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/achievements_screen/achievement_list_item.dart';
import 'package:tracker/screens/screen_filters/screen_filter.dart';
import 'package:tracker/screens/screen_filters/screen_filter_builder.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';

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
            final total = GsUtils.achievements.countTotal();
            final saved = GsUtils.achievements.countSaved();

            final title = context.fromLabel(Labels.achievements);
            return InventoryPage(
              appBar: InventoryAppBar(
                iconAsset: menuIconAchievements,
                label: '$title  ($saved/$total)',
                actions: [button],
              ),
              child: ValueNotifierBuilder<String>(
                value: '',
                builder: (context, sNotifier, child) {
                  if (gList.isEmpty) return const GsNoResultsState();
                  return ValueNotifierBuilder<InfoAchievementGroup>(
                    value: gList.first,
                    builder: (context, notifier, child) {
                      final item = notifier.value;
                      final data = GsDatabase.instance.infoAchievements;
                      final aList = filter.match(
                        data.getItems().where((e) => e.group == item.id).where(
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
                              context,
                              gList,
                              notifier,
                              sNotifier,
                            ),
                          ),
                          const SizedBox(width: kGridSeparator),
                          Expanded(
                            flex: 5,
                            child: InventoryBox(
                              child: _getAchievementsList(item, aList),
                            ),
                          ),
                        ],
                      );
                    },
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
    BuildContext context,
    List<InfoAchievementGroup> list,
    ValueNotifier<InfoAchievementGroup> notifier,
    ValueNotifier<String> sNotifier,
  ) {
    return Column(
      children: [
        InventoryBox(
          child: Container(
            height: 36,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(
              vertical: kSeparator4,
              horizontal: kSeparator8,
            ).copyWith(top: 8),
            child: TextField(
              style: const TextStyle(fontSize: 16),
              maxLines: 1,
              decoration: InputDecoration.collapsed(
                hintText: context.fromLabel(Labels.hintSearch),
              ),
              onChanged: (value) => sNotifier.value = value,
            ),
          ),
        ),
        const SizedBox(height: kGridSeparator),
        Expanded(
          child: InventoryBox(
            child: ListView.separated(
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
                  const SizedBox(height: kGridSeparator),
            ),
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
      itemCount: list.length,
      itemBuilder: (context, index) => AchievementListItem(list[index]),
      separatorBuilder: (context, index) =>
          const SizedBox(height: kListSeparator),
    );
  }

  Widget _buildItem(
    BuildContext context,
    InfoAchievementGroup item,
    bool selected,
    VoidCallback? select,
  ) {
    final saved = GsUtils.achievements.countSaved((e) => e.group == item.id);
    final total = GsUtils.achievements.countTotal((e) => e.group == item.id);
    final percentage = saved / total.coerceAtLeast(1);
    final namecards = GsDatabase.instance.infoNamecards;
    final namecard = namecards.getItemOrNull(item.namecard);
    return AnimatedContainer(
      height: 86,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      padding:
          const EdgeInsets.all(kSeparator4).copyWith(right: kSeparator8 * 2),
      decoration: BoxDecoration(
        color: selected ? context.themeColors.mainColor2 : Colors.transparent,
        image: namecard != null
            ? DecorationImage(
                fit: BoxFit.cover,
                opacity: 0.4,
                alignment: Alignment.centerRight,
                image: CachedNetworkImageProvider(namecard.fullImage),
              )
            : DecorationImage(
                fit: BoxFit.cover,
                opacity: 0.2,
                alignment: Alignment.centerRight,
                image: AssetImage(getRarityBgImage(1)),
              ),
        borderRadius: kGridRadius,
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: kGridRadius,
        border: Border.all(
          color: selected
              ? context.themeColors.almostWhite.withOpacity(0.4)
              : Colors.transparent,
        ),
      ),
      child: InkWell(
        onTap: select,
        child: Row(
          children: [
            SizedBox(
              width: 82,
              child: CachedImageWidget(item.icon),
            ),
            const SizedBox(width: kSeparator8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: context.textTheme.titleMedium,
                  ),
                  const SizedBox(height: kSeparator6),
                  Text(
                    '${(percentage * 100).toInt()}% ($saved/$total)',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: context.themeColors.dimWhite,
                    ),
                  ),
                  const SizedBox(height: kSeparator6),
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
