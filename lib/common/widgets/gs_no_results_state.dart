import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';

class GsNoResultsState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: GsColors.mainColor3,
          ),
          SizedBox(height: 4),
          Text(
            Lang.of(context).getValue(Labels.noResults).toUpperCase(),
            style: context.textTheme.description.copyWith(
                color: GsColors.mainColor3, fontFamily: 'ZenKurenaido'),
          ),
        ],
      ),
    );
  }
}
