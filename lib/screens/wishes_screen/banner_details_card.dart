import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/gs_button.dart';
import 'package:tracker/common/widgets/gs_icon_button.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/add_wish_screen/add_wish_screen.dart';
import 'package:tracker/screens/screen_filters/screen_filter_builder.dart';
import 'package:tracker/screens/widgets/primogem_icon.dart';
import 'package:tracker/screens/wishes_screen/remove_dialog.dart';
import 'package:tracker/screens/wishes_screen/wish_list_item.dart';

class BannerDetailsCard extends StatelessWidget {
  final GsBanner item;
  final ScreenFilter<GiWish> filter;

  const BannerDetailsCard(this.item, this.filter, {super.key});

  @override
  Widget build(BuildContext context) {
    final wishes = GsUtils.wishes.getSaveWishesSummaryByBannerType(item.type);
    final bannerWishes = wishes
        .where((e) => e.wish.bannerId == item.id)
        .sortedByDescending((e) => e.wish.number)
        .thenWith((a, b) => b.wish.compareTo(a.wish));

    final filteredWishes = filter.matchBy(bannerWishes, (e) => e.wish).toList();

    return ItemDetailsCard.single(
      rarity: 5,
      name: item.name,
      infoPadding: EdgeInsets.zero,
      contentPadding: kListPadding,
      showRarityStars: false,
      flexContent: bannerWishes.isNotEmpty,
      info: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.6,
              child: CachedImageWidget(
                item.image,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                showPlaceholder: false,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: const [0, 0.1, 1],
                ),
              ),
              child: _bannerInfo(context, bannerWishes.length),
            ),
          ),
        ],
      ),
      child: bannerWishes.isNotEmpty
          ? Column(
              children: [
                _header(context),
                const SizedBox(height: kListSeparator),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredWishes.length,
                    itemBuilder: (context, index) {
                      final wish = filteredWishes[index];
                      return WishListItem(
                        pity: wish.pity,
                        index: index,
                        wish: wish.wish,
                        wishState: wish.state,
                        type: WishListItem.getListType(filteredWishes, index),
                        bannerType: item.type,
                      );
                    },
                  ),
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.all(kSeparator8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(fischlEmote, width: 60, height: 60),
                  const SizedBox(height: kSeparator4),
                  Text(
                    context.labels.noWishes(),
                    style: context.themeStyles.label14n
                        .copyWith(color: context.themeColors.mainColor1),
                  ),
                  const SizedBox(height: kSeparator8),
                  GsButton(
                    color: context.themeColors.mainColor1,
                    borderRadius: kListRadius,
                    onPressed: () => Navigator.of(context)
                        .pushNamed(AddWishScreen.id, arguments: item),
                    child: Text(
                      context.labels.addWishes(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _header(BuildContext context) {
    final textStyle = context.themeStyles.label14n
        .copyWith(color: context.themeColors.almostWhite);
    final strutStyle = textStyle.toStrut();
    return GsDataBox.info(
      bgColor: context.themeColors.mainColor1,
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              context.labels.time(),
              style: textStyle,
              strutStyle: strutStyle,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 44,
            child: Text(
              context.labels.pity(),
              style: textStyle,
              strutStyle: strutStyle,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 44),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              context.labels.name(),
              style: textStyle,
              strutStyle: strutStyle,
            ),
          ),
          SizedBox(
            width: 44,
            child: Text(
              context.labels.roll(),
              style: textStyle,
              strutStyle: strutStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bannerInfo(BuildContext context, int rolls) {
    return Padding(
      padding: const EdgeInsets.all(kSeparator8)
          .copyWith(bottom: kSeparator8 + kSeparator4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GsItemCardLabel(
                  label: item.dateStart.format(showHour: false),
                ),
                const SizedBox(height: kSeparator4),
                if (!item.type.isPermanent)
                  Padding(
                    padding: const EdgeInsets.only(bottom: kSeparator4),
                    child: GsItemCardLabel(
                      label: _getBannerDuration(context),
                    ),
                  ),
                RichText(
                  text: TextSpan(
                    style: context.themeStyles.label14n
                        .copyWith(shadows: kMainShadowText),
                    children: [
                      TextSpan(
                        text: ' ${context.labels.bannerNRolls(rolls)} - ',
                        style: TextStyle(
                          color: context.themeColors.almostWhite,
                        ),
                      ),
                      const WidgetSpan(child: PrimogemIcon()),
                      TextSpan(
                        text: context.labels.bannerNPrimogems(
                          (rolls * GsUtils.details.primogemsPerWish).format(),
                        ),
                        style: TextStyle(
                          color: context.themeColors.almostWhite,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GsIconButton(
                icon: Icons.remove,
                onPress: GsUtils.wishes.bannerHasWishes(item.id)
                    ? () {
                        RemoveDialog.show(context, item.name).then((value) {
                          if (!value) return;
                          GsUtils.wishes.removeLastWish(item.id);
                        });
                      }
                    : null,
              ),
              const SizedBox(height: kSeparator8),
              GsIconButton(
                icon: Icons.add,
                onPress: () => Navigator.of(context)
                    .pushNamed(AddWishScreen.id, arguments: item),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getBannerDuration(BuildContext context) {
    final endMs = item.dateEnd.millisecondsSinceEpoch;
    final srcMs = item.dateStart.millisecondsSinceEpoch;
    final dur = Duration(milliseconds: endMs - srcMs);

    final now = DateTime.now();
    if (item.dateStart.isAfter(now)) {
      final diff = item.dateStart.difference(now);
      return '${dur.toShortTime(context)} | ${diff.startOrStartedIn(context)}';
    } else {
      final diff = item.dateEnd.difference(now);
      return '${dur.toShortTime(context)} | ${diff.endOrEndedIn(context)}';
    }
  }
}
