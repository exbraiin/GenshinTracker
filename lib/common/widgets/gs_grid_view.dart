import 'package:flutter/cupertino.dart';
import 'package:tracker/common/graphics/gs_style.dart';

class GsGridView extends StatelessWidget {
  final double maxWidth;
  final double aspectRatio;
  final SliverChildDelegate delegate;

  GsGridView._({
    this.maxWidth = 126,
    this.aspectRatio = 0.8,
    required this.delegate,
  });

  factory GsGridView({
    double maxWidth = 126,
    double aspectRatio = 0.8,
    required List<Widget> children,
  }) {
    return GsGridView._(
      maxWidth: maxWidth,
      aspectRatio: aspectRatio,
      delegate: SliverChildListDelegate(children),
    );
  }

  factory GsGridView.builder({
    double maxWidth = 126,
    double aspectRatio = 0.8,
    required int itemCount,
    required Widget Function(BuildContext context, int index) itemBuilder,
  }) {
    return GsGridView._(
      maxWidth: maxWidth,
      aspectRatio: aspectRatio,
      delegate: SliverChildBuilderDelegate(
        itemBuilder,
        childCount: itemCount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.custom(
      childrenDelegate: delegate,
      padding: EdgeInsets.all(kSeparator4),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        mainAxisSpacing: kSeparator4,
        crossAxisSpacing: kSeparator4,
        childAspectRatio: aspectRatio,
        maxCrossAxisExtent: maxWidth,
      ),
    );
  }
}
