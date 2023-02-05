import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/cards/gs_rarity_item_card.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

class ChangelogScreen extends StatelessWidget {
  static const id = 'changelog_screen';

  const ChangelogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final iCharacters = GsDatabase.instance.infoCharacters;
    final characters = iCharacters.getItems().groupBy((e) => e.version);

    final iOutfits = GsDatabase.instance.infoCharactersOutfit;
    final outfits = iOutfits.getItems().groupBy((e) => e.version);

    final iWeapons = GsDatabase.instance.infoWeapons;
    final weapons = iWeapons.getItems().groupBy((e) => e.version);

    final iMaterials = GsDatabase.instance.infoMaterials;
    final materials = iMaterials.getItems().groupBy((e) => e.version);

    final iRecipes = GsDatabase.instance.infoRecipes;
    final recipes = iRecipes.getItems().groupBy((e) => e.version);

    final iSets = GsDatabase.instance.infoSereniteaSets;
    final sets = iSets.getItems().groupBy((e) => e.version);

    final iCrystals = GsDatabase.instance.infoSpincrystal;
    final crystals = iCrystals.getItems().groupBy((e) => e.version);

    final iIngredients = GsDatabase.instance.infoIngredients;
    final ingredients = iIngredients.getItems().groupBy((e) => e.version);

    final iBanners = GsDatabase.instance.infoBanners;
    final banners = iBanners.getItems().groupBy((e) => e.version);

    final iChests = GsDatabase.instance.infoRemarkableChests;
    final chests = iChests.getItems().groupBy((e) => e.version);

    final iNamecards = GsDatabase.instance.infoNamecards;
    final namecards = iNamecards.getItems().groupBy((e) => e.version);

    final groups = {
      ...characters.keys,
      ...outfits.keys,
      ...weapons.keys,
      ...materials.keys,
      ...recipes.keys,
      ...sets.keys,
      ...crystals.keys,
      ...ingredients.keys,
      ...banners.keys,
      ...chests.keys,
      ...namecards.keys,
    }.sortedByDescending((e) => double.tryParse(e) ?? 0).toList();

    final tabBar = TabBar(
      isScrollable: true,
      tabs: groups.map((e) => Tab(text: e.isNotEmpty ? e : 'None')).toList(),
    );

