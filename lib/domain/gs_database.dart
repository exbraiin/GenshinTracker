import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tracker/domain/gs_database.json.dart';
import 'package:tracker/domain/gs_domain.dart';

export 'package:tracker/domain/gs_database.extensions.dart';
export 'package:tracker/domain/gs_database.extensions2.dart';
export 'package:tracker/domain/gs_database.utils.dart';

class GsDatabase {
  static final instance = GsDatabase._();
  static const prefix = kDebugMode ? 'D:/Software/Tracker_Genshin/' : '';
  static const dataPath = '${prefix}data/db/data.json';
  static const savePath = 'data/db/save.json';

  bool _dataLoaded = false;

  final infoDetails = JsonInfoSingle(
    'details',
    InfoDetails.fromJsonData,
  );
  final infoCities = JsonInfoDetails<InfoCity>(
    'cities',
    InfoCity.fromJsonData,
  );
  final infoBanners = JsonInfoDetails<InfoBanner>(
    'banners',
    InfoBanner.fromJsonData,
  );
  final infoArtifacts = JsonInfoDetails<InfoArtifact>(
    'artifacts',
    InfoArtifact.fromJsonData,
  );
  final infoMaterials = JsonInfoDetails<InfoMaterial>(
    'materials',
    InfoMaterial.fromJsonData,
  );
  final infoRecipes = JsonInfoDetails<InfoRecipe>(
    'recipes',
    InfoRecipe.fromJsonData,
  );
  final infoRemarkableChests = JsonInfoDetails(
    'remarkable_chests',
    InfoRemarkableChest.fromJsonData,
  );
  final infoIngredients = JsonInfoDetails<InfoIngredient>(
    'ingredients',
    InfoIngredient.fromJsonData,
  );
  final infoWeapons = JsonInfoDetails<InfoWeapon>(
    'weapons',
    InfoWeapon.fromJsonData,
  );
  final infoWeaponsInfo = JsonInfoDetails<InfoWeaponInfo>(
    'weapons_info',
    InfoWeaponInfo.fromJsonData,
  );
  final infoNamecards = JsonInfoDetails(
    'namecards',
    InfoNamecard.fromJsonData,
  );
  final infoCharacters = JsonInfoDetails<InfoCharacter>(
    'characters',
    InfoCharacter.fromJsonData,
  );
  final infoCharactersInfo = JsonInfoDetails(
    'characters_info',
    InfoCharacterInfo.fromJsonData,
  );
  final infoCharactersOutfit = JsonInfoDetails(
    'characters_outfits',
    InfoCharacterOutfit.fromJsonData,
  );
  final infoSpincrystal = JsonInfoDetails<InfoSpincrystal>(
    'spincrystals',
    InfoSpincrystal.fromJsonData,
  );
  final infoSereniteaSets = JsonInfoDetails<InfoSereniteaSet>(
    'serenitea_sets',
    InfoSereniteaSet.fromJsonData,
  );
  final infoVersion = JsonInfoDetails<InfoVersion>(
    'versions',
    InfoVersion.fromJsonData,
  );

  bool _saveLoaded = false;
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
  final saveMaterials = JsonSaveDetails<SaveMaterial>(
    'materials',
    SaveMaterial.fromJsonData,
    _notify,
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

  static Future<void> _notify() async {
    GsDatabase.instance._loaded.add(true);
    GsDatabase.instance._saving.add(true);
  }

  void dispose() {
    _loaded.close();
    _saving.close();
  }
}
