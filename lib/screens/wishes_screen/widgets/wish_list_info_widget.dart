import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';

class WishListInfoWidget extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry itemPadding;

  const WishListInfoWidget({
    super.key,
    required this.children,
    this.itemPadding = EdgeInsets.zero,
  }) : assert(children.length == 7);

  @override
  Widget build(BuildContext context) {
    const sizes = <double>[100, 44, 0, 20, 64, 84, 56];
    return Row(
      children: sizes
          .mapIndexed(
            (idx, size) => size == 0
                ? Expanded(child: children[idx])
                : Container(
                    width: size,
                    padding: itemPadding,
                    alignment: Alignment.center,
                    child: children[idx],
                  ),
          )
          .toList(),
    );
  }
}
