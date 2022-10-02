import 'package:flutter/material.dart';

class HomeTable extends StatelessWidget {
  final List<Widget> headers;
  final List<List<Widget>> rows;

  HomeTable({
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
                  (e) => Padding(padding: EdgeInsets.only(bottom: 8), child: e))
              .toList(),
        ),
        ...rows.map((e) => TableRow(children: e.map((e) => e).toList())),
      ],
    );
  }
}

class HomeRow extends StatelessWidget {
  final String label;
  final double fontSize;
  final Color color;

  HomeRow(
    this.label, {
    this.fontSize = 12,
    this.color = Colors.white,
  });

  factory HomeRow.header(String label, {Color color = Colors.white}) =>
      HomeRow(label, fontSize: 14, color: color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .subtitle2!
            .copyWith(fontSize: fontSize, color: color),
        textAlign: TextAlign.center,
        maxLines: 1,
      ),
    );
  }
}
