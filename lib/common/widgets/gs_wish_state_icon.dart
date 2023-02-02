import 'package:flutter/material.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_database.utils.dart';

class GsWishStateIcon extends StatelessWidget {
  final WishState wishState;

  const GsWishStateIcon(this.wishState, {super.key});

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
        return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Tooltip(
        message: message,
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}
