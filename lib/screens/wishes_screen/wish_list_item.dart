import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_confirm_dialog.dart';
import 'package:tracker/common/widgets/gs_time_dialog.dart';
import 'package:tracker/common/widgets/gs_wish_state_icon.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/wishes_screen/widgets/wish_list_info_widget.dart';

enum ListType { none, top, middle, bottom }

class WishListItem extends StatelessWidget {
  final int pity;
  final int index;
  final SaveWish wish;
  final WishState wishState;
  final GsBanner bannerType;
  final ListType type;

  const WishListItem({
    super.key,
    required this.pity,
    required this.index,
    required this.wish,
    required this.wishState,
    required this.bannerType,
    this.type = ListType.none,
  });

  @override
  Widget build(BuildContext context) {
    final item = GsUtils.items.getItemData(wish.itemId);
    final color = context.themeColors.getRarityColor(item.rarity);
    final style = context.textTheme.titleSmall!.copyWith(color: Colors.white);

    return Container(
      height: 44,
      margin: EdgeInsets.fromLTRB(
        kSeparator4,
        index == 0 ? kSeparator4 : 0,
        kSeparator4,
        kSeparator2,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.75),
        borderRadius: kMainRadius,
      ),
      child: WishListInfoWidget(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: InkWell(
              onTap: () => _updateDate(context),
              child: Text(
                wish.date.format().replaceAll(' ', '\n'),
                textAlign: TextAlign.center,
                style: style.copyWith(fontSize: 12),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(pity.toString(), style: style),
              GsWishStateIcon(
                wishState,
                rarity: item.rarity,
                banner: bannerType,
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 44,
                margin: const EdgeInsets.fromLTRB(2, 2, 2, 0),
                child: CachedImageWidget(
                  item.image,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              Text(item.name, style: style),
            ],
          ),
          type != ListType.none
              ? Container(
                  margin: EdgeInsets.only(
                    top: type == ListType.top ? 20 : 0,
                    bottom: type == ListType.bottom ? 20 : 0,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: type == ListType.top
                          ? BorderSide(
                              color: context.themeColors.almostWhite,
                              width: 2,
                            )
                          : BorderSide.none,
                      right: BorderSide(
                        color: context.themeColors.almostWhite,
                        width: 2,
                      ),
                      bottom: type == ListType.bottom
                          ? BorderSide(
                              color: context.themeColors.almostWhite,
                              width: 2,
                            )
                          : BorderSide.none,
                    ),
                  ),
                )
              : const SizedBox(),
          Text(item.rarity.toString(), style: style),
          Text(context.fromLabel(item.type.label), style: style),
          Text(wish.number.toString(), style: style),
        ],
      ),
    );
  }

  Future<void> _updateDate(BuildContext context) async {
    final date = await GsTimeDialog.show(context, wish.date);
    if (date == null || date == wish.date) return;

    if (type == ListType.none) {
      GsUtils.wishes.updateWishDate(wish, date);
      return;
    }

    final list = _getWishesAround(wish);
    bool? update = false;
    if (list.length > 1) {
      // ignore: use_build_context_synchronously
      if (!context.mounted) return;
      final title = context.fromLabel(Labels.wishes);
      final subtitle = context.fromLabel(Labels.updateAllWishes, list.length);
      update = await GsConfirmDialog.show(context, title, subtitle);
      if (update == null) return;
    }

    if (update) {
      for (var wish in list) {
        GsUtils.wishes.updateWishDate(wish, date);
      }
    } else {
      GsUtils.wishes.updateWishDate(wish, date);
    }
  }

  List<SaveWish> _getWishesAround(SaveWish wish) {
    final list = <SaveWish>[wish];
    final sorted = GsUtils.wishes.getBannerWishes(wish.bannerId);
    final index = sorted.indexWhere((e) => e.id == wish.id);
    if (index == -1) return list;
    final idxWish = sorted[index];
    for (var i = index + 1; i < sorted.length; ++i) {
      if (idxWish.date != sorted[i].date) break;
      list.add(sorted[i]);
    }
    for (var i = index - 1; i >= 0; --i) {
      if (idxWish.date != sorted[i].date) break;
      list.add(sorted[i]);
    }
    return list;
  }
}
