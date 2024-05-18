import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/screen_filters/screen_filter_builder.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';
import 'package:tracker/screens/wishes_screen/banner_list_item.dart';
import 'package:tracker/screens/wishes_screen/widgets/wish_list_info_widget.dart';
import 'package:tracker/screens/wishes_screen/wish_list_item.dart';

const _bannerType = [
  GeBannerType.character,
  GeBannerType.weapon,
  GeBannerType.chronicled,
  GeBannerType.standard,
  GeBannerType.beginner,
];

class WishesScreen extends StatefulWidget {
  static const id = 'wishes_screen';

  const WishesScreen({super.key});
  @override
  State<WishesScreen> createState() => _WishesScreenScreenState();
}

class _WishesScreenScreenState extends State<WishesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: _bannerType.length, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder(
      stream: Database.instance.loaded,
      builder: (context, snapshot) {
        if (snapshot.data != true) return const SizedBox();

        return ScreenFilterBuilder<GiWish>(
          builder: (context, filter, button, toggle) {
            PreferredSizeWidget appBar = InventoryAppBar(
              iconAsset: menuIconWish,
              label: context.fromLabel(Labels.wishes),
              actions: [
                Tooltip(
                  message: context.fromLabel(Labels.hideEmptyBanners),
                  child: IconButton(
                    icon: Icon(
                      filter.hasExtra('hide_banners')
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    onPressed: () => toggle('hide_banners'),
                  ),
                ),
                const SizedBox(width: kSeparator2),
                button,
              ],
            );
            appBar = PreferredSize(
              preferredSize: Size.fromHeight(
                appBar.preferredSize.height + 34 + kGridSeparator,
              ),
              child: Column(
                children: [
                  appBar,
                  const SizedBox(height: kGridSeparator),
                  _header(context),
                ],
              ),
            );

            final tabs = _bannerType.map((bannerType) {
              final banner = GsUtils.wishes
                  .geReleasedInfoBannerByType(bannerType)
                  .lastOrNull;

              return Container(
                width: 100,
                height: 56,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(borderRadius: kListRadius),
                margin: const EdgeInsets.only(bottom: 4),
                child: CachedImageWidget(
                  banner?.image,
                  alignment: Alignment.bottomCenter,
                ),
              );
            });

            return InventoryPage(
              appBar: PreferredSize(
                preferredSize: appBar.preferredSize,
                child: Stack(
                  children: [
                    appBar,
                    Positioned.fill(
                      child: Center(
                        child: TabBar(
                          indicatorSize: TabBarIndicatorSize.label,
                          controller: _controller,
                          tabs: tabs.toList(),
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 4),
                          tabAlignment: TabAlignment.center,
                          indicatorColor: Colors.white,
                          dividerColor: Colors.transparent,
                          indicator: UnderlineTabIndicator(
                            insets: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                            borderRadius: BorderRadius.circular(100),
                            borderSide: const BorderSide(
                              width: 3,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              child: InventoryBox(
                child: TabBarView(
                  controller: _controller,
                  children: _bannerType.map((banner) {
                    return CustomScrollView(
                      slivers: _slivers(banner, filter),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        );
      },
    );
  }

  ListType _getListType(List<WishSummary> wishes, int index) {
    late final cWish = wishes.elementAtOrNull(index)?.wish;
    late final pWish = wishes.elementAtOrNull(index - 1)?.wish;
    late final nWish = wishes.elementAtOrNull(index + 1)?.wish;
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
    GeBannerType gsBanner,
    ScreenFilter<GiWish> filter,
  ) {
    final banners =
        GsUtils.wishes.geReleasedInfoBannerByType(gsBanner).sortedDescending();
    final wishes = GsUtils.wishes.getBannersWishesByType(gsBanner);

    return banners.map((banner) {
      final bannerWishes = wishes
          .where((e) => e.wish.bannerId == banner.id)
          .sortedByDescending((e) => e.wish.number)
          .thenWith((a, b) => b.wish.compareTo(a.wish));
      final filteredWishes =
          filter.matchBy(bannerWishes, (e) => e.wish).toList();

      final hide = filter.hasExtra('hide_banners');
      final showBanner = !hide || filteredWishes.isNotEmpty;
      return SliverStickyHeader(
        header: showBanner
            ? BannerListItem(banner: banner, rolls: bannerWishes.length)
            : const SizedBox(),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final item = filteredWishes[index];
              // print(index);
              return WishListItem(
                pity: item.pity,
                bannerType: gsBanner,
                wishState: item.state,
                index: index,
                wish: item.wish,
                type: _getListType(filteredWishes, index),
              );
            },
            childCount: filteredWishes.length,
          ),
        ),
      );
    }).toList();
  }

  Widget _header(BuildContext context) {
    final textStyle = context.themeStyles.label14n;
    final strutStyle = textStyle.toStrut();
    return SizedBox(
      height: 32,
      child: WishListInfoWidget(
        children: [
          Text(
            context.fromLabel(Labels.time),
            textAlign: TextAlign.center,
            style: textStyle,
            strutStyle: strutStyle,
          ),
          Text(
            context.fromLabel(Labels.pity),
            textAlign: TextAlign.center,
            style: textStyle,
            strutStyle: strutStyle,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 60),
            child: Text(
              context.fromLabel(Labels.name),
              textAlign: TextAlign.left,
              style: textStyle,
              strutStyle: strutStyle,
            ),
          ),
          const SizedBox(),
          Text(
            context.fromLabel(Labels.rarity),
            textAlign: TextAlign.center,
            style: textStyle,
            strutStyle: strutStyle,
          ),
          Text(
            context.fromLabel(Labels.type),
            textAlign: TextAlign.center,
            style: textStyle,
            strutStyle: strutStyle,
          ),
          Text(
            context.fromLabel(Labels.roll),
            textAlign: TextAlign.center,
            style: textStyle,
            strutStyle: strutStyle,
          ),
        ],
      ),
    );
  }
}
