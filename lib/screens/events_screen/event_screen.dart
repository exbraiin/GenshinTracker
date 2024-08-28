import 'package:dartx/dartx_io.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_no_results_state.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/events_screen/event_details_card.dart';
import 'package:tracker/screens/events_screen/event_list_item.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';

class EventScreen extends StatelessWidget {
  static const id = 'events_screen';

  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InventoryListPage<GsEvent>(
      icon: menuIconEvent,
      sortOrder: SortOrder.descending,
      childSize: const Size(126 * 2 + 6, 160),
      title: context.fromLabel(Labels.recipeEvent),
      items: (db) => db.infoOf<GsEvent>().items,
      itemBuilder: (context, state) => EventListItem(
        state.item,
        onTap: state.onSelect,
        selected: state.selected,
      ),
      itemCardBuilder: (context, item) => EventDetailsCard(item),
      // itemCardFooter: const EventsScrollView(),
    );
  }
}

class EventsScrollView extends StatelessWidget {
  const EventsScrollView({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().date;
    final events = Database.instance
        .infoOf<GsEvent>()
        .items
        .where((e) => e.dateEnd.difference(e.dateStart).inDays < 60)
        .where(
          (e) =>
              now.difference(e.dateStart).inDays.abs() < 5 ||
              now.difference(e.dateEnd).inDays.abs() < 5 ||
              now.between(e.dateStart, e.dateEnd),
        )
        .sorted();

    if (events.isEmpty) {
      return const GsNoResultsState.xSmall();
    }

    final rows = <List<GsEvent>>[];
    for (final event in events) {
      var added = false;
      for (final row in rows) {
        if (row.last.dateEnd.isBefore(event.dateStart) ||
            row.last.dateEnd.isAtSameDayAs(event.dateStart)) {
          row.add(event);
          added = true;
          break;
        }
      }
      if (!added) rows.add([event]);
    }

    const daySize = 24.0;
    final src = events.minBy((e) => e.dateStart)!.dateStart;
    final dst = events.maxBy((e) => e.dateEnd)!.dateEnd;
    final totalDays = dst.difference(src).inDays.abs() + 1;
    final end = src.add(Duration(days: totalDays));
    final dates = events.expand((e) => [e.dateStart, e.dateEnd]).toSet()
      ..add(end);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: daySize / 2),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: daySize + kGridSeparator),
              ...rows.map<Widget>((e) {
                return Stack(
                  children: e.map((e) {
                    final offset = src.difference(e.dateStart).inDays.abs();
                    final days = e.dateStart.difference(e.dateEnd).inDays.abs();
                    return Container(
                      height: daySize,
                      width: days * daySize - 8,
                      margin: EdgeInsets.only(left: daySize * offset + 4),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: context.themeColors.getRarityColor(
                          e.type == GeEventType.flagship ? 5 : 4,
                        ),
                        borderRadius: BorderRadius.circular(daySize),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            right: null,
                            child: SizedBox(
                              width: 200,
                              child: Opacity(
                                opacity: kDisableOpacity * 2,
                                child: ShaderMask(
                                  shaderCallback: (rect) {
                                    return LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Colors.black.withOpacity(0),
                                        Colors.black,
                                      ],
                                      stops: const [0, 0.8],
                                    ).createShader(rect);
                                  },
                                  blendMode: BlendMode.dstOut,
                                  child: CachedImageWidget(
                                    e.image,
                                    fit: BoxFit.cover,
                                    alignment: Alignment.centerLeft,
                                    showPlaceholder: false,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: kSeparator8,
                              vertical: kSeparator2,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      e.name,
                                      maxLines: 2,
                                      style: context.themeStyles.label14n
                                          .copyWith(shadows: kMainShadow),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: kSeparator6),
                                Text(
                                  e.dateEnd
                                      .difference(now)
                                      .endOrEndedIn(context),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }).separate(const SizedBox(height: kGridSeparator)),
            ],
          ),
          Row(
            children: List.generate(totalDays, (days) {
              final date = src.add(Duration(days: days, hours: 2)).date;
              final show = date.isAtSameDayAs(now) || dates.contains(date);
              return Transform.translate(
                offset: const Offset(-daySize / 2, 0),
                child: !show
                    ? const SizedBox(width: daySize)
                    : Container(
                        width: daySize,
                        height: daySize +
                            rows.length * daySize +
                            rows.length * kGridSeparator,
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Container(
                              height: daySize,
                              alignment: Alignment.center,
                              decoration: date.isAtSameDayAs(now)
                                  ? BoxDecoration(
                                      color: context.themeColors.primary80,
                                      shape: BoxShape.circle,
                                    )
                                  : null,
                              child: Text(
                                date.day.toString().padLeft(2, '0'),
                                style: context.themeStyles.label12n,
                              ),
                            ),
                            Expanded(
                              child: VerticalDivider(
                                color: context.themeColors.almostWhite
                                    .withOpacity(kDisableOpacity),
                              ),
                            ),
                          ],
                        ),
                      ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
