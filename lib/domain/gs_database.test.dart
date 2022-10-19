import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:tracker/domain/gs_domain.dart';

class JsonDetailsData<T extends IdData> {
  final _map = <String, T>{};
  final T Function(String id, Map<String, dynamic> map) create;

  JsonDetailsData(this.create);

  static Future<Map<String, dynamic>> readJsonFile() async {
    final path = kDebugMode
        ? 'D:/Software/Tracker_Genshin/db/details.json'
        : 'db/details.json';

    final file = File(path);
    return jsonDecode(await file.readAsString()) as Map<String, dynamic>;
  }

  void parse(Map<String, dynamic> map) {
    _map.addAll(map.map((k, v) => MapEntry(k, create(k, v))));
  }

  T getItem(String id) => _map[id]!;
  T? getItemOrNull(String id) => _map[id];
  bool exists(String id) => _map.containsKey(id);
  Iterable<T> getItems() => _map.values;
}

class JsonDetails {
  final _ascensionHerosWit = <int>[];

  void parse(Map<String, dynamic> map) {
    final values = (map['ascension_heros_wit'] as List).cast<int>();
    _ascensionHerosWit.addAll(values);
  }

  int getAscensionHerosWit(int level) => _ascensionHerosWit[level];
}
