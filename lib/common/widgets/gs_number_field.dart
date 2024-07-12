import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/domain/gs_database.dart';

class GsNumberField extends StatefulWidget {
  final int length;
  final bool enabled;
  final bool hideText;
  final TextAlign align;
  final TextStyle style;
  final int Function()? onDbUpdate;
  final void Function(int)? onUpdate;

  const GsNumberField({
    super.key,
    this.length = 0,
    this.enabled = true,
    this.hideText = false,
    this.align = TextAlign.center,
    this.style = const TextStyle(fontSize: 12),
    this.onUpdate,
    this.onDbUpdate,
  });

  @override
  State<GsNumberField> createState() => _GsNumberFieldState();
}

class _GsNumberFieldState extends State<GsNumberField> {
  late final TextEditingController _controller;
  late final StreamSubscription _sub;
  late final FocusNode _node;

  @override
  void initState() {
    super.initState();
    _node = FocusNode()..addListener(_onNodeFocus);
    _controller = TextEditingController(text: '');
    _sub = Database.instance.loaded.listen((e) {
      if (widget.onDbUpdate == null) return;
      final value = widget.onDbUpdate!.call();
      _controller.text = value != 0 ? value.toString() : '';
      if (_node.hasFocus) _selectText();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _node.dispose();
    _sub.cancel();
    super.dispose();
  }

  void _onNodeFocus() {
    if (!_node.hasFocus) {
      _saveMaterial();
    } else {
      _selectText();
    }
  }

  void _selectText() {
    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _controller.text.length,
    );
  }

  void _saveMaterial() {
    final amount = int.tryParse(_controller.text) ?? 0;
    widget.onUpdate?.call(amount);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = context.themeStyles.label16n.merge(widget.style);
    final hintColor = textStyle.color?.withOpacity(kDisableOpacity);
    final hintStyle = textStyle.copyWith(color: hintColor);

    return TextFormField(
      controller: _controller,
      enabled: widget.enabled,
      focusNode: _node,
      style: textStyle,
      textAlign: widget.align,
      obscureText: widget.hideText,
      cursorColor: textStyle.color,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        if (widget.length != 0) LengthLimitingTextInputFormatter(widget.length),
      ],
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        hintText: '0',
        hintStyle: hintStyle,
        contentPadding: const EdgeInsets.all(kSeparator4),
      ),
    );
  }
}
