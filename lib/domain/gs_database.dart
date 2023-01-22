import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tracker/domain/gs_database.json.dart';
import 'package:tracker/domain/gs_domain.dart';

export 'package:tracker/domain/gs_database.extensions.dart';
export 'package:tracker/domain/gs_database.extensions2.dart';

class GsDatabase {
  static final instance = GsDatabase._();
  static const dataPath =
      kDebugMode ? 'D:/Software/Tracker_Genshin/db/data.json' : 'db/data.json';
  static const savePath = 'db/save.json';

  bool _dataLoaded = false;

  final infoDetails = JsonInfoSingle(
    'details',
    (map) => InfoDetails.fromMap(map),
  );
  final infoCities = JsonInfoDetails<InfoCity>(
    'cities',
    (map) => InfoCity.fromMap(map),
  );
  final infoBanners = JsonInfoDetails<InfoBanner>(
    'banners',
    (map) => InfoBanner.fromMap(map),
  );
  final infoArtifacts = JsonInfoDetails<InfoArtifact>(
    'artifacts',
    (map) => InfoArtifact.fromMap(map),
  );
  final infoMaterials = JsonInfoDetails<InfoMaterial>(
    'materials',
    (map) => InfoMaterial.fromMap(map),
  );
  final infoRecipes = JsonInfoDetails<InfoRecipe>(
    'recipes',
    (map) => InfoRecipe.fromMap(map),
  );
  final infoRemarkableChests = JsonInfoDetails(
    'remarkable_chests',
    (map) => InfoRemarkableChest.fromMap(map),
  );
  final infoIngredients = JsonInfoDetails<InfoIngredient>(
    'ingredients',
    (map) => InfoIngredient.fromMap(map),
  );
  final infoWeapons = JsonInfoDetails<InfoWeapon>(
    'weapons',
    (map) => InfoWeapon.fromMap(map),
  );
  final infoWeaponsInfo = JsonInfoDetails<InfoWeaponInfo>(
    'weapons_info',
    (map) => InfoWeaponInfo.fromMap(map),
  );
  final infoNamecards = JsonInfoDetails(
    'namecards',
    (map) => InfoNamecard.fromMap(map),
  );
  final infoCharacters = JsonInfoDetails<InfoCharacter>(
    'characters',
    (map) => InfoCharacter.fromMap(map),
  );
  final infoCharactersInfo = JsonInfoDetails(
    'characters_info',
    (map) => InfoCharacterInfo.fromMap(map),
  );
  final infoSpincrystal = JsonInfoDetails<InfoSpincrystal>(
    'spincrystals',
    (map) => InfoSpincrystal.fromMap(map),
  );
  final infoSereniteaSets = JsonInfoDetails<InfoSereniteaSet>(
    'serenitea_sets',
    (map) => InfoSereniteaSet.fromMap(map),
  );
  final infoVersion = JsonInfoDetails<InfoVersion>(
    'versions',
    (map) => InfoVersion.fromMap(map),
  );

  bool _saveLoaded = false;
  final saveWishes = JsonSaveDetails<SaveWish>(
    'wishes',
    (m) => SaveWish.fromMap(m),
    () => GsDatabase.instance._notify(),
  );
  final saveRecipes = JsonSaveDetails<SaveRecipe>(
    'recipes',
    (m) => SaveRecipe.fromMap(m),
    () => GsDatabase.instance._notify(),
  );
  final saveRemarkableChests = JsonSaveDetails<SaveRemarkableChest>(
    'remarkable_chests',
    (m) => SaveRemarkableChest.fromMap(m),
    () => GsDatabase.instance._notify(),
  );
  final saveCharacters = JsonSaveDetails<SaveCharacter>(
    'characters',
    (m) => SaveCharacter.fromMap(m),
    () => GsDatabase.instance._notify(),
  );
  final saveReputations = JsonSaveDetails<SaveReputation>(
    'reputation',
    (m) => SaveReputation.fromMap(m),
    () => GsDatabase.instance._notify(),
  );
  final saveSereniteaSets = JsonSaveDetails<SaveSereniteaSet>(
    'serenitea_sets',
    (m) => SaveSereniteaSet.fromMap(m),
    () => GsDatabase.instance._notify(),
  );
  final saveSpincrystals = JsonSaveDetails<SaveSpincrystal>(
    'spincrystals',
    (m) => SaveSpincrystal.fromMap(m),
    () => GsDatabase.instance._notify(),
  );
  final saveMaterials = JsonSaveDetails<SaveMaterial>(
    'materials',
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
    await JsonInfoDetails.loadInfo().then((info) {
      infoCities.load(info);
      infoBanners.load(info);
      infoDetails.load(info);
      infoRecipes.load(info);
      infoRemarkableChests.load(info);
      infoIngredients.load(info);
      infoWeapons.load(info);
      infoWeaponsInfo.load(info);
      infoArtifacts.load(info);
      infoMaterials.load(info);
      infoNamecards.load(info);
      infoCharacters.load(info);
      infoCharactersInfo.load(info);
      infoSpincrystal.load(info);
      infoSereniteaSets.load(info);
      infoVersion.load(info);
    });
  }

  Future<void> _loadSave() async {
    if (_saveLoaded) return;
    _saveLoaded = true;
    await JsonSaveDetails.loadInfo().then((map) {
      saveWishes.load(map);
      saveRecipes.load(map);
      saveRemarkableChests.load(map);
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
      saveRemarkableChests,
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
