import 'package:rxdart/rxdart.dart';
import 'package:tracker/domain/gs_database.tables.dart';
import 'package:tracker/domain/gs_database.test.dart';
import 'package:tracker/domain/gs_db.dart';
import 'package:tracker/domain/gs_domain.dart';

export 'package:tracker/domain/gs_database.extensions.dart';
export 'package:tracker/domain/gs_database.tables.dart';

class GsDatabase {
  static final instance = GsDatabase._();

  bool _dataLoaded = false;
  final infoCities = TableData(
    'Cities',
    (m) => InfoCity.fromMap(m),
  );
  final infoBanners = TableData(
    'Banners',
    (m) => InfoBanner.fromMap(m),
  );
  final infoRecipes = TableData(
    'Recipes',
    (m) => InfoRecipe.fromMap(m),
  );
  final infoSereniteaSets = TableData(
    'SereniteaSets',
    (m) => InfoSereniteaSet.fromMap(m),
  );
  final infoWeapons = TableData(
    'Weapons',
    (m) => InfoWeapon.fromMap(m),
  );
  final infoMaterials = TableData(
    'Materials',
    (m) => InfoMaterial.fromMap(m),
  );
  final infoSpincrystal = TableData(
    'Spincrystals',
    (m) => InfoSpincrystal.fromMap(m),
  );

  final infoDetails = JsonDetails();
  final infoArtifacts = JsonDetailsData(
    (id, map) => InfoArtifact.fromMap(id, map),
  );
  final infoCharacters = JsonDetailsData(
    (id, map) => InfoCharacter.fromMap(id, map),
  );

  bool _saveLoaded = false;
  final saveWishes = TableSaveData(
    'Wishes',
    (m) => SaveWish.fromMap(m),
    () => GsDatabase.instance._notify(),
  );
  final saveRecipes = TableSaveData(
    'Recipes',
    (m) => SaveRecipe.fromMap(m),
    () => GsDatabase.instance._notify(),
  );
  final saveCharacters = TableSaveData(
    'Characters',
    (m) => SaveCharacter.fromMap(m),
    () => GsDatabase.instance._notify(),
  );
  final saveReputations = TableSaveData(
    'Reputation',
    (m) => SaveReputation.fromMap(m),
    () => GsDatabase.instance._notify(),
  );
  final saveSereniteaSets = TableSaveData(
    'SereniteaSets',
    (m) => SaveSereniteaSet.fromMap(m),
    () => GsDatabase.instance._notify(),
  );
  final saveSpincrystals = TableSaveData(
    'Spincrystals',
    (m) => SaveSpincrystal.fromMap(m),
    () => GsDatabase.instance._notify(),
  );
  final saveMaterials = TableSaveData(
    'Materials',
    (m) => SaveMaterial.fromMap(m),
    () => GsDatabase.instance._notify(),
  );

  final _loaded = BehaviorSubject<bool>();
  final _saving = BehaviorSubject<bool>.seeded(false);

  ValueStream<bool> get loaded => _loaded;
  ValueStream<bool> get saving => _saving;

  GsDatabase._() {
    _load();
    _saving
        .where((event) => event)
        .debounceTime(Duration(seconds: 2))
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
    final db = await GsDB.getInfoDB();
    await Future.wait([
      infoCities.read(db),
      infoBanners.read(db),
      infoRecipes.read(db),
      infoSereniteaSets.read(db),
      infoWeapons.read(db),
      infoMaterials.read(db),
      infoSpincrystal.read(db),
      JsonDetailsData.readJsonFile().then((map) {
        infoDetails.parse(map['details']);
        infoArtifacts.parse(map['artifacts']);
        infoCharacters.parse(map['characters']);
      }),
    ]);
  }

  Future<void> _loadSave() async {
    if (_saveLoaded) return;
    _saveLoaded = true;
    final db = await GsDB.getSaveDB();
    await Future.wait([
      saveWishes.read(db),
      saveRecipes.read(db),
      saveCharacters.read(db),
      saveReputations.read(db),
      saveSereniteaSets.read(db),
      saveSpincrystals.read(db),
      saveMaterials.read(db),
    ]);
  }

  Future<void> _saveAll() async {
    _saving.add(false);
    final db = await GsDB.getSaveDB();
    saveWishes.write(db);
    saveRecipes.write(db);
    saveCharacters.write(db);
    saveReputations.write(db);
    saveSereniteaSets.write(db);
    saveSpincrystals.write(db);
    saveMaterials.write(db);
  }

  Future<void> _notify() async {
    _loaded.add(true);
    _saving.add(true);
  }

  void dispose() {
    _loaded.close();
    _saving.close();
  }
}
