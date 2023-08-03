import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/screen_filters/screen_filter.dart';
import 'package:tracker/screens/screen_filters/screen_filter_builder.dart';
import 'package:tracker/screens/wishes_screen/banner_list_item.dart';
import 'package:tracker/screens/wishes_screen/wish_list_item.dart';

class WishesScreen extends StatelessWidget {
  static const id = 'wishes_screen';

  const WishesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final banner = args as GsBanner?;
    return ValueStreamBuilder<bool>(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        if (snapshot.data != true || banner == null) return const SizedBox();

        final ut = GsUtils.wishes;
        final wishes = ut.getSaveWishesByBannerType(banner).sortedDescending();
        final banners = ut.geReleasedInfoBannerByType(banner);

        return ScreenFilterBuilder<SaveWish>(
          filter: ScreenFilters.saveWishFilter,
          builder: (context, filter, button, toggle) {
            return Scaffold(
              appBar: GsAppBar(
                label: context.fromLabel(Labels.wishes),
                bottom: _header(context),
                actions: [
                  Tooltip(
                    message: context.fromLabel(Labels.hideEmptyBanners),
                    child: IconButton(
                      icon: Icon(
                        filter.hasExtra('show')
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      onPressed: () => toggle('show'),
                    ),
                  ),
                  const SizedBox(width: kSeparator2),
                  button,
                ],
              ),
              body: Container(
                decoration: kMainBgDecoration,
                child: CustomScrollView(
                  slivers: _slivers(banner, wishes, banners, filter),
                ),
              ),
            );
          },
        );
      },
    );
  }

  ListType _getListType(List<SaveWish> wishes, int index) {
    late final cWish = wishes.elementAtOrNull(index);
    late final pWish = wishes.elementAtOrNull(index - 1);
    late final nWish = wishes.elementAtOrNull(index + 1);
    if (cWish == null) return ListType.none;

    late final isTop = pWish?.date != cWish.date && nWish?.date == cWish.date;
    late final isMid = pWish?.date == cWish.date && nWish?.date == cWish.date;
    late final isBot = pWish?.date == cWish.date && nWish?.date != cWish.date;
    if (isTop) return ListType.top;
    if (isMid) return ListType.middle;
    if (isBot) return ListType.bottom;
    return ListType.none;
  }

  List<Widget> _slivers(
    GsBanner gsBanner,
    List<SaveWish> wishesList,
    List<InfoBanner> bannersList,
    ScreenFilter<SaveWish> filter,
  ) {
    final banners = bannersList.sortedDescending();
    return banners.map(
      (banner) {
        final bannerWishes = wishesList.where((e) => e.bannerId == banner.id);
        final filteredWishes = filter
            .match(bannerWishes)
            // This keeps the sorting by number inside the banner.
            .sortedByDescending((e) => e.number)
            .thenWith((a, b) => b.compareTo(a));

        final hide = !filter.hasExtra('show');
        final showBanner = !hide || filteredWishes.isNotEmpty;
        return SliverStickyHeader(
          header: showBanner
              ? BannerListItem(banner: banner, rolls: bannerWishes.length)
              : const SizedBox(),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final wish = filteredWishes[index];
                final type = filter.isDefault()
                    ? _getListType(filteredWishes, index)
                    : ListType.none;

                return WishListItem(
                  pity: GsUtils.wishes.countPity(wishesList, wish),
                  bannerType: gsBanner,
                  wishState: gsBanner == GsBanner.character ||
                          gsBanner == GsBanner.weapon
                      ? GsUtils.wishes.getWishState(wishesList, wish)
                      : WishState.none,
                  index: index,
                  wish: wish,
                  type: type,
                );
              },
              childCount: filteredWishes.length,
            ),
          ),
        );
      },
    ).toList();
  }

  PreferredSizeWidget _header(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(44),
      child: SizedBox(
        height: 44,
        child: Row(
          children: getSized(
            [
              Text(
                context.fromLabel(Labels.time),
                textAlign: TextAlign.center,
                style: context.themeStyles.label14n,
              ),
              Text(
                context.fromLabel(Labels.pity),
                textAlign: TextAlign.center,
                style: context.themeStyles.label14n,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 44),
                child: Text(
                  context.fromLabel(Labels.name),
                  textAlign: TextAlign.center,
                  style: context.themeStyles.label14n,
                ),
              ),
              const SizedBox(),
              Text(
                context.fromLabel(Labels.rarity),
                textAlign: TextAlign.center,
                style: context.themeStyles.label14n,
              ),
              Text(
                context.fromLabel(Labels.type),
                textAlign: TextAlign.center,
                style: context.themeStyles.label14n,
              ),
              Text(
                context.fromLabel(Labels.roll),
                textAlign: TextAlign.center,
                style: context.themeStyles.label14n,
              ),
            ].map((widget) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Center(child: widget),
              );
            }),
          ),
        ),
      ),
    );
  }
}
