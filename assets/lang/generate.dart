// ignore_for_file: unused_element

import 'dart:convert';
import 'dart:io';

void main() async {
  final file = File('assets/lang/en.json');
  final data = await file.readAsString();
  final map = (jsonDecode(data) as Map).cast<String, String>();
  _generateLabelsClass(map);
  // _generateExtensions(map);
}

void _generateLabelsClass(Map<String, dynamic> map) {
  final buffer = StringBuffer();
  buffer.writeln('class Labels {');
  buffer.writeln('\tLabels._();');

  map.forEach((k, v) {
    buffer.writeln();
    buffer.writeln('\t/// $v');
    buffer.writeln('\tstatic const ${k.toCamel()} = \'$k\';');
  });

  buffer.writeln('}');
  final end = File('assets/lang/labels.dart');
  end.writeAsString(buffer.toString());
}

void _generateExtensions(Map<String, String> map) {
  final buffer = StringBuffer();
  buffer.writeln('import \'package:flutter/material.dart\';');
  buffer.writeln('import \'package:tracker/common/lang/lang.dart\';');
  buffer.writeln();
  buffer.writeln('extension LangExt on Lang {');
  for (var entry in map.entries) {
    final name = entry.key.toCamel();
    final nargs = RegExp(r'{\w+}')
        .allMatches(entry.value)
        .map((e) => e.input.substring(e.start + 1, e.end - 1))
        .map((e) => 'Object ${e.toCamel()}')
        .join(', ');
    final method = '  String $name($nargs) => '
        'getValue(\'${entry.key}\');';

    buffer.writeln();
    buffer.writeln('  /// ${entry.value}');
    buffer.writeln(method);
  }
  buffer.writeln('}');
  File('assets/lang/lang_ext.dart').writeAsString(buffer.toString());
}

extension on String {
  String toCamel() {
    final words = this.toLowerCase().split('_').where((e) => e.isNotEmpty);
    final pascal = words
        .skip(1)
        .map((w) => '${w[0].toUpperCase()}${w.substring(1)}')
        .join();
    return '${words.first}$pascal';
  }
}
