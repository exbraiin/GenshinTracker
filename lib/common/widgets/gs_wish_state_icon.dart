import 'package:flutter/material.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/screens/wishes_screen/wish_utils.dart';

class GsWishStateIcon extends StatelessWidget {
  final WishState wishState;

  GsWishStateIcon(this.wishState);

  @override
  Widget build(BuildContext context) {
    String? message;
    IconData? icon;
    switch (wishState) {
      case WishState.won:
        icon = Icons.star_rounded;
        message = context.fromLabel(Labels.won5050);
        break;
      case WishState.lost:
        icon = Icons.star_border_rounded;
        message = context.fromLabel(Labels.lost5050);
        break;
      case WishState.guaranteed:
        icon = Icons.star_half_rounded;
        message = context.fromLabel(Labels.guaranteed);
        break;
      default:
        return SizedBox();
    }
    return Padding(
      padding: EdgeInsets.only(left: 2),
      child: Tooltip(
        message: message,
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}
