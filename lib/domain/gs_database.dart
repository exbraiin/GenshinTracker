import 'dart:convert';
import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tracker/common/utils/network.dart';

export 'package:tracker/domain/gs_database.utils.dart';

class Database {
  static final instance = Database._();
  static const dataPath = 'data/db/data.json';
  static const savePath = 'data/db/save.json';
  static const versPath = 'data/db/vers.json';

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

  Future<void> _tryUpdateDataFile() async {
    const gitBaseUrl =
        'https://raw.githubusercontent.com/exbraiin/GenshinTrackerEditor';
    const gitDataUrl = '$gitBaseUrl/main/Release/data.json';
    const gitVersionUrl = '$gitBaseUrl/main/Release/version.txt';
    const defaultTTL = Duration(days: 1);

    final versionFile = File(versPath);
    if (!await versionFile.parent.exists()) await versionFile.parent.create();
    final versionJson = await versionFile.exists()
        ? jsonDecode(await versionFile.readAsString()) as JsonMap
        : const <String, dynamic>{};
    final versionDate = versionJson['updated'] != null
        ? DateTime.tryParse(versionJson['updated']!)
        : null;
    final versionTTL = versionJson['ttl'] != null
        ? Duration(milliseconds: versionJson['ttl']!)
        : defaultTTL;
    final versionCache = versionJson['version'] as String? ?? '';
    final versionExpire = versionDate?.add(versionTTL);
    if (versionExpire != null && versionExpire.isAfter(DateTime.now())) {
      print('Skipping version check!');
      return;
    }

    print('Downloading version file...');
    final version = await Network.downloadFile(gitVersionUrl);
    await versionFile.writeAsString(
      jsonEncode({
        'ttl': defaultTTL.inMilliseconds,
        'version': version,
        'updated': DateTime.now().toIso8601String(),
      }),
    );

    bool shouldSkipVersion() {
      if (version == null) return false;
      try {
        final v0 = version.split('.').map(int.parse);
        final v1 = versionCache.split('.').map(int.parse);
        return !v0.zip(v1, (a, b) => (a, b)).any((e) => e.$1 > e.$2);
      } catch (error) {
        return false;
      }
    }

    if (shouldSkipVersion()) {
      print('Skipping version $version!');
      return;
    }

    final data = await Network.downloadFile(gitDataUrl);
    if (data == null) return;
    await File(dataPath).writeAsString(data);
  }

  Future<void> _loadData() async {
    if (_dataLoaded) return;
    _dataLoaded = true;
    await _tryUpdateDataFile();
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
