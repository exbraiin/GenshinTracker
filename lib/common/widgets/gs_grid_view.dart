import 'package:flutter/cupertino.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/static/sliver_grid_fixed_size_delegate.dart';

class GsGridView extends StatelessWidget {
  final double childWidth;
  final double childHeight;
  final SliverChildDelegate delegate;

  GsGridView({
    this.childWidth = 126,
    this.childHeight = 160,
    required List<Widget> children,
  }) : delegate = SliverChildListDelegate(children);

  GsGridView.builder({
    this.childWidth = 126,
    this.childHeight = 160,
    required int itemCount,
    required Widget Function(BuildContext context, int index) itemBuilder,
  }) : delegate = SliverChildBuilderDelegate(
          itemBuilder,
          childCount: itemCount,
        );

  @override
  Widget build(BuildContext context) {
    return GridView.custom(
      childrenDelegate: delegate,
      padding: EdgeInsets.all(kSeparator4),
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithFixedChildSize(
        childWidth: childWidth,
        childHeight: childHeight,
        mainAxisSpacing: kSeparator4,
        crossAxisSpacing: kSeparator4,
        alignment: CrossAxisAlignment.center,
      ),
    );
  }
}
