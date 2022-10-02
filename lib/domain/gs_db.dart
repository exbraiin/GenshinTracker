import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sqflite_common/sqlite_api.dart' show Database;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

export 'package:sqflite_common/sqlite_api.dart' show Database;
export 'package:sqflite_common/sql.dart' show ConflictAlgorithm;

class GsDB {
  static Database? _save, _info;

  GsDB._();

  static Future<Database> getInfoDB() async {
    if (_info == null) {
      final db = File(
        kDebugMode ? 'D:/Software/Tracker_Genshin/db/data.db' : 'db/data.db',
      ).absolute;
      _info = await databaseFactoryFfi.openDatabase(db.path);
    }
    return _info!;
  }

  static Future<Database> getSaveDB() async {
    if (_save == null) {
      final db = File('db/save.db').absolute;
      _save = await databaseFactoryFfi.openDatabase(db.path);
      await _save!.execute(
        'CREATE TABLE IF NOT EXISTS Characters (id TEXT PRIMARY KEY, owned INTEGER NOT NULL DEFAULT 0, ascension INTEGER NOT NULL DEFAULT 0, friendship INTEGER NOT NULL DEFAULT 1);'
        'CREATE TABLE IF NOT EXISTS Recipes (id TEXT PRIMARY KEY, proficiency INTEGER NOT NULL DEFAULT 0);'
        'CREATE TABLE IF NOT EXISTS Reputation (id TEXT PRIMARY KEY, reputation INTEGER NOT NULL DEFAULT 0);'
        'CREATE TABLE IF NOT EXISTS SereniteaSets (id TEXT PRIMARY KEY, chars TEXT);'
        'CREATE TABLE IF NOT EXISTS Wishes (id TEXT PRIMARY KEY, banner TEXT, date DATETIME, item TEXT, number INTEGER);'
        'CREATE TABLE IF NOT EXISTS Spincrystals (number INTEGER PRIMARY KEY, obtained BIT NOT NULL DEFAULT \'false\');'
        'CREATE TABLE IF NOT EXISTS Materials (id TEXT PRIMARY KEY, amount INTEGER NOT NULL DEFAULT 0);',
      );
    }
    return _save!;
  }
}
