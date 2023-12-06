import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_detailed_dialog.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/widgets/item_info_widget.dart';

class VersionDetailsCard extends StatelessWidget with GsDetailedDialogMixin {
  final InfoVersion item;

  const VersionDetailsCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        return ItemDetailsCard.single(
          name: item.name,
          fgImage: item.image,
          banner: GsItemBanner.fromVersion(context, item.id),
          info: Align(
            alignment: Alignment.topLeft,
            child: Text(item.id),
          ),
          child: _content(context),
        );
      },
    );
  }

  Widget _content(BuildContext context) {
    final characters = GsDatabase.instance.infoCharacters
        .getItems()
        .where((element) => element.version == item.id)
        .sortedByDescending((element) => element.rarity)
        .thenBy((element) => element.name);
    final outfits = GsDatabase.instance.infoCharactersOutfit
        .getItems()
        .where((element) => element.version == item.id)
        .sortedByDescending((element) => element.rarity)
        .thenBy((element) => element.name);
    final weapons = GsDatabase.instance.infoWeapons
        .getItems()
        .where((element) => element.version == item.id)
        .sortedByDescending((element) => element.rarity)
        .thenBy((element) => element.name);
    final materials = GsDatabase.instance.infoMaterials
        .getItems()
        .where((element) => element.version == item.id)
        .sortedByDescending((element) => element.rarity)
        .thenBy((element) => element.name);
    final recipes = GsDatabase.instance.infoRecipes
        .getItems()
        .where((element) => element.version == item.id)
        .sortedByDescending((element) => element.rarity)
        .thenBy((element) => element.name);
    final sets = GsDatabase.instance.infoSereniteaSets
        .getItems()
        .where((element) => element.version == item.id)
        .sortedByDescending((element) => element.rarity)
        .thenBy((element) => element.name);
    final crystals = GsDatabase.instance.infoSpincrystal
        .getItems()
        .where((element) => element.version == item.id)
        .sortedByDescending((element) => element.rarity)
        .thenBy((element) => element.name);
    final banners = GsDatabase.instance.infoBanners
        .getItems()
        .where((element) => element.version == item.id)
        .sortedByDescending((element) => element.type.index)
        .thenBy((element) => element.name);
    final chests = GsDatabase.instance.infoRemarkableChests
        .getItems()
        .where((element) => element.version == item.id)
        .sortedByDescending((element) => element.rarity)
        .thenBy((element) => element.name);
    final enemies = GsDatabase.instance.infoEnemies
        .getItems()
        .where((element) => element.version == item.id)
        .sorted();
    final namecards = GsDatabase.instance.infoNamecards
        .getItems()
        .where((element) => element.version == item.id)
        .sortedByDescending((element) => element.rarity)
        .thenBy((element) => element.name);
    return ItemDetailsCardContent.generate(
      context,
      [
        ItemDetailsCardContent(
          label: context.fromLabel(Labels.version),
          description: item.id,
        ),
        if (characters.isNotEmpty)
          ItemDetailsCardContent(
            label: context.fromLabel(Labels.characters),
            content: Wrap(
              spacing: kSeparator2,
              runSpacing: kSeparator2,
              children: characters.map((e) {
                return ItemCircleWidget(
                  image: e.image,
                  rarity: e.rarity,
                  tooltip: e.name,
                  padding: EdgeInsets.zero,
                );
              }).toList(),
            ),
          ),
        if (outfits.isNotEmpty)
          ItemDetailsCardContent(
            label: context.fromLabel(Labels.outfits),
            content: Wrap(
              spacing: kSeparator2,
              runSpacing: kSeparator2,
              children: outfits.map((e) {
                return ItemCircleWidget(
                  image: e.image,
                  rarity: e.rarity,
                  tooltip: e.name,
                );
              }).toList(),
            ),
          ),
        if (weapons.isNotEmpty)
          ItemDetailsCardContent(
            label: context.fromLabel(Labels.weapons),
            content: Wrap(
              spacing: kSeparator2,
              runSpacing: kSeparator2,
              children: weapons.map((e) {
                return ItemCircleWidget(
                  image: e.image,
                  rarity: e.rarity,
                  tooltip: e.name,
                  padding: EdgeInsets.zero,
                );
              }).toList(),
            ),
          ),
        if (materials.isNotEmpty)
          ItemDetailsCardContent(
            label: context.fromLabel(Labels.materials),
            content: Wrap(
              spacing: kSeparator2,
              runSpacing: kSeparator2,
              children: materials.map((e) {
                return ItemCircleWidget(
                  image: e.image,
                  rarity: e.rarity,
                  tooltip: e.name,
                );
              }).toList(),
            ),
          ),
        if (recipes.isNotEmpty)
          ItemDetailsCardContent(
            label: context.fromLabel(Labels.recipes),
            content: Wrap(
              spacing: kSeparator2,
              runSpacing: kSeparator2,
              children: recipes.map((e) {
                return ItemCircleWidget(
                  image: e.image,
                  rarity: e.rarity,
                  tooltip: e.name,
                );
              }).toList(),
            ),
          ),
        if (sets.isNotEmpty)
          ItemDetailsCardContent(
            label: context.fromLabel(Labels.sereniteaSets),
            content: Wrap(
              spacing: kSeparator2,
              runSpacing: kSeparator2,
              children: sets.map((e) {
                return ItemCircleWidget(
                  image: e.image,
                  rarity: e.rarity,
                  tooltip: e.name,
                );
              }).toList(),
            ),
          ),
        if (crystals.isNotEmpty)
          ItemDetailsCardContent(
            label: context.fromLabel(Labels.spincrystals),
            content: Wrap(
              spacing: kSeparator2,
              runSpacing: kSeparator2,
              children: crystals.map((e) {
                return ItemCircleWidget(
                  asset: spincrystalAsset,
                  rarity: e.rarity,
                  label: '${e.number} ${e.name}',
                );
              }).toList(),
            ),
          ),
        if (banners.isNotEmpty)
          ItemDetailsCardContent(
            label: context.fromLabel(Labels.wishes),
            content: Wrap(
              spacing: kSeparator2,
              runSpacing: kSeparator2,
              children: banners.map((e) {
                return ItemCircleWidget(
                  image: e.image,
                  // rarity: e.rarity,
                  tooltip: e.name,
                );
              }).toList(),
            ),
          ),
        if (chests.isNotEmpty)
          ItemDetailsCardContent(
            label: context.fromLabel(Labels.remarkableChests),
            content: Wrap(
              spacing: kSeparator2,
              runSpacing: kSeparator2,
              children: chests.map((e) {
                return ItemCircleWidget(
                  image: e.image,
                  rarity: e.rarity,
                  tooltip: e.name,
                );
              }).toList(),
            ),
          ),
        if (enemies.isNotEmpty)
          ItemDetailsCardContent(
            label: context.fromLabel(Labels.enemies),
            content: Wrap(
              spacing: kSeparator2,
              runSpacing: kSeparator2,
              children: enemies.map((e) {
                return ItemCircleWidget(
                  image: e.image,
                  rarity: e.rarityByType,
                  tooltip: e.name,
                  padding: EdgeInsets.zero,
                );
              }).toList(),
            ),
          ),
        if (namecards.isNotEmpty)
          ItemDetailsCardContent(
            label: context.fromLabel(Labels.namecards),
            content: Wrap(
              spacing: kSeparator2,
              runSpacing: kSeparator2,
              children: namecards.map((e) {
                return ItemCircleWidget(
                  image: e.image,
                  rarity: e.rarity,
                  tooltip: e.name,
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
