import 'package:flutter/foundation.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tracker/domain/gs_database.json.dart';
import 'package:tracker/domain/gs_domain.dart';

export 'package:tracker/domain/gs_database.utils.dart';

class Database {
  static final instance = Database._();
  static const prefix = kDebugMode ? 'D:/Software/Tracker_Genshin/' : '';
  static const dataPath = '${prefix}data/db/data.json';
  static const savePath = 'data/db/save.json';

  bool _dataLoaded = false;
  final _dbInfo = GsDatabase.info(loadJson: dataPath);
  Items<T> infoOf<T extends GsModel<T>>() => _dbInfo.of<T>();

  bool _saveLoaded = false;
  final saveAchievements = JsonSaveDetails<SaveAchievement>(
    'achievements',
    SaveAchievement.fromJsonData,
    _notify,
  );
  final saveWishes = JsonSaveDetails<SaveWish>(
    'wishes',
    SaveWish.fromJsonData,
    _notify,
  );
  final saveRecipes = JsonSaveDetails<SaveRecipe>(
    'recipes',
    SaveRecipe.fromJsonData,
    _notify,
  );
  final saveRemarkableChests = JsonSaveDetails<SaveRemarkableChest>(
    'remarkable_chests',
    SaveRemarkableChest.fromJsonData,
    _notify,
  );
  final saveCharacters = JsonSaveDetails<SaveCharacter>(
    'characters',
    SaveCharacter.fromJsonData,
    _notify,
  );
  final saveReputations = JsonSaveDetails<SaveReputation>(
    'reputation',
    SaveReputation.fromJsonData,
    _notify,
  );
  final saveSereniteaSets = JsonSaveDetails<SaveSereniteaSet>(
    'serenitea_sets',
    SaveSereniteaSet.fromJsonData,
    _notify,
  );
  final saveSpincrystals = JsonSaveDetails<SaveSpincrystal>(
    'spincrystals',
    SaveSpincrystal.fromJsonData,
    _notify,
  );
  final saveUserConfigs = JsonSaveDetails<SaveConfig>(
    'user_configs',
    SaveConfig.fromJsonData,
    _notify,
  );

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
    _dbInfo.didUpdate.listen((event) => print('\x1b[31mDB Updated!'));
  }

  Future<void> _loadSave() async {
    if (_saveLoaded) return;
    _saveLoaded = true;
    await JsonSaveDetails.loadInfo().then((map) {
      saveAchievements.load(map);
      saveWishes.load(map);
      saveRecipes.load(map);
      saveRemarkableChests.load(map);
      saveCharacters.load(map);
      saveReputations.load(map);
      saveSereniteaSets.load(map);
      saveSpincrystals.load(map);
      saveUserConfigs.load(map);
    });
  }

  Future<void> _saveAll() async {
    _saving.add(false);
    await JsonSaveDetails.saveInfo([
      saveAchievements,
      saveWishes,
      saveRecipes,
      saveRemarkableChests,
      saveCharacters,
      saveReputations,
      saveSereniteaSets,
      saveSpincrystals,
      saveUserConfigs,
    ]);
  }

  static Future<void> _notify() async {
    Database.instance._loaded.add(true);
    Database.instance._saving.add(true);
  }

  void dispose() {
    _loaded.close();
    _saving.close();
  }
}
