import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';

class HomeTable extends StatelessWidget {
  final List<Widget> headers;
  final List<List<Widget>> rows;

  const HomeTable({
    super.key,
    required this.headers,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder(
        verticalInside: BorderSide(
          color: Colors.grey.withOpacity(0.2),
        ),
      ),
      children: [
        TableRow(
          children: headers
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: e,
                ),
              )
              .toList(),
        ),
        ...rows.map((e) => TableRow(children: e.map((e) => e).toList())),
      ],
    );
  }
}

class HomeRow extends StatelessWidget {
  final String label;
  final Widget? child;
  final double fontSize;
  final Color color;

  const HomeRow(
    this.label, {
    super.key,
    this.fontSize = 12,
    this.color = Colors.white,
    this.child,
  });

  factory HomeRow.header(String label, {Color color = Colors.white}) =>
      HomeRow(label, fontSize: 14, color: color);

  factory HomeRow.missing(BuildContext context, int owned, int total) {
    final missing = total - owned;
    final color = missing > 0 ? context.themeColors.badValue : Colors.white;
    return HomeRow(
      '',
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            owned.format(),
            textAlign: TextAlign.end,
          ),
          if (missing > 0)
            Text(
              ' +${missing.format()}',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 10,
                color: context.themeColors.goodValue,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: DefaultTextStyle(
        style: context.textTheme.titleSmall!
            .copyWith(fontSize: fontSize, color: color),
        child: child ??
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
      ),
    );
  }
}
