// ignore_for_file: unused_element

import 'dart:convert';
import 'dart:io';

void main() async {
  final file = File('assets/lang/en.json');
  final data = await file.readAsString();
  final map = (jsonDecode(data) as Map).cast<String, String>();
  // await _generateLabelsClass(map);
  // await _checkKeys(map.keys);
  await _generateMethodsClass(map);
  // await Process.run('dart', ['format', 'assets/lang/labels_methods.dart']);
  // _generateExtensions(map);
  // File('assets/lang/labels.dart').rename('lib/common/lang/labels.dart');
  File('assets/lang/labels_methods.dart')
      .rename('lib/common/lang/labels_methods.dart');
}

Future<void> _generateLabelsClass(Map<String, dynamic> map) async {
  final buffer = StringBuffer();
  buffer.writeln('abstract final class Labels {');
  map.forEach((k, v) {
    buffer.writeln();
    buffer.writeln('\t/// $v');
    buffer.writeln('\tstatic const ${k.toCamel()} = \'$k\';');
  });

  buffer.writeln('}');
  final end = File('assets/lang/labels.dart');
  await end.writeAsString(buffer.toString());
}

Future<void> _checkKeys(Iterable<String> keys) async {
  final unused = keys.toList();

  final dir = Directory('lib');
  final files = (await dir.list(recursive: true).toList()).whereType<File>();
  for (final file in files) {
    final content = await file.readAsString();
    for (var i = 0; i < unused.length;) {
      final key = unused[i];
      final reg = RegExp('Labels\\.${key.toCamel()}', multiLine: true);
      if (reg.hasMatch(content)) {
        unused.remove(key);
        continue;
      }
      ++i;
    }
  }

  // ignore: avoid_print
  print('Unused Labels:\n${unused.join(', ')}');
}

Future<void> _generateMethodsClass(Map<String, dynamic> map) async {
  int min(int a, int b) => a < b ? a : b;

  const kClassName = 'LabelsMethods';
  final buffer = StringBuffer();
  buffer.writeln('final class $kClassName {');
  buffer.writeln(
    '\tfinal String Function(String key, [Map<String, dynamic> params]) transformer;',
  );

  buffer.writeln();
  buffer.writeln('\t/// Creates a new [$kClassName] instance.');
  buffer.writeln('\t$kClassName(this.transformer);');

  map.forEach((k, v) {
    var doc = v.toString();
    doc = doc.substring(0, min(100, doc.length));
    doc = doc.replaceAll('\n', ' ');

    final nargs = RegExp(r'{(\w+)}').allMatches(v).map((e) => e.group(1) ?? '');
    final fargs = nargs.map((e) => 'dynamic ${e.toCamel()}').join(', ');
    final targs = nargs.isNotEmpty
        ? ', {${nargs.map((e) => '\'$e\': ${e.toCamel()}').join(', ')}}'
        : '';

    buffer.writeln();
    buffer.writeln('\t/// $doc');
    buffer.writeln('\tString ${k.toCamel()}($fargs) {');
    buffer.writeln('\t\treturn transformer(\'$k\'$targs);');
    buffer.writeln('\t}');
  });

  buffer.writeln('}');
  final end = File('assets/lang/labels_methods.dart');
  await end.writeAsString(buffer.toString());
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
    final words = toLowerCase().split('_').where((e) => e.isNotEmpty);
    final pascal = words
        .skip(1)
        .map((w) => '${w[0].toUpperCase()}${w.substring(1)}')
        .join();
    return '${words.first}$pascal';
  }
}
