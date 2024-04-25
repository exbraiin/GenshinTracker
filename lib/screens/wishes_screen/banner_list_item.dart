import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_icon_button.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/add_wish_screen/add_wish_screen.dart';
import 'package:tracker/screens/widgets/primogem_icon.dart';
import 'package:tracker/screens/wishes_screen/remove_dialog.dart';

const _bannerHeight = 100.0;

class BannerListItem extends StatelessWidget {
  final int rolls;
  final GsBanner banner;

  const BannerListItem({
    super.key,
    required this.rolls,
    required this.banner,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _bannerHeight,
      decoration: BoxDecoration(
        color: context.themeColors.mainColor1,
        border: Border(
          bottom: BorderSide(color: context.themeColors.divider),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: _bannerHeight,
                width: _bannerHeight * 4,
                child: Opacity(
                  opacity: 0.2,
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.black, Colors.black.withOpacity(0)],
                        stops: const [0, 0.4],
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.dstOut,
                    child: CachedImageWidget(
                      banner.image,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      showPlaceholder: false,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
            child: Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: context.textTheme.titleSmall!
                          .copyWith(color: Colors.white),
                      children: [
                        TextSpan(
                          text: '${banner.name} '
                              '(${banner.dateStart.format(showHour: false)}) ',
                        ),
                        TextSpan(
                          text: '\n   '
                              '${context.fromLabel(Labels.bannerNRolls, rolls)} - ',
                          style:
                              TextStyle(color: context.themeColors.almostWhite),
                        ),
                        const WidgetSpan(child: PrimogemIcon()),
                        TextSpan(
                          text: context.fromLabel(
                            Labels.bannerNPrimogems,
                            (rolls * GsUtils.details.primogemsPerWish).format(),
                          ),
                          style:
                              TextStyle(color: context.themeColors.almostWhite),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!banner.type.isPermanent)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GsItemCardLabel(
                      label: _getBannerDuration(context),
                    ),
                  ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GsIconButton(
                      icon: Icons.remove,
                      onPress: GsUtils.wishes.bannerHasWishes(banner.id)
                          ? () {
                              RemoveDialog.show(context, banner.name)
                                  .then((value) {
                                if (!value) return;
                                GsUtils.wishes.removeLastWish(banner.id);
                              });
                            }
                          : null,
                    ),
                    const SizedBox(height: 8),
                    GsIconButton(
                      icon: Icons.add,
                      onPress: () => Navigator.of(context)
                          .pushNamed(AddWishScreen.id, arguments: banner),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getBannerDuration(BuildContext context) {
    final endMs = banner.dateEnd.millisecondsSinceEpoch;
    final srcMs = banner.dateStart.millisecondsSinceEpoch;
    final dur = Duration(milliseconds: endMs - srcMs);

    final now = DateTime.now();
    if (banner.dateStart.isAfter(now)) {
      final diff = banner.dateStart.difference(now);
      return '${dur.toShortTime(context)} | ${diff.startOrStartedIn(context)}';
    } else {
      final diff = banner.dateEnd.difference(now);
      return '${dur.toShortTime(context)} | ${diff.endOrEndedIn(context)}';
    }
  }
}
