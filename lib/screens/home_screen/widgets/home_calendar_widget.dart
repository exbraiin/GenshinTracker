import 'package:dartx/dartx_io.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/models/model_ext.dart';
import 'package:tracker/screens/widgets/item_info_widget.dart';

class HomeCalendarWidget extends StatelessWidget {
  const HomeCalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GsDataBox.info(
      title: const Text('Calendar'),
      child: Center(child: Column(children: _getItems(context).toList())),
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
                context.fromLabel('weekday_$i').substring(0, 3),
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
    final banners = Database.instance.infoOf<GsBanner>().items.where(
          (e) =>
              e.type == GeBannerType.character && e.dateStartTime.isAfter(src),
        );
    final characters = Database.instance
        .infoOf<GsCharacter>()
        .items
        .where((e) => e.birthdayTime.copyWith(year: now.year).isAfter(src));
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

            late final bannerItems = banners
                .where((e) => e.dateStartTime.isAtSameDayAs(date))
                .expand((e) => e.feature5)
                .map(GsUtils.items.getItemDataOrNull)
                .whereNotNull();

            late final birthdayItems = characters.where(
              (e) =>
                  e.birthdayTime.copyWith(year: date.year).isAtSameDayAs(date),
            );

            late final versionItem = versions
                .firstOrNullWhere((e) => e.releaseDate.isAtSameDayAs(date));

            final showVersion = versionItem != null;
            final showBanner = bannerItems.isNotEmpty;
            final showBirthday = !showBanner && birthdayItems.isNotEmpty;

            final message = showBanner
                ? bannerItems.map((e) => e.name).join(' | ')
                : showBirthday
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
                      if (showBanner)
                        ...bannerItems.mapIndexed((i, e) {
                          return Positioned.fill(
                            child: ClipRect(
                              clipper: _RectClipperBuilder(
                                (size) => Rect.fromLTWH(
                                  i * size.width / bannerItems.length,
                                  0,
                                  size.width / bannerItems.length,
                                  size.height,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        AssetImage(getRarityBgImage(e.rarity)),
                                  ),
                                ),
                                child: CachedImageWidget(e.image),
                              ),
                            ),
                          );
                        }),
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
                                    image:
                                        AssetImage(getRarityBgImage(e.rarity)),
                                  ),
                                ),
                                child: CachedImageWidget(e.image),
                              ),
                            ),
                          );
                        }),
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Icon(
                          showBanner
                              ? Icons.star_rounded
                              : showBirthday
                                  ? Icons.cake_rounded
                                  : null,
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
