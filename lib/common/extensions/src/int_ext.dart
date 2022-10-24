import 'package:dartx/dartx.dart';

extension IntExt on int {
  String format([String separator = ',']) {
    final list = toString().characters.reversed;
    return Iterable.generate(
      (list.length / 3).ceil(),
      (i) => list.skip(i * 3).take(3).reversed.join(),
    ).reversed.join(separator);
  }
}
