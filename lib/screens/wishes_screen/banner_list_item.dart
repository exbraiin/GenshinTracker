import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/gs_icon_button.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/add_wish_screen/add_wish_screen.dart';
import 'package:tracker/screens/wishes_screen/remove_dialog.dart';

class BannerListItem extends StatelessWidget {
  final int rolls;
  final InfoBanner banner;

  const BannerListItem({
    super.key,
    required this.rolls,
    required this.banner,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      decoration: BoxDecoration(
        color: GsColors.mainColor1,
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.5)),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 86,
                width: 86 * 4,
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
                      style: context.textTheme.subtitle2!
                          .copyWith(color: Colors.white),
                      children: [
                        TextSpan(
                          text: '${banner.name} '
                              '(${banner.dateStart.format(false)}) ',
                        ),
                        TextSpan(
                          text: '\n   $rolls Pulls - ',
                          style: const TextStyle(color: GsColors.almostWhite),
                        ),
                        WidgetSpan(child: primoWidget()),
                        TextSpan(
                          text: '${(rolls * 160).format()} Primogems',
                          style: const TextStyle(color: GsColors.almostWhite),
                        ),
                      ],
                    ),
                  ),
                ),
                if ([GsBanner.weapon, GsBanner.character].contains(banner.type))
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GsItemCardLabel(
                      label: _getBannerDuration(),
                    ),
                  ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GsIconButton(
                      icon: Icons.remove,
                      onPress: GsDatabase.instance.saveWishes
                              .bannerHasWishes(banner.id)
                          ? () {
                              RemoveDialog.show(context, banner.name)
                                  .then((value) {
                                if (!value) return;
                                GsDatabase.instance.saveWishes
                                    .removeLastWish(banner.id);
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
