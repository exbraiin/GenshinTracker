import 'package:flutter/foundation.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:rxdart/rxdart.dart';

export 'package:tracker/domain/gs_database.utils.dart';

class Database {
  static final instance = Database._();
  static const prefix = kDebugMode ? 'D:/Software/Tracker_Genshin/' : '';
  static const dataPath = '${prefix}data/db/data.json';
  static const savePath = 'data/db/save.json';

  bool _dataLoaded = false;
  bool _saveLoaded = false;
  final _dbInfo = GsDatabase.info(loadJson: dataPath);
  final _dbSave = GsDatabase.save(loadJson: savePath, allowWrite: true);
  Items<T> infoOf<T extends GsModel<T>>() => _dbInfo.of<T>();
  Items<T> saveOf<T extends GsModel<T>>() => _dbSave.of<T>();

  final _loaded = BehaviorSubject<bool>();
  final _saving = BehaviorSubject<bool>.seeded(false);

  ValueStream<bool> get loaded => _loaded;
  ValueStream<bool> get saving => _saving;

  Database._() {
    _load();
    _saving
        .where((event) => event)
        .debounceTime(const Duration(seconds: 2))
        .listen((event) => _saveAll());
  }

  Future<void> _load() async {
    if (_loaded.hasValue) return;
    _loaded.add(false);
    await Future.wait([
      _loadData(),
      _loadSave(),
    ]);
    _loaded.add(true);
  }

  Future<void> _loadData() async {
    if (_dataLoaded) return;
    _dataLoaded = true;
    await _dbInfo.load();
  }

  Future<void> _loadSave() async {
    if (_saveLoaded) return;
    _saveLoaded = true;
    await _dbSave.load();
    _dbSave.didUpdate.listen((_) {
      Database.instance._loaded.add(true);
      Database.instance._saving.add(true);
    });
  }

  Future<void> _saveAll() async {
    _saving.add(false);
    await _dbSave.save();
  }
}
