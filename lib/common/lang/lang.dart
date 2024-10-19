import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tracker/common/lang/labels_methods.dart';

export 'package:tracker/common/lang/labels_methods.dart';

class Lang {
  static Lang of(BuildContext context) =>
      Localizations.of<Lang>(context, Lang)!;

  static final delegate = _LangDelegate();

  final Map<String, String> _map;
  late final methods = LabelsMethods(getValue);

  Lang(this._map);

  String getValue(String key, [Map<String, dynamic> nargs = const {}]) {
    var label = _map[key];
    if (label == null) return '##$key##';
    nargs.forEach((k, v) => label = label!.replaceAll('{$k}', '${v ?? '-'}'));
    return label!;
  }
}

class _LangDelegate extends LocalizationsDelegate<Lang> {
  @override
  bool isSupported(Locale locale) {
    return true;
  }

  @override
  Future<Lang> load(Locale locale) async {
    final data = await rootBundle.loadString('assets/lang/en.json');
    final map = (jsonDecode(data) as Map).cast<String, String>();
    return Lang(map);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<Lang> old) {
    return false;
  }
}

extension BuildContextExt on BuildContext {
  LabelsMethods get labels => Lang.of(this).methods;

  @Deprecated('Use \'context.label.*\' instead!')
  String fromLabel(String label, [Object? arg]) {
    final value = Lang.of(this).getValue(label);
    if (arg == null) return value;

    final exp = RegExp(r'{\w+}');
    final match = exp.allMatches(value).firstOrNull;
    if (match == null) return value;

    final name = value.substring(match.start, match.end);
    return value.replaceAll(name, arg.toString());
  }
}
