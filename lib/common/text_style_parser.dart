import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/domain/enums/gs_element.dart';
import 'package:tracker/domain/gs_domain.dart';

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

Text parseTextStyle2<R>(String text, TextStyle style) {
  var bold = false;
  var italic = false;
  var underline = false;
  var color = style.color;

  final tags = {
    '<b>': () => bold = !bold,
    '</b>': () => bold = !bold,
    '<i>': () => italic = !italic,
    '</i>': () => italic = !italic,
    '<u>': () => underline = !underline,
    '</u>': () => underline = !underline,
    '<color=skill>': () => color = Colors.orange,
    '<color=geo>': () => color = GsElement.geo.getColor(),
    '<color=pyro>': () => color = GsElement.pyro.getColor(),
    '<color=cryo>': () => color = GsElement.cryo.getColor(),
    '<color=hydro>': () => color = GsElement.hydro.getColor(),
    '<color=anemo>': () => color = GsElement.anemo.getColor(),
    '<color=dendro>': () => color = GsElement.dendro.getColor(),
    '<color=electro>': () => color = GsElement.electro.getColor(),
    '</color>': () => color = style.color,
  };

  Iterable<TextSpan> getChildren() sync* {
    for (var p = 0;;) {
      final idxs = tags.keys
          .map((t) => MapEntry(t, text.indexOf(t, p)))
          .where((t) => t.value != -1);
      final tag = idxs.minBy((e) => e.value);
      if (tag == null) {
        final subText = text.substring(p, text.length);
        if (subText.isNotEmpty)
          yield TextSpan(
            text: subText,
            style: style.copyWith(
              color: color,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontStyle: italic ? FontStyle.italic : FontStyle.normal,
              decoration:
                  underline ? TextDecoration.underline : TextDecoration.none,
            ),
          );
        break;
      }
      final subTex = text.substring(p, tag.value);
      if (subTex.isNotEmpty)
        yield TextSpan(
          text: subTex,
          style: style.copyWith(
            color: color,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            fontStyle: italic ? FontStyle.italic : FontStyle.normal,
            decoration:
                underline ? TextDecoration.underline : TextDecoration.none,
          ),
        );
      tags[tag.key]?.call();
      p = tag.value + tag.key.length;
    }
  }

  return Text.rich(
    TextSpan(
      children: getChildren().toList(),
    ),
  );
}
