import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/utils.dart';

class GsInfoContainer extends StatelessWidget {
  final String title;
  final List<Widget> children;

  GsInfoContainer({required this.title, this.children = const []});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kSeparator8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: kMainRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textTheme.bigTitle3.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'NotoSans',
            ),
          ),
          Divider(
            color: GsColors.dimWhite,
          ),
          ...children,
        ],
      ),
    );
  }
}
