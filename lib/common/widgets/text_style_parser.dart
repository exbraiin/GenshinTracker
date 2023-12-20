import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/graphics/gs_spacing.dart';
import 'package:tracker/domain/enums/enum_ext.dart';
import 'package:tracker/theme/theme.dart';

class TextParserWidget extends StatelessWidget {
  final String text;
  final TextStyle style;

  const TextParserWidget(
    this.text, {
    super.key,
    this.style = const TextStyle(),
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: getChildren(context).toList(),
      ),
    );
  }

  Iterable<TextSpan> getChildren(BuildContext context) sync* {
    final bold = <FontWeight>[];
    final italic = <FontStyle>[];
    final underline = <TextDecoration>[];
    final colorQueue = <Color>[];

    final tags = {
      '<b>': () => bold.add(FontWeight.bold),
      '</b>': bold.pop,
      '<i>': () => italic.add(FontStyle.italic),
      '</i>': italic.pop,
      '<u>': () => underline.add(TextDecoration.underline),
      '</u>': underline.pop,
      '<color=skill>': () => colorQueue.add(context.themeColors.primary),
      '<color=geo>': () => colorQueue.add(GeElementType.geo.color),
      '<color=pyro>': () => colorQueue.add(GeElementType.pyro.color),
      '<color=cryo>': () => colorQueue.add(GeElementType.cryo.color),
      '<color=hydro>': () => colorQueue.add(GeElementType.hydro.color),
      '<color=anemo>': () => colorQueue.add(GeElementType.anemo.color),
      '<color=dendro>': () => colorQueue.add(GeElementType.dendro.color),
      '<color=electro>': () => colorQueue.add(GeElementType.electro.color),
      '</color>': colorQueue.pop,
    };
    for (var p = 0;;) {
      final idxs = tags.keys
          .map((t) => MapEntry(t, text.indexOf(t, p)))
          .where((t) => t.value != -1);

      late final color = colorQueue.peek;
      late final tempStyle = style.copyWith(
        color: color ?? style.color,
        fontWeight: bold.peek ?? style.fontWeight,
        fontStyle: italic.peek ?? style.fontStyle,
        decoration: underline.peek ?? style.decoration,
        shadows: color == context.themeColors.primary ? kMainShadowText : null,
      );

      final tag = idxs.minBy((e) => e.value);
      if (tag == null) {
        final subText = text.substring(p, text.length);
        if (subText.isNotEmpty) yield TextSpan(text: subText, style: tempStyle);
        break;
      }
      final subTex = text.substring(p, tag.value);
      if (subTex.isNotEmpty) yield TextSpan(text: subTex, style: tempStyle);
      tags[tag.key]?.call();
      p = tag.value + tag.key.length;
    }
  }
}

extension<E> on List<E> {
  E? get peek => lastOrNull;
  E? pop() => isEmpty ? null : removeLast();
}
