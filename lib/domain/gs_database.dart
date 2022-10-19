import 'package:rxdart/rxdart.dart';
import 'package:tracker/domain/gs_database.test.dart';
import 'package:tracker/domain/gs_domain.dart';

export 'package:tracker/domain/gs_database.extensions.dart';

class GsDatabase {
  static final instance = GsDatabase._();

  bool _dataLoaded = false;

  final infoDetails = JsonDetails();
  final infoCities = JsonInfoDetails<InfoCity>(
    'cities',
    (id, map) => InfoCity.fromMap(id, map),
  );
  final infoBanners = JsonInfoDetails<InfoBanner>(
    'banners',
    (id, map) => InfoBanner.fromMap(id, map),
  );
  final infoArtifacts = JsonInfoDetails<InfoArtifact>(
    'artifacts',
    (id, map) => InfoArtifact.fromMap(id, map),
  );
  final infoMaterials = JsonInfoDetails<InfoMaterial>(
    'materials',
    (id, map) => InfoMaterial.fromMap(id, map),
  );
  final infoRecipes = JsonInfoDetails<InfoRecipe>(
    'recipes',
    (id, map) => InfoRecipe.fromMap(id, map),
  );
  final infoWeapons = JsonInfoDetails<InfoWeapon>(
    'weapons',
    (id, map) => InfoWeapon.fromMap(id, map),
  );
  final infoCharacters = JsonInfoDetails<InfoCharacter>(
    'characters',
    (id, map) => InfoCharacter.fromMap(id, map),
  );
  final infoSpincrystal = JsonInfoDetails<InfoSpincrystal>(
    'spincrystals',
    (id, map) => InfoSpincrystal.fromMap(id, map),
  );
  final infoSereniteaSets = JsonInfoDetails<InfoSereniteaSet>(
    'serenitea_sets',
    (id, map) => InfoSereniteaSet.fromMap(id, map),
  );

  bool _saveLoaded = false;
  final saveWishes = JsonSaveDetails<SaveWish>(
    'wishes',
    (id, m) => SaveWish.fromMap(id, m),
    () => GsDatabase.instance._notify(),
  );
  final saveRecipes = JsonSaveDetails<SaveRecipe>(
    'recipes',
    (id, m) => SaveRecipe.fromMap(id, m),
    () => GsDatabase.instance._notify(),
  );
  final saveCharacters = JsonSaveDetails<SaveCharacter>(
    'characters',
    (id, m) => SaveCharacter.fromMap(id, m),
    () => GsDatabase.instance._notify(),
  );
  final saveReputations = JsonSaveDetails<SaveReputation>(
    'reputation',
    (id, m) => SaveReputation.fromMap(id, m),
    () => GsDatabase.instance._notify(),
  );
  final saveSereniteaSets = JsonSaveDetails<SaveSereniteaSet>(
    'serenitea_sets',
    (id, m) => SaveSereniteaSet.fromMap(id, m),
    () => GsDatabase.instance._notify(),
  );
  final saveSpincrystals = JsonSaveDetails<SaveSpincrystal>(
    'spincrystals',
    (id, m) => SaveSpincrystal.fromMap(id, m),
    () => GsDatabase.instance._notify(),
  );
  final saveMaterials = JsonSaveDetails<SaveMaterial>(
    'materials',
    (id, m) => SaveMaterial.fromMap(id, m),
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
    await JsonInfoDetails.loadInfo().then((info) {
      infoCities.load(info);
      infoBanners.load(info);
      infoDetails.load(info);
      infoRecipes.load(info);
      infoWeapons.load(info);
      infoArtifacts.load(info);
      infoMaterials.load(info);
      infoCharacters.load(info);
      infoSpincrystal.load(info);
      infoSereniteaSets.load(info);
    });
  }

  Future<void> _loadSave() async {
    if (_saveLoaded) return;
    _saveLoaded = true;
    JsonSaveDetails.loadSave().then((map) {
      saveWishes.load(map);
      saveRecipes.load(map);
      saveCharacters.load(map);
      saveReputations.load(map);
      saveSereniteaSets.load(map);
      saveSpincrystals.load(map);
      saveMaterials.load(map);
    });
  }

  Future<void> _saveAll() async {
    _saving.add(false);
    await JsonSaveDetails.saveInfo([
      saveWishes,
      saveRecipes,
      saveCharacters,
      saveReputations,
      saveSereniteaSets,
      saveSpincrystals,
      saveMaterials,
    ]);
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
