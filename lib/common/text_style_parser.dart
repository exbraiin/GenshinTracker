import 'package:dartx/dartx.dart';

/// Returns a custom [R] used to build a text segment.
typedef TextStyleBuilder<R> = R Function(String text, bool bold, bool italic);

/// Applies the given [builder] to the given [text].
/// * Text between '**' is marked as bold.
/// * Text between '__' is marked as italic.
Iterable<R> parseTextStyle<R>(String text, TextStyleBuilder<R> builder) sync* {
  var bold = false;
  var italic = false;

  final tags = {
    '**': () => bold = !bold,
    '__': () => italic = !italic,
  };
  for (var p = 0;;) {
    final idxs = tags.entries
        .map((t) => MapEntry(t.key, text.indexOf(t.key, p)))
        .where((t) => t.value != -1);

    final tag = idxs.minBy((e) => e.value);
    if (tag == null) {
      final subText = text.substring(p, text.length);
      if (subText.isNotEmpty) yield builder(subText, bold, italic);
      break;
    }

    final subTex = text.substring(p, tag.value);
    if (subTex.isNotEmpty) yield builder(subTex, bold, italic);
    tags[tag.key]?.call();
    p = tag.value + tag.key.length;
  }
}
