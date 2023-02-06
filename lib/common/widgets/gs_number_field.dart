import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

class GsNumberField extends StatefulWidget {
  final int length;
  final bool enabled;
  final double fontSize;
  final int Function()? onDbUpdate;
  final void Function(int)? onUpdate;

  const GsNumberField({
    super.key,
    this.length = 0,
    this.enabled = true,
    this.fontSize = 12,
    this.onUpdate,
    this.onDbUpdate,
  });

  GsNumberField.fromMaterial(
    InfoMaterial? material, {
    super.key,
    this.fontSize = 12,
  })  : enabled = material != null,
        length = (material?.maxAmount ?? 0).toString().length,
        onDbUpdate = (() {
          if (material == null) return 0;
          final sm = GsDatabase.instance.saveMaterials;
          return sm.getItemOrNull(material.id)?.amount ?? 0;
        }),
        onUpdate = ((amount) {
          if (material == null) return;
          final sm = GsDatabase.instance.saveMaterials;
          final saved = sm.getItemOrNull(material.id)?.amount ?? 0;
          if (saved == amount) return;
          sm.changeAmount(material.id, amount);
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
    _controller = TextEditingController(text: '0');
    _sub = GsDatabase.instance.loaded.listen((e) {
      if (widget.onDbUpdate == null) return;
      _controller.text = widget.onDbUpdate!.call().toString();
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
    return TextFormField(
      controller: _controller,
      enabled: widget.enabled,
      focusNode: _node,
      style: context.textTheme.infoLabel.copyWith(fontSize: widget.fontSize),
      textAlign: TextAlign.center,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        if (widget.length != 0) LengthLimitingTextInputFormatter(widget.length),
      ],
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        hintText: '0',
        hintStyle: context.textTheme.infoLabel.copyWith(
          fontSize: widget.fontSize,
          color: Colors.white.withOpacity(0.4),
        ),
        contentPadding: const EdgeInsets.all(kSeparator4),
      ),
    );
  }
}
