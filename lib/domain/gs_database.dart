import 'dart:convert';
import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tracker/common/utils/network.dart';

export 'package:tracker/domain/gs_database.utils.dart';

const _kDataPath = 'data/db/data.json';
const _kSavePath = 'data/db/save.json';
const _kVersPath = 'data/db/vers.json';
const _kGit = 'https://raw.githubusercontent.com/exbraiin';
const _kGitDataUrl = '$_kGit/GenshinTrackerEditor/main/Release/gsdata';
const _kGitVersionUrl = '$_kGit/GenshinTrackerEditor/main/Release/gsversion';

class Database {
  static final instance = Database._();

  bool _dataLoaded = false;
  bool _saveLoaded = false;
  final _dbInfo = GsDatabase.info();
  final _dbSave = GsDatabase.save();
  Items<T> infoOf<T extends GsModel<T>>() => _dbInfo.of<T>();
  Items<T> saveOf<T extends GsModel<T>>() => _dbSave.of<T>();

  final _downloader = _Downloader();
  final _loaded = BehaviorSubject<bool>();
  final _saving = BehaviorSubject<bool>.seeded(false);

  String get version => _downloader._version?.version ?? '';
  Duration get cooldown => _downloader.cooldown;
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

  Future<void> fetchRemote() async {
    final success = await _downloader.forceUpdate();
    if (!success) return;
    await _dbInfo.load(path: _kDataPath);
    _loaded.add(true);
  }

  Future<void> _loadData() async {
    if (_dataLoaded) return;
    _dataLoaded = true;
    await _downloader.tryUpdateDatabase();
    await _dbInfo.load(path: _kDataPath);
  }

  Future<void> _loadSave() async {
    if (_saveLoaded) return;
    _saveLoaded = true;
    await _dbSave.load(path: _kSavePath);
    _dbSave.didUpdate.listen((_) {
      Database.instance._loaded.add(true);
      Database.instance._saving.add(true);
    });
  }

  Future<void> _saveAll() async {
    _saving.add(false);
    await _dbSave.save(path: _kSavePath);
  }
}

final class _Downloader {
  var _busy = false;
  DateTime? _expiresAt;
  _Version? _version;

  Duration get cooldown {
    if (_expiresAt == null) return Duration.zero;
    return _expiresAt!.difference(DateTime.now()).coerceAtLeast(Duration.zero);
  }

  Future<void> tryUpdateDatabase() async {
    if (_busy) return;

    try {
      _busy = true;
      final localVersion = await File(_kDataPath).exists()
          ? await _loadFileVersion()
          : _Version();

      // Check if we can skip the version check
      if (localVersion.shouldSkip) {
        if (kDebugMode) print('Skipping version check...');
        _version = localVersion;
        return;
      }

      // Download and check version
      if (kDebugMode) print('Downloading version file...');
      final remoteVersion = await _downloadVersion(_kGitVersionUrl);

      // Check if we can skip the version
      if (localVersion >= remoteVersion ?? false) {
        if (kDebugMode) print('Skipping version ${remoteVersion.version}!');
        _version = remoteVersion;
        return;
      }

      // Download database
      if (kDebugMode) print('Downloading database file...');
      await _downloadDatabase(_kGitDataUrl);
      _version = remoteVersion;
    } finally {
      _busy = false;
    }
  }

  Future<bool> forceUpdate() async {
    const kCooldownDuration = Duration(minutes: 1);
    if (_busy || cooldown.inSeconds > 0) return false;

    try {
      _busy = true;
      final localVersion = await _loadFileVersion();
      final remoteVersion = await _downloadVersion(_kGitVersionUrl);

      if (localVersion >= remoteVersion ?? false) {
        if (kDebugMode) print('Skipping version ${remoteVersion.version}!');
        return false;
      }

      if (kDebugMode) print('Downloading database file...');
      _version = remoteVersion;
      await _downloadDatabase(_kGitDataUrl);
      return true;
    } finally {
      _busy = false;
      _expiresAt = DateTime.now().add(kCooldownDuration);
    }
  }

  Future<_Version> _loadFileVersion() async {
    final versionFile = File(_kVersPath);
    if (!await versionFile.parent.exists()) await versionFile.parent.create();
    if (!await versionFile.exists()) return _Version();
    final map = jsonDecode(await versionFile.readAsString()) as JsonMap;
    return _Version.fromJson(map);
  }

  Future<_Version> _downloadVersion(String url) async {
    final version = await Network.downloadFile(url);
    if (version == null) return _Version();
    final model = _Version(version);
    final versionFile = File(_kVersPath);
    if (!await versionFile.parent.exists()) await versionFile.parent.create();
    await versionFile.writeAsString(jsonEncode(model.toJson()));
    return model;
  }

  Future<void> _downloadDatabase(String url) async {
    final data = await Network.downloadFile(url);
    if (data == null) return;
    final dataFile = File(_kDataPath);
    if (!await dataFile.parent.exists()) await dataFile.parent.create();
    await dataFile.writeAsString(data);
  }
}

class _Version {
  final String version;
  final DateTime lastUpdate;
  static const ttl = Duration(days: 1);

  DateTime get expiresAt {
    return lastUpdate.add(ttl);
  }

  bool get shouldSkip {
    return expiresAt.isAfter(DateTime.now());
  }

  _Version([String? version])
      : version = version ?? '',
        lastUpdate = version != null ? DateTime.now() : DateTime(0);

  _Version.fromJson(JsonMap json)
      : version = json['version'] as String? ?? '',
        lastUpdate = json['updated'] != null
            ? DateTime.tryParse(json['updated']!) ?? DateTime(0)
            : DateTime(0);

  bool? _compare(_Version a, _Version b, bool Function(int a, int b) v) {
    try {
      final va = a.version.split('.').map(int.parse);
      final vb = b.version.split('.').map(int.parse);
      return va.zip(vb, (a, b) => (a, b)).all((e) => v(e.$1, e.$2));
    } catch (error) {
      return null;
    }
  }

  bool? operator >(_Version other) => _compare(this, other, (a, b) => a > b);
  bool? operator <(_Version other) => _compare(this, other, (a, b) => a < b);
  bool? operator >=(_Version other) => _compare(this, other, (a, b) => a >= b);
  bool? operator <=(_Version other) => _compare(this, other, (a, b) => a <= b);

  JsonMap toJson() => {
        'version': version,
        'updated': lastUpdate.toIso8601String(),
      };
}