    return DefaultTabController(
      length: groups.length,
      child: Scaffold(
        appBar: GsAppBar(
          label: context.fromLabel(Labels.changelog),
          bottom: PreferredSize(
            preferredSize: tabBar.preferredSize,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: tabBar,
            ),
          ),
        ),
        body: Container(
          decoration: kMainBgDecoration,
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: groups
                      .map((version) => ListView(
                            padding: const EdgeInsets.all(kSeparator4),
                            children: [
                              _getSection<InfoCharacter>(
                                context: context,
                                title: context.fromLabel(Labels.characters),
                                items: characters[version]
                                    ?.sortedBy((element) => element.rarity)
                                    .thenBy((element) => element.name),
                                name: (i) => i.name,
                                image: (i) => i.image,
                                rarity: (i) => i.rarity,
                              ),
                              _getSection<InfoCharacterOutfit>(
                                context: context,
                                title: context.fromLabel(Labels.outfits),
                                items: outfits[version]
                                    ?.sortedBy((element) => element.rarity)
                                    .thenBy((element) => element.name),
                                name: (i) => i.name,
                                image: (i) => i.image,
                                rarity: (i) => i.rarity,
                              ),
                              _getSection<InfoWeapon>(
                                context: context,
                                title: context.fromLabel(Labels.weapons),
                                items: weapons[version]
                                    ?.sortedBy((element) => element.rarity)
                                    .thenBy((element) => element.name),
                                name: (i) => i.name,
                                image: (i) => i.image,
                                rarity: (i) => i.rarity,
                              ),
                              _getSection<InfoMaterial>(
                                context: context,
                                title: context.fromLabel(Labels.materials),
                                items: materials[version]
                                    ?.sortedBy((element) => element.group.index)
                                    .thenBy((element) => element.subgroup)
                                    .thenBy((element) => element.name),
                                name: (i) => i.name,
                                image: (i) => i.image,
                                rarity: (i) => i.rarity,
                              ),
                              _getSection<InfoRecipe>(
                                context: context,
                                title: context.fromLabel(Labels.recipes),
                                items: recipes[version]
                                    ?.sortedBy((element) => element.rarity)
                                    .thenBy((element) => element.name),
                                name: (i) => i.name,
                                image: (i) => i.image,
                                rarity: (i) => i.rarity,
                              ),
                              _getSection<InfoIngredient>(
                                context: context,
                                title: context.fromLabel(Labels.ingredients),
                                items: ingredients[version]
                                    ?.sortedBy((element) => element.rarity)
                                    .thenBy((element) => element.name),
                                name: (i) => i.name,
                                image: (i) => i.image,
                                rarity: (i) => i.rarity,
                              ),
                              _getSection<InfoSereniteaSet>(
                                context: context,
                                title: context.fromLabel(Labels.sereniteaSets),
                                items: sets[version]
                                    ?.sortedBy(
                                        (element) => element.category.index)
                                    .thenBy((element) => element.name),
                                name: (i) => i.name,
                                asset: (i) => i.category == GsSetCategory.indoor
                                    ? imageIndoorSet
                                    : imageOutdoorSet,
                              ),
                              _getSection<InfoSpincrystal>(
                                context: context,
                                title: context.fromLabel(Labels.spincrystals),
                                items: crystals[version]
                                    ?.sortedBy((element) => element.number),
                                name: (i) => '${i.number}: ${i.name}',
                                asset: (i) => spincrystalAsset,
                              ),
                              _getSection<InfoRemarkableChest>(
                                context: context,
                                title:
                                    context.fromLabel(Labels.remarkableChests),
                                items: chests[version]
                                    ?.sortedBy((element) => element.rarity)
                                    .thenBy((element) => element.name),
                                name: (i) => i.name,
                                image: (i) => i.image,
                                rarity: (i) => i.rarity,
                              ),
                              _getSection<InfoBanner>(
                                context: context,
                                title: context.fromLabel(Labels.wishes),
                                items: banners[version]
                                    ?.sortedBy((element) => element.type.index)
                                    .thenBy((element) => element.name),
                                name: (i) => i.name,
                                rarity: (i) =>
                                    _getBannerItemData(i)?.rarity ?? 1,
                                image: (i) =>
                                    _getBannerItemData(i)?.image ?? '',
                                fit: BoxFit.cover,
                              ),
                              _getSection<InfoNamecard>(
                                context: context,
                                title: context.fromLabel(Labels.namecards),
                                items: namecards[version]
                                    ?.sortedBy((element) => element.type)
                                    .thenBy((element) => element.name),
                                name: (i) => i.name,
                                image: (i) => i.image,
                              ),
                            ],
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getSection<T>({
    required BuildContext context,
    required String title,
    required List<T>? items,
    required String Function(T i) name,
    int Function(T i)? rarity,
    String Function(T i)? image,
    String Function(T i)? asset,
    BoxFit fit = BoxFit.contain,
  }) {
    if (items == null) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(bottom: kSeparator4),
      child: GsDataBox.info(
        title: title,
        child: Wrap(
          spacing: kSeparator4,
          runSpacing: kSeparator4,
          children: items
              .map((e) => GsRarityItemCard.withLabels(
                    labelFooter: name(e),
                    asset: asset?.call(e) ?? '',
                    image: image?.call(e) ?? '',
                    rarity: rarity?.call(e) ?? 1,
                    size: 80,
                    fit: fit,
                  ))
              .toList(),
        ),
      ),
    );
  }

  ItemData? _getBannerItemData(InfoBanner i) {
    final id = {
      GsBanner.standard: 'qiqi',
      GsBanner.beginner: 'noelle',
      GsBanner.weapon: i.feature5.firstOrNull,
      GsBanner.character: i.feature5.firstOrNull,
    }[i.type];
    return id != null ? GsUtils.items.getItemData(id) : null;
  }
}
