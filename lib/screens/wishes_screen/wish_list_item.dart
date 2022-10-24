import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/common/widgets/gs_time_dialog.dart';
import 'package:tracker/common/widgets/gs_wish_state_icon.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/wishes_screen/wish_utils.dart';

enum ListType { none, top, middle, bottom }

class WishListItem extends StatelessWidget {
  final int pity;
  final int index;
  final SaveWish wish;
  final WishState wishState;
  final ListType type;

  WishListItem({
    required this.pity,
    required this.index,
    required this.wish,
    required this.wishState,
    this.type = ListType.none,
  });

  @override
  Widget build(BuildContext context) {
    final item = getItemData(wish.itemId);
    final style =
        Theme.of(context).textTheme.subtitle2!.copyWith(color: Colors.white);

    return Container(
      height: 44,
      margin: EdgeInsets.fromLTRB(
        kSeparator4,
        index == 0 ? kSeparator4 : 0,
        kSeparator4,
        kSeparator2,
      ),
      decoration: BoxDecoration(
        color: GsColors.getRarityColor(item.rarity).withOpacity(0.75),
        borderRadius: kMainRadius,
      ),
      child: Row(
        children: getSized([
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: InkWell(
              onTap: () async {
                final date = await GsTimeDialog.show(context, wish.date);
                if (date == null) return;
                GsDatabase.instance.saveWishes.updateWishDate(wish, date);
              },
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
              GsWishStateIcon(wishState),
            ],
          ),
          Row(
            children: [
              Container(
                width: 44,
                margin: EdgeInsets.fromLTRB(2, 2, 2, 0),
                child: CachedImageWidget(
                  item.getUrlImg(),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 8),
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
                          ? BorderSide(color: GsColors.almostWhite, width: 2)
                          : BorderSide.none,
                      right: BorderSide(color: GsColors.almostWhite, width: 2),
                      bottom: type == ListType.bottom
                          ? BorderSide(color: GsColors.almostWhite, width: 2)
                          : BorderSide.none,
                    ),
                  ),
                  child: type == ListType.top
                      ? Center(
                          child: Text(
                            Lang.of(context).getValue(Labels.x10),
                            style: style.copyWith(
                                fontSize: 8, color: GsColors.almostWhite),
                          ),
                        )
                      : null,
                )
              : SizedBox(),
          Text(item.rarity.toString(), style: style),
          Text(Lang.of(context).getValue(item.type.getLabel()), style: style),
          Text(wish.number.toString(), style: style),
        ]).toList(),
      ),
    );
  }
}
