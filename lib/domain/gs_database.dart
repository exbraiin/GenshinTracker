import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tracker/domain/gs_database.json.dart';
import 'package:tracker/domain/gs_domain.dart';

export 'package:tracker/domain/gs_database.extensions.dart';
export 'package:tracker/domain/gs_database.extensions2.dart';
export 'package:tracker/domain/gs_database.utils.dart';

class GsDatabase {
  static final instance = GsDatabase._();
  static const dataPath =
      kDebugMode ? 'D:/Software/Tracker_Genshin/db/data.json' : 'db/data.json';
  static const savePath = 'db/save.json';

  bool _dataLoaded = false;

  final infoDetails = JsonInfoSingle(
    'details',
    InfoDetails.fromMap,
  );
  final infoCities = JsonInfoDetails<InfoCity>(
    'cities',
    InfoCity.fromMap,
  );
  final infoBanners = JsonInfoDetails<InfoBanner>(
    'banners',
    InfoBanner.fromMap,
  );
  final infoArtifacts = JsonInfoDetails<InfoArtifact>(
    'artifacts',
    InfoArtifact.fromMap,
  );
  final infoMaterials = JsonInfoDetails<InfoMaterial>(
    'materials',
    InfoMaterial.fromMap,
  );
  final infoRecipes = JsonInfoDetails<InfoRecipe>(
    'recipes',
    InfoRecipe.fromMap,
  );
  final infoRemarkableChests = JsonInfoDetails(
    'remarkable_chests',
    InfoRemarkableChest.fromMap,
  );
  final infoIngredients = JsonInfoDetails<InfoIngredient>(
    'ingredients',
    InfoIngredient.fromMap,
  );
  final infoWeapons = JsonInfoDetails<InfoWeapon>(
    'weapons',
    InfoWeapon.fromMap,
  );
  final infoWeaponsInfo = JsonInfoDetails<InfoWeaponInfo>(
    'weapons_info',
    InfoWeaponInfo.fromMap,
  );
  final infoNamecards = JsonInfoDetails(
    'namecards',
    InfoNamecard.fromMap,
  );
  final infoCharacters = JsonInfoDetails<InfoCharacter>(
    'characters',
    InfoCharacter.fromMap,
  );
  final infoCharactersInfo = JsonInfoDetails(
    'characters_info',
    InfoCharacterInfo.fromMap,
  );
  final infoCharactersOutfit = JsonInfoDetails(
    'characters_outfits',
    InfoCharacterOutfit.fromMap,
  );
  final infoSpincrystal = JsonInfoDetails<InfoSpincrystal>(
    'spincrystals',
    InfoSpincrystal.fromMap,
  );
  final infoSereniteaSets = JsonInfoDetails<InfoSereniteaSet>(
    'serenitea_sets',
    InfoSereniteaSet.fromMap,
  );
  final infoVersion = JsonInfoDetails<InfoVersion>(
    'versions',
    InfoVersion.fromMap,
  );

  bool _saveLoaded = false;
  final saveWishes = JsonSaveDetails<SaveWish>(
    'wishes',
    SaveWish.fromMap,
    GsDatabase.instance._notify,
  );
  final saveRecipes = JsonSaveDetails<SaveRecipe>(
    'recipes',
    SaveRecipe.fromMap,
    GsDatabase.instance._notify,
  );
  final saveRemarkableChests = JsonSaveDetails<SaveRemarkableChest>(
    'remarkable_chests',
    SaveRemarkableChest.fromMap,
    GsDatabase.instance._notify,
  );
  final saveCharacters = JsonSaveDetails<SaveCharacter>(
    'characters',
    SaveCharacter.fromMap,
    GsDatabase.instance._notify,
  );
  final saveReputations = JsonSaveDetails<SaveReputation>(
    'reputation',
    SaveReputation.fromMap,
    GsDatabase.instance._notify,
  );
  final saveSereniteaSets = JsonSaveDetails<SaveSereniteaSet>(
    'serenitea_sets',
    SaveSereniteaSet.fromMap,
    GsDatabase.instance._notify,
  );
  final saveSpincrystals = JsonSaveDetails<SaveSpincrystal>(
    'spincrystals',
    SaveSpincrystal.fromMap,
    GsDatabase.instance._notify,
  );
  final saveMaterials = JsonSaveDetails<SaveMaterial>(
    'materials',
    SaveMaterial.fromMap,
    GsDatabase.instance._notify,
  );

  final _loaded = BehaviorSubject<bool>();
  final _saving = BehaviorSubject<bool>.seeded(false);

  ValueStream<bool> get loaded => _loaded;
  ValueStream<bool> get saving => _saving;

  GsDatabase._() {
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
      infoCharactersOutfit.load(info);
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
