import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

typedef ItemFromMap<T> = T Function(JsonData data);

class JsonData {
  final Map<String, dynamic> _data;

  JsonData(this._data);

  T getData<T>(String key) => _data[key] as T;
  T getDataOrDefault<T>(String key, T value) => _data[key] as T? ?? value;
  T? getDataOrNull<T>(String key) => _data[key] as T?;

  int getInt(String key, [int df = 0]) => getDataOrDefault(key, df);
  bool getBool(String key, {bool df = false}) => getDataOrDefault(key, df);
  double getDouble(String key, [double df = 0]) => getDataOrDefault(key, df);
  String getString(String key, [String df = '']) => getDataOrDefault(key, df);

  List<int> getIntList(String key, [List<int> df = const []]) =>
      getDataOrDefault<List>(key, df).cast<int>();
  List<String> getStringList(String key, [List<String> df = const []]) =>
      getDataOrDefault<List>(key, df).cast<String>();
  List<String> getStringAsStringList(String key) => getString(key)
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotBlank)
      .toList();
  List<T> getModelMapAsList<T>(String key, ItemFromMap<T> create) =>
      getDataOrDefault<Map<String, dynamic>>(key, {})
          .entries
          .map((e) => create(JsonData(e.value..['id'] = e.key)))
          .toList();
  List<T> getModelListAsList<T>(String key, ItemFromMap<T> create) =>
      getDataOrDefault<List>(key, [])
          .cast<Map<String, dynamic>>()
          .map((e) => create(JsonData(e)))
          .toList();

  DateTime getDate(String key, [DateTime? df]) =>
      DateTime.tryParse(getDataOrDefault(key, '')) ?? df ?? DateTime(0);

  E getGsEnum<E extends GsEnum>(String key, List<E> values, [E? df]) {
    final id = getString(key);
    return values.firstWhere(
      (e) => e.id == id,
      orElse: () => df ?? values.first,
    );
  }

  List<E> getGsEnumList<E extends GsEnum>(String key, List<E> values) =>
      getStringList(key)
          .map((e) => values.firstOrNullWhere((t) => t.id == e))
          .whereNotNull()
          .toList();

  Map<K, V> getMap<K, V>(String key) =>
      getDataOrDefault<Map<String, dynamic>>(key, {}).cast<K, V>();
}

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
    final map = data[name] as Map<String, dynamic>? ?? {};
    final e = map.map((k, v) => MapEntry(k, create(JsonData(v..['id'] = k))));
    _map.addAll(e);
  }

  T getItem(String id) => _map[id]!;
  T? getItemOrNull(String id) => _map[id];
  bool exists(String id) => _map.containsKey(id);
  Iterable<T> getItems() => _map.values;
}

class JsonSaveDetails<T extends IdSaveData<T>> extends JsonInfoDetails<T> {
  final VoidCallback? _onUpdate;

  JsonSaveDetails(String name, ItemFromMap<T> create, this._onUpdate)
      : super(name, create);

  static Future<Map<String, dynamic>> loadInfo() async {
    final file = File(GsDatabase.savePath);
    if (!await file.exists()) return {};
    return file
        .readAsString()
        .then((data) => jsonDecode(data) as Map<String, dynamic>);
  }

  static Future<void> saveInfo(Iterable<JsonSaveDetails> data) async {
    final map = data.toMap(
      (e) => e.name,
      (e) => e.getItems().toMap((e) => e.id, (e) => e.toMap()..remove('id')),
    );
    await File(GsDatabase.savePath).writeAsString(jsonEncode(map));
  }

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

class JsonInfoSingle<T extends IdData> {
  final String name;
  final ItemFromMap<T> create;
  late T data;

  JsonInfoSingle(this.name, this.create);

  Future<void> load(Map<String, dynamic> data) async {
    final map = data[name] as Map<String, dynamic>? ?? {};
    this.data = create(JsonData(map));
  }
}
