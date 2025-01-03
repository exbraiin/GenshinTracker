import 'package:dartx/dartx_io.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';
import 'package:tracker/common/widgets/static/swap_widget.dart';
import 'package:tracker/domain/enums/enum_ext.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/widgets/item_info_widget.dart';

class HomeCalendarWidget extends StatelessWidget {
  const HomeCalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GsDataBox.info(
      title: const Text('Calendar'),
      child: Column(
        children: [
          Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(children: _getItems(context).toList()),
            ),
          ),
          // const SizedBox(height: kSeparator8),
          // const EventsScrollView(),
        ],
      ),
    );
  }

  Iterable<Widget> _getItems(BuildContext context) sync* {
    final now = DateTime.now().date;
    final weekday = now.firstDayOfMonth.weekday;
    const week = [
      DateTime.monday,
      DateTime.tuesday,
      DateTime.wednesday,
      DateTime.thursday,
      DateTime.friday,
      DateTime.saturday,
      DateTime.sunday,
    ];

    final itemSize = ItemSize.medium.gridSize;
    yield Row(
      mainAxisSize: MainAxisSize.min,
      children: week
          .map<Widget>((i) {
            return Container(
              width: itemSize,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: kGridSeparator),
              decoration: BoxDecoration(
                borderRadius: kListRadius,
                color: context.themeColors.mainColor1,
              ),
              child: Text(
                DateLabels.humanizedWeekday(context, i).substring(0, 3),
                style: context.themeStyles.label14n,
                strutStyle: context.themeStyles.label14n.toStrut(),
              ),
            );
          })
          .separate(const SizedBox(width: kGridSeparator))
          .toList(),
    );
    final weeks = (now.daysInMonth / DateTime.daysPerWeek).ceil();

    final src = now.firstDayOfMonth
        .subtract(const Duration(days: DateTime.daysPerWeek));
    final characters = Database.instance
        .infoOf<GsCharacter>()
        .items
        .where((e) => e.birthday.copyWith(year: now.year).isAfter(src));
    final versions = Database.instance
        .infoOf<GsVersion>()
        .items
        .where((e) => e.releaseDate.isAfter(src));

    yield* Iterable<Widget>.generate(
      weeks,
      (w) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(
          DateTime.daysPerWeek,
          (d) {
            final idx = w * DateTime.daysPerWeek + d - weekday + 1;
            final date = DateTime(now.year, now.month, idx + 1);

            late final birthdayItems = characters.where(
              (e) => e.birthday.copyWith(year: date.year).isAtSameDayAs(date),
            );

            late final versionItem = versions
                .firstOrNullWhere((e) => e.releaseDate.isAtSameDayAs(date));

            final showVersion = versionItem != null;
            final showBirthday = birthdayItems.isNotEmpty;

            final bannersInfo = Database.instance
                .infoOf<GsBanner>()
                .items
                .where((e) => e.type == GeBannerType.character)
                .where((e) => date.between(e.dateStart, e.dateEnd))
                .groupBy((e) => e.dateStart)
                .values
                .map((list) => _BannerInfo.from(list, date));

            final battlepassInfo = Database.instance
                .infoOf<GsBattlepass>()
                .items
                .where((e) => date.between(e.dateStart, e.dateEnd));

            final message = showBirthday
                ? birthdayItems.map((e) => e.name).join(' | ')
                : '';

            return Opacity(
              opacity: date.isAtSameMonthAs(now) ? 1 : kDisableOpacity,
              child: Container(
                width: itemSize,
                height: itemSize,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: kGridRadius,
                  color: context.themeColors.mainColor1,
                ),
                foregroundDecoration: now.isAtSameDayAs(date)
                    ? BoxDecoration(
                        borderRadius: kGridRadius,
                        border: Border.all(
                          color: context.themeColors.almostWhite,
                          width: 2,
                        ),
                      )
                    : null,
                child: Tooltip(
                  message: message,
                  child: Stack(
                    children: [
                      if (showBirthday)
                        ...birthdayItems.mapIndexed((i, e) {
                          return Positioned.fill(
                            child: ClipRect(
                              clipper: _RectClipperBuilder(
                                (size) => Rect.fromLTWH(
                                  i * size.width / birthdayItems.length,
                                  0,
                                  size.width / birthdayItems.length,
                                  size.height,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      GsAssets.getRarityBgImage(e.rarity),
                                    ),
                                  ),
                                ),
                                child: CachedImageWidget(e.image),
                              ),
                            ),
                          );
                        }),
                      ...battlepassInfo.map((i) {
                        final src = i.dateStart.isAtSameDayAs(date);
                        final end = i.dateEnd.isAtSameDayAs(date);
                        final msg = i.name;
                        return Positioned.fill(
                          top: null,
                          left: src ? itemSize / 2 + 4 : 0,
                          right: end ? itemSize / 2 + 4 : 0,
                          bottom: 4,
                          child: _ImagesTooltip(
                            images: [i.image],
                            message: msg,
                            size: const Size(150, 54),
                            child: Container(
                              height: 4,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.cyan,
                                borderRadius: BorderRadius.horizontal(
                                  left: src
                                      ? const Radius.circular(8)
                                      : Radius.zero,
                                  right: end
                                      ? const Radius.circular(8)
                                      : Radius.zero,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      ...bannersInfo.map((i) {
                        return Positioned.fill(
                          top: null,
                          left: i.src ? itemSize / 2 + 4 : 0,
                          right: i.end ? itemSize / 2 + 4 : 0,
                          child: _ImagesTooltip(
                            images: i.banners.map((e) => e.image),
                            message: i.message,
                            child: Container(
                              height: 4,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: i.color,
                                borderRadius: BorderRadius.horizontal(
                                  left: i.src
                                      ? const Radius.circular(8)
                                      : Radius.zero,
                                  right: i.end
                                      ? const Radius.circular(8)
                                      : Radius.zero,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Icon(
                          showBirthday ? Icons.cake_rounded : null,
                          size: 20,
                          color: context.themeColors.almostWhite,
                          shadows: const [
                            BoxShadow(
                              offset: Offset(1, 1),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                      ),
                      if (showVersion)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Transform.translate(
                            offset: const Offset(12, 12),
                            child: Banner(
                              message: versionItem.id,
                              color: context.themeColors.primary80,
                              location: BannerLocation.bottomEnd,
                            ),
                          ),
                        ),
                      Container(
                        width: 20,
                        height: 20,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(kSeparator2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              context.themeColors.mainColor0.withOpacity(0.4),
                          border: Border.all(
                            color: context.themeColors.mainColor1,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          date.day.toString(),
                          style: context.themeStyles.label12n,
                          strutStyle: context.themeStyles.label12n.toStrut(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ).separate(const SizedBox(width: kGridSeparator)).toList(),
      ),
    ).separate(const SizedBox(height: kGridSeparator));
  }
}

class _RectClipperBuilder extends CustomClipper<Rect> {
  final Rect Function(Size size) clipper;

  const _RectClipperBuilder(this.clipper);

  @override
  Rect getClip(Size size) {
    return clipper(size);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return false;
  }
}

class _BannerInfo {
  final bool src, end;
  final Color color;
  final Iterable<GsBanner> banners;

  String get message => banners.map((e) => e.name).join('\n');

  _BannerInfo(this.banners, this.color, {this.src = false, this.end = false});

  factory _BannerInfo.from(Iterable<GsBanner> banners, DateTime date) {
    final banner = banners.first;
    final db = Database.instance.infoOf<GsCharacter>();
    final color = banners
        .map((e) => db.getItem(e.feature5.firstOrNull ?? ''))
        .whereNotNull()
        .map((e) => e.element.color)
        .fold(Colors.white, (p, e) => Color.lerp(p, e, 0.5)!);

    final isSrc = date.isAtSameDayAs(banner.dateStart);
    if (isSrc) return _BannerInfo(banners, color, src: true);

    final isEnd = date.isAtSameDayAs(banner.dateEnd);
    if (isEnd) return _BannerInfo(banners, color, end: true);

    return _BannerInfo(banners, color);
  }
}

class _ImagesTooltip extends StatelessWidget {
  final Size size;
  final Widget child;
  final String? message;
  final Iterable<String> images;

  const _ImagesTooltip({
    this.message,
    this.size = const Size(150, 85),
    required this.images,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final image0 = images.elementAtOrNull(0);
    final image1 = images.elementAtOrNull(1);
    return Tooltip(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: context.themeColors.almostWhite,
        borderRadius: BorderRadius.circular(kSeparator4),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 62, 59, 59),
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      richMessage: WidgetSpan(
        child: Container(
          width: size.width,
          height: size.height,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kSeparator4),
          ),
          child: Stack(
            children: [
              if (image0 != null && image1 == null)
                Positioned.fill(
                  bottom: null,
                  child: CachedImageWidget(image0, fit: BoxFit.fitWidth),
                ),
              if (image0 != null && image1 != null)
                Positioned.fill(
                  child: SwapWidgets(
                    child0: CachedImageWidget(image0, fit: BoxFit.cover),
                    child1: CachedImageWidget(image1, fit: BoxFit.cover),
                  ),
                ),
              if (message != null)
                Positioned.fill(
                  top: null,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(6, 4, 6, 2),
                    color: Colors.white54,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        message!,
                        style: TooltipTheme.of(context).textStyle,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      child: child,
    );
  }
}
