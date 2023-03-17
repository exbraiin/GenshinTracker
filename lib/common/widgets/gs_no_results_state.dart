import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/theme/theme.dart';

class GsNoResultsState extends StatelessWidget {
  final double size;

  const GsNoResultsState.small({super.key}) : size = 60;
  const GsNoResultsState({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kSeparator4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(fischlEmote, width: size, height: size),
            const SizedBox(height: kSeparator4),
            Text(
              Lang.of(context).getValue(Labels.noResults),
              style: context.textTheme.description.copyWith(
                color: context.themeColors.dimWhite,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
