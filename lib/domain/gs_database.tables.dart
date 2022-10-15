import 'package:tracker/domain/gs_db.dart';
import 'package:tracker/domain/gs_domain.dart';

typedef _VoidCallback = void Function();
typedef _CreateItemCallback<T> = T Function(Map<String, Object?>);

class TableData<T extends IdData> {
  final _map = <String, T>{};

  final String table;
  final _CreateItemCallback<T> create;

  TableData(this.table, this.create);

  Future<void> read(Database db) async {
    final objs = (await db.query(table)).map(create);
    final entries = objs.map((e) => MapEntry(e.id, e));
    _map.addAll(Map.fromEntries(entries));
  }

  T getItem(String id) => _map[id]!;
  T? getItemOrNull(String id) => _map[id];
  bool exists(String id) => _map.containsKey(id);
  Iterable<T> getItems() => _map.values;
}

class TableSaveData<T extends IdSaveData> extends TableData<T> {
  final _queue = <String>{};
  final _VoidCallback? onUpdate;

  TableSaveData(String table, _CreateItemCallback<T> create, [this.onUpdate])
      : super(table, create);

  void insertItem(T item) {
    _map[item.id] = item;
    _queue.add(item.id);
    onUpdate?.call();
  }

  void deleteItem(String id) {
    final item = _map.remove(id);
    if (item == null) return;
    _queue.add(id);
    onUpdate?.call();
  }

  void write(Database db) {
    if (_queue.isEmpty) return;
    final ids = _queue.toList();
    _queue.clear();
    ids.forEach((id) {
      final mp = _map[id]?.toMap();
      mp != null
          ? db.insert(table, mp, conflictAlgorithm: ConflictAlgorithm.replace)
          : db.delete(table, where: 'id = ?', whereArgs: [id]);
    });
    print('\x1b[31mSaved ${ids.length} to $table!');
  }
}
