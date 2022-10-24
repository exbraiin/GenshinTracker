import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

typedef ItemFromMap<T> = T Function(Map<String, dynamic> map);

class JsonInfoDetails<T extends IdData> {
  final String name;
  final ItemFromMap<T> create;
  final _map = <String, T>{};

  JsonInfoDetails(this.name, this.create);

  static Future<Map<String, dynamic>> loadInfo() {
    return File(GsDatabase.dataPath)
        .readAsString()
        .then((value) => jsonDecode(value) as Map<String, dynamic>);
  }

  Future<void> load(Map<String, dynamic> data) async {
    final map = data[name] as Map<String, dynamic>;
    _map.addAll(map.map((k, v) => MapEntry(k, create(v..['id'] = k))));
  }

  T getItem(String id) => _map[id]!;
  T? getItemOrNull(String id) => _map[id];
  bool exists(String id) => _map.containsKey(id);
  Iterable<T> getItems() => _map.values;
}

class JsonSaveDetails<T extends IdSaveData> extends JsonInfoDetails<T> {
  final VoidCallback? _onUpdate;

  JsonSaveDetails(String name, ItemFromMap<T> create, this._onUpdate)
      : super(name, create);

  void insertItem(T item) {
    _map[item.id] = item;
    _onUpdate?.call();
  }

  void deleteItem(String id) {
    final item = _map.remove(id);
    if (item == null) return;
    _onUpdate?.call();
  }
}

class JsonDetails {
  final _ascensionHerosWit = <int>[];

  Future<void> load(Map<String, dynamic> data) async {
    final map = data['details'] as Map<String, dynamic>;
    final values = (map['ascension_heros_wit'] as List).cast<int>();
    _ascensionHerosWit.addAll(values);
  }

  int getAscensionHerosWit(int level) => _ascensionHerosWit[level];
}
