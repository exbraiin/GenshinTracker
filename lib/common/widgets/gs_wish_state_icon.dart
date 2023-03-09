import 'package:flutter/material.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/enums/gs_banner.dart';
import 'package:tracker/domain/gs_database.utils.dart';

class GsWishStateIcon extends StatelessWidget {
  final Color color;
  final int rarity;
  final GsBanner banner;
  final EdgeInsets padding;
  final WishState wishState;

  const GsWishStateIcon(
    this.wishState, {
    super.key,
    this.rarity = 1,
    this.banner = GsBanner.character,
    this.color = Colors.white,
    this.padding = const EdgeInsets.only(left: 2),
  });

  @override
  Widget build(BuildContext context) {
    String? message;
    IconData? icon;
    switch (wishState) {
      case WishState.won:
        icon = Icons.star_rounded;
        message = context.fromLabel(banner.getWonLabel(rarity));
        break;
      case WishState.lost:
        icon = Icons.star_border_rounded;
        message = context.fromLabel(banner.getLostLabel(rarity));
        break;
      case WishState.guaranteed:
        icon = Icons.star_half_rounded;
        message = context.fromLabel(Labels.guaranteed);
        break;
      default:
        return const SizedBox();
    }
    return Padding(
      padding: padding,
      child: Tooltip(
        message: message,
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }
}
