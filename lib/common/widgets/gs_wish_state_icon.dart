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
    final state = _getState(context);
    if (state == null) return const SizedBox();

    return Padding(
      padding: padding,
      child: Tooltip(
        message: state.msg,
        child: Icon(state.icon, color: color, size: 16),
      ),
    );
  }

  ({String msg, IconData icon})? _getState(BuildContext context) {
    late final wonLabel = context.fromLabel(banner.getWonLabel(rarity));
    late final lostLabel = context.fromLabel(banner.getLostLabel(rarity));
    late final grtdLabel = context.fromLabel(Labels.guaranteed);
    return switch (wishState) {
      WishState.won => (msg: wonLabel, icon: Icons.star_rounded),
      WishState.lost => (msg: lostLabel, icon: Icons.star_border_rounded),
      WishState.guaranteed => (msg: grtdLabel, icon: Icons.star_half_rounded),
      _ => null,
    };
  }
}
