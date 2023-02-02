import 'package:flutter/rendering.dart';

class SliverGridDelegateWithFixedChildSize extends SliverGridDelegate {
  final double childWidth;
  final double childHeight;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final CrossAxisAlignment alignment;

  SliverGridDelegateWithFixedChildSize({
    required this.childWidth,
    required this.childHeight,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
    this.alignment = CrossAxisAlignment.center,
  }) : assert(alignment != CrossAxisAlignment.baseline);

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    late final double mainAxisSize;
    late final double crossAxisSize;
    if (constraints.axis == Axis.vertical) {
      mainAxisSize = childHeight;
      crossAxisSize = childWidth;
    } else {
      mainAxisSize = childWidth;
      crossAxisSize = childHeight;
    }

    final crossAxisCount = ((constraints.crossAxisExtent + crossAxisSpacing) /
            (crossAxisSize + crossAxisSpacing))
        .floor();

    late final remainingSpace = constraints.crossAxisExtent -
        (crossAxisSize + crossAxisSpacing) * crossAxisCount;

    late final double crossAxisOffset;
    late final double crossAxisExtraSpacing;
    if (alignment == CrossAxisAlignment.start) {
      crossAxisOffset = 0;
      crossAxisExtraSpacing = 0;
    } else if (alignment == CrossAxisAlignment.center) {
      crossAxisOffset = (remainingSpace * 2 + crossAxisSpacing) / 4;
      crossAxisExtraSpacing = 0;
    } else if (alignment == CrossAxisAlignment.end) {
      crossAxisOffset = remainingSpace + crossAxisSpacing;
      crossAxisExtraSpacing = 0;
    } else if (alignment == CrossAxisAlignment.stretch) {
      crossAxisExtraSpacing = remainingSpace / crossAxisCount;
      crossAxisOffset = crossAxisExtraSpacing / 2;
    }

    return _CustomLayout(
      crossAxisOffset: crossAxisOffset,
      crossAxisCount: crossAxisCount,
      mainAxisStride: mainAxisSize + mainAxisSpacing,
      crossAxisStride: crossAxisSize + crossAxisSpacing + crossAxisExtraSpacing,
      childMainAxisExtent: mainAxisSize,
      childCrossAxisExtent: crossAxisSize,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(covariant SliverGridDelegate oldDelegate) {
    return true;
  }
}

class _CustomLayout extends SliverGridRegularTileLayout {
  final double crossAxisOffset;

  const _CustomLayout({
    required this.crossAxisOffset,
    required super.crossAxisCount,
    required super.mainAxisStride,
    required super.crossAxisStride,
    required super.childMainAxisExtent,
    required super.childCrossAxisExtent,
    required super.reverseCrossAxis,
  });

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    final geometry = super.getGeometryForChildIndex(index);
    return SliverGridGeometry(
      scrollOffset: geometry.scrollOffset,
      crossAxisOffset: geometry.crossAxisOffset + crossAxisOffset,
      mainAxisExtent: geometry.mainAxisExtent,
      crossAxisExtent: geometry.crossAxisExtent,
    );
  }
}
