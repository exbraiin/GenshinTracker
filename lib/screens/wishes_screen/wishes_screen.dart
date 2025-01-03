import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/screen_filters/screen_filter_builder.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';
import 'package:tracker/screens/wishes_screen/banner_details_card.dart';
import 'package:tracker/screens/wishes_screen/banner_list_item.dart';

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
              iconAsset: GsAssets.menuWish,
              label: context.labels.wishes(),
              actions: [
                Tooltip(
                  message: context.labels.hideEmptyBanners(),
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
              child: appBar,
            );

            final tabs = _bannerType.map((bannerType) {
              final banner = GsUtils.wishes
                  .getReleasedInfoBannerByType(bannerType)
                  .sortedBy((e) => e.dateStart)
                  .thenByDescending((e) => e.subtype)
                  .lastOrNull;

              return Container(
                width: 100,
                height: 56,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  borderRadius: kListRadius,
                  color: Color(0x11FFFFFF),
                ),
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
                    Positioned.fill(child: appBar),
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
              child: TabBarView(
                controller: _controller,
                children: _bannerType.map((banner) {
                  final banners = GsUtils.wishes
                      .getReleasedInfoBannerByType(banner)
                      .sortedByDescending((e) => e.dateStart)
                      .thenBy((e) => e.subtype)
                      .toList();

                  final hide = filter.hasExtra('hide_banners');
                  if (hide) {
                    banners.removeWhere(
                      (e) => !GsUtils.wishes.bannerHasWishes(e.id),
                    );
                  }

                  return InventoryGridPage.builder(
                    childWidth: 126 * 2 + 6,
                    childHeight: 160,
                    padding: EdgeInsets.zero,
                    scrollableCard: false,
                    itemCount: banners.length,
                    itemBuilder: (context, state) {
                      final banner = banners[state.index];
                      return BannerListItem(
                        banner,
                        onTap: state.onSelect,
                        selected: state.selected,
                        disabled: !GsUtils.wishes.bannerHasWishes(banner.id),
                      );
                    },
                    itemCardBuilder: (context, index) {
                      return BannerDetailsCard(banners[index], filter);
                    },
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }
}
