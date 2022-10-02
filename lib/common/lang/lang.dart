import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

export 'package:tracker/common/lang/labels.dart';

class Lang {
  static Lang of(BuildContext context) =>
      Localizations.of<Lang>(context, Lang)!;

  static final delegate = _LangDelegate();

  final Map<String, String> _map;

  Lang(this._map);

  String getValue(String key, {Map<String, dynamic> nargs = const {}}) {
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
