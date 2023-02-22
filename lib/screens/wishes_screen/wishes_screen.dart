import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:tracker/common/extensions/extensions.dart';
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

        final db = GsDatabase.instance;
        final sw = db.saveWishes;
        final wishes = sw.getSaveWishesByBannerType(banner).sortedDescending();
        final banners = GsUtils.wishes.geReleasedInfoBannerByType(banner);

        return ScreenFilterBuilder<SaveWish>(
          filter: ScreenFilters.saveWishFilter,
          builder: (context, filter, button, toggle) {
            return Scaffold(
              appBar: GsAppBar(
                label: Lang.of(context).getValue(Labels.wishes),
                bottom: _header(context),
                actions: [
                  Tooltip(
                    message: Lang.of(context).getValue(Labels.hideEmptyBanners),
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

  ListType _getListType(List<SaveWish> filteredWishes, int index) {
    final wish = filteredWishes[index];
    final p = filteredWishes.elementAtOrNull(index - 1);
    final n = filteredWishes.elementAtOrNull(index + 1);

    late final isTop = p?.date != wish.date && n?.date == wish.date;
    late final isMid = p?.date == wish.date && n?.date == wish.date;
    late final isBot = p?.date == wish.date && n?.date != wish.date;
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
        final filteredWishes = filter.match(bannerWishes).sortedDescending();

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
                  wishState: gsBanner == GsBanner.character
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
                Lang.of(context).getValue(Labels.time),
                textAlign: TextAlign.center,
                style: context.textTheme.headerButtonLabel,
              ),
              Text(
                Lang.of(context).getValue(Labels.pity),
                textAlign: TextAlign.center,
                style: context.textTheme.headerButtonLabel,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 44),
                child: Text(
                  Lang.of(context).getValue(Labels.name),
                  textAlign: TextAlign.center,
                  style: context.textTheme.headerButtonLabel,
                ),
              ),
              const SizedBox(),
              Text(
                Lang.of(context).getValue(Labels.rarity),
                textAlign: TextAlign.center,
                style: context.textTheme.headerButtonLabel,
              ),
              Text(
                Lang.of(context).getValue(Labels.type),
                textAlign: TextAlign.center,
                style: context.textTheme.headerButtonLabel,
              ),
              Text(
                Lang.of(context).getValue(Labels.roll),
                textAlign: TextAlign.center,
                style: context.textTheme.headerButtonLabel,
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
