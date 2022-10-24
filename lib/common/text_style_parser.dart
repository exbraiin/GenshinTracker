import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/domain/enums/gs_element.dart';
import 'package:tracker/domain/gs_domain.dart';

class TextParserWidget extends StatelessWidget {
  final String text;
  final TextStyle style;

  TextParserWidget(
    this.text, {
    this.style = const TextStyle(),
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: getChildren().toList(),
      ),
    );
  }

  Iterable<TextSpan> getChildren() sync* {
    final bold = _Stack<FontWeight>();
    final italic = _Stack<FontStyle>();
    final underline = _Stack<TextDecoration>();
    final colorQueue = _Stack<Color>();

    final tags = {
      '<b>': () => bold.push(FontWeight.bold),
      '</b>': () => bold.pop(),
      '<i>': () => italic.push(FontStyle.italic),
      '</i>': () => italic.pop(),
      '<u>': () => underline.push(TextDecoration.underline),
      '</u>': () => underline.pop(),
      '<color=skill>': () => colorQueue.push(Colors.orange),
      '<color=geo>': () => colorQueue.push(GsElement.geo.getColor()),
      '<color=pyro>': () => colorQueue.push(GsElement.pyro.getColor()),
      '<color=cryo>': () => colorQueue.push(GsElement.cryo.getColor()),
      '<color=hydro>': () => colorQueue.push(GsElement.hydro.getColor()),
      '<color=anemo>': () => colorQueue.push(GsElement.anemo.getColor()),
      '<color=dendro>': () => colorQueue.push(GsElement.dendro.getColor()),
      '<color=electro>': () => colorQueue.push(GsElement.electro.getColor()),
      '</color>': () => colorQueue.pop(),
    };
    for (var p = 0;;) {
      final idxs = tags.keys
          .map((t) => MapEntry(t, text.indexOf(t, p)))
          .where((t) => t.value != -1);

      late final tempStyle = style.copyWith(
        color: colorQueue.peek ?? style.color,
        fontWeight: bold.peek ?? style.fontWeight,
        fontStyle: italic.peek ?? style.fontStyle,
        decoration: underline.peek ?? style.decoration,
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

class _Stack<E> {
  final _list = <E>[];

  void push(E value) => _list.add(value);

  E pop() => _list.removeLast();

  E? get peek => _list.lastOrNull;

  bool get isEmpty => _list.isEmpty;
  bool get isNotEmpty => _list.isNotEmpty;

  @override
  String toString() => _list.toString();
}
