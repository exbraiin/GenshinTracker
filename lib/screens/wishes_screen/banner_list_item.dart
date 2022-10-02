import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/common/widgets/file_image.dart';
import 'package:tracker/common/widgets/gs_icon_button.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/add_wish_screen/add_wish_screen.dart';
import 'package:tracker/screens/wishes_screen/remove_dialog.dart';
import 'package:tracker/screens/wishes_screen/wish_utils.dart';

class BannerListItem extends StatelessWidget {
  final int rolls;
  final InfoBanner banner;

  BannerListItem({
    required this.rolls,
    required this.banner,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      padding: EdgeInsets.fromLTRB(16, 8, 4, 8),
      decoration: BoxDecoration(
        color: GsColors.mainColor1,
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.5)),
        ),
      ),
      child: Container(
        child: Row(
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: context.textTheme.subtitle2!
                      .copyWith(color: Colors.white),
                  children: [
                    TextSpan(
                      text: '${banner.name} '
                          '(${banner.dateStart.format(false)}) ',
                    ),
                    TextSpan(
                      text: '\n   $rolls Pulls - ',
                      style: TextStyle(color: GsColors.almostWhite),
                    ),
                    WidgetSpan(child: primoWidget()),
                    TextSpan(
                      text: '${(rolls * 160).format()} Primogems',
                      style: TextStyle(color: GsColors.almostWhite),
                    ),
                  ],
                ),
              ),
            ),
            Stack(
              children: [
                Container(
                  width: 150,
                  height: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      color: GsColors.mainColor0,
                      child: CachedImageWidget(
                        banner.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                if ([GsBanner.weapon, GsBanner.character].contains(banner.type))
                  Positioned(
                    right: kSeparator2,
                    bottom: kSeparator2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: GsColors.mainColor1,
                        borderRadius: kMainRadius,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: kSeparator2,
                        horizontal: kSeparator4,
                      ),
                      child: Text(
                        _getBannerDuration(),
                        style: Theme.of(context).textTheme.description,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GsIconButton(
                  icon: Icons.remove,
                  onPress: GsDatabase.instance.saveWishes
                          .bannerHasWishes(banner.id)
                      ? () {
                          RemoveDialog.show(context, banner.name).then((value) {
                            if (!value) return;
                            GsDatabase.instance.saveWishes
                                .removeLastWish(banner.id);
                          });
                        }
                      : null,
                ),
                SizedBox(height: 8),
                GsIconButton(
                  icon: Icons.add,
                  onPress: () => Navigator.of(context)
                      .pushNamed(AddWishScreen.id, arguments: banner),
                ),
              ],
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  String _getBannerDuration() {
    final now = DateTime.now();
    if (banner.dateStart.isAfter(now)) {
      final diff = banner.dateStart.difference(now);
      return diff.startOrStartedIn();
    } else {
      final diff = banner.dateEnd.difference(now);
      return diff.endOrEndedIn();
    }
  }
}
