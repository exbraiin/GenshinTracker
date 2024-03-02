import 'package:cached_network_image/cached_network_image.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_no_results_state.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/achievements_screen/achievement_list_item.dart';
import 'package:tracker/screens/screen_filters/screen_filter_builder.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';

class AchievementGroupsScreen extends StatefulWidget {
  static const id = 'achievement_groups_screen';

  const AchievementGroupsScreen({super.key});

  @override
  State<AchievementGroupsScreen> createState() =>
      _AchievementGroupsScreenState();
}

class _AchievementGroupsScreenState extends State<AchievementGroupsScreen> {
  late final ValueNotifier<String> queryNotifier;
  late final ValueNotifier<GsAchievementGroup?> groupNotifier;

  @override
  void initState() {
    super.initState();
    queryNotifier = ValueNotifier('');
    groupNotifier = ValueNotifier(null);
  }

  @override
  void dispose() {
    queryNotifier.dispose();
    groupNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFilterBuilder<GsAchievement>(
      builder: (context, filter, button, toggle) {
        return ValueListenableBuilder(
          valueListenable: queryNotifier,
          builder: (context, query, child) {
            return ValueStreamBuilder<bool>(
              stream: Database.instance.loaded,
              builder: (context, snapshot) {
                if (snapshot.data != true) return const SizedBox();
                final data = Database.instance.infoOf<GsAchievementGroup>();
                final groups = data.items.toList();
                final total = GsUtils.achievements.countTotal();
                final saved = GsUtils.achievements.countSaved();

                final title = context.fromLabel(Labels.achievements);
                return InventoryPage(
                  appBar: InventoryAppBar(
                    iconAsset: menuIconAchievements,
                    label: '$title  ($saved/$total)',
                    actions: [button],
                  ),
                  child: groups.isEmpty
                      ? const GsNoResultsState()
                      : _getAchievementsBody(filter, groups, query),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _getAchievementsBody(
    ScreenFilter<GsAchievement> filter,
    List<GsAchievementGroup> groups,
    String query,
  ) {
    groupNotifier.value ??= groups.first;
    return ValueListenableBuilder(
      valueListenable: groupNotifier,
      builder: (context, item, child) {
        final data = Database.instance.infoOf<GsAchievement>();
        final aList = filter
            .match(
              data.items.where((e) => e.group == item!.id).where(
                    (element) => element.name.toLowerCase().contains(query),
                  ),
            )
            .sorted();
        return Row(
          children: [
            Expanded(
              flex: 2,
              child: _getGroupsList(groups),
            ),
            const SizedBox(width: kGridSeparator),
            Expanded(
              flex: 5,
              child: InventoryBox(
                child: _getAchievementsList(item!, aList),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _getGroupsList(List<GsAchievementGroup> list) {
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
              onChanged: (value) => queryNotifier.value = value,
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
                  groupNotifier.value == item,
                  () => groupNotifier.value = item,
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
    GsAchievementGroup group,
    List<GsAchievement> list,
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
    GsAchievementGroup item,
    bool selected,
    VoidCallback? select,
  ) {
    final saved = GsUtils.achievements.countSaved((e) => e.group == item.id);
    final total = GsUtils.achievements.countTotal((e) => e.group == item.id);
    final percentage = saved / total.coerceAtLeast(1);
    final namecards = Database.instance.infoOf<GsNamecard>();
    final namecard = namecards.getItem(item.namecard);
    return AnimatedContainer(
      height: 86,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      padding:
          const EdgeInsets.all(kSeparator4).copyWith(right: kSeparator8 * 2),
      decoration: BoxDecoration(
        color: selected ? context.themeColors.mainColor1 : Colors.transparent,
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
                  Expanded(
                    child: Text(
                      item.name,
                      style: context.themeStyles.label14n,
                    ),
                  ),
                  const SizedBox(height: kSeparator6),
                  Text(
                    '${(percentage * 100).toInt()}% ($saved/$total)',
                    style: context.themeStyles.label12n.copyWith(
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
