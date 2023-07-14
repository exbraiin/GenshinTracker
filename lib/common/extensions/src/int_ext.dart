import 'package:dartx/dartx.dart';

extension IntExt on int {
  String format([String separator = ' ']) {
    final list = toString().characters.reversed;
    return Iterable.generate(
      (list.length / 3).ceil(),
      (i) => list.skip(i * 3).take(3).reversed.join(),
    ).reversed.join(separator);
  }

  String compact() {
    const units = ['', 'K', 'M', 'G', 'T', 'P'];
    var v = toDouble();
    var m = 0;
    while (v.abs() >= 1000) {
      m++;
      v /= 1000;
    }
    final fix = v.toStringAsFixed(1);
    return fix.endsWith('.0') ? '${v.toInt()}${units[m]}' : '$fix${units[m]}';
  }
}
