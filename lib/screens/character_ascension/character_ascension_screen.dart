import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/common/widgets/file_image.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/gs_icon_button.dart';
import 'package:tracker/common/widgets/no_results.dart';
import 'package:tracker/common/widgets/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/character_ascension/character_ascension_material.dart';
import 'package:tracker/screens/character_ascension/character_ascension_materials_screen.dart';

const radius = BorderRadius.all(Radius.circular(6));

class CharacterAscensionScreen extends StatelessWidget {
  static const id = 'character_ascension_screen';

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder<bool>(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        if (!snapshot.data!) return SizedBox();

        final wishes = GsDatabase.instance.saveWishes;
        final saved = GsDatabase.instance.saveCharacters;
        final items = GsDatabase.instance.infoCharacters.getItems();
        final characters = items
            .where((e) => wishes.hasCaracter(e.id))
            .sortedBy((e) => saved.getCharAscension(e.id))
            .thenByDescending((e) => e.rarity)
            .thenBy((e) => e.name)
            .toList();

        if (characters.isEmpty) {
          return NoResultsState();
        }

        return Scaffold(
          appBar: GsAppBar(
            label: 'Character Ascension',
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CharacterAscensionMaterialsScreen(),
                  ),
                ),
                icon: Icon(Icons.info_outline_rounded),
              ),
            ],
          ),
          body: ListView.separated(
            padding: EdgeInsets.all(kSeparator4),
            itemCount: characters.length,
            itemBuilder: (context, index) {
              return _CharacterAscensionListItem(characters[index]);
            },
            separatorBuilder: (context, index) => SizedBox(height: kSeparator4),
          ),
        );
      },
    );
  }
}

class _CharacterAscensionListItem extends StatelessWidget {
  final InfoCharacter item;

  _CharacterAscensionListItem(this.item);

  @override
  Widget build(BuildContext context) {
    final sw = GsDatabase.instance.saveWishes;
    final sc = GsDatabase.instance.saveCharacters;
    final saved = sc.getItemOrNull(item.id);
    final ascension = saved?.ascension ?? 0;
    final maxAscend = sc.getCharMaxAscended(item.id);
    final materials = !maxAscend
        ? getAscendMaterials(item.id, ascension + 1)
        : <AscendMaterial>[];
    final canAscend = materials
        .where((e) => e.material?.id != 'mora')
        .all((e) => e.hasRequired);
    return Opacity(
      opacity: maxAscend ? kDisableOpacity : 1,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: radius,
        ),
        padding: EdgeInsets.symmetric(vertical: kSeparator4),
        child: Row(
          children: [
            SizedBox(width: kSeparator4),
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                borderRadius: kMainRadius.copyWith(
                  bottomRight: Radius.circular(24),
                ),
                image: DecorationImage(
                  image: AssetImage(getRarityBgImage(item.rarity)),
                  fit: BoxFit.contain,
                ),
              ),
              child: ClipRRect(
                borderRadius: kMainRadius.copyWith(
                  bottomRight: Radius.circular(24),
                ),
                child: CachedImageWidget(item.image),
              ),
            ),
            SizedBox(width: kSeparator4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: context.textTheme.bigTitle3,
                ),
                SizedBox(height: kSeparator2),
                InkWell(
                  onTap: sw.getOwnedCharacter(item.id) != 0
                      ? () => sc.increaseAscension(item.id)
                      : null,
                  child: Text(
                    '${'✦' * ascension}${'✧' * (6 - ascension)}',
                    style: context.textTheme.bigTitle3,
                  ),
                ),
              ],
            ),
            Spacer(),
            if (materials.isNotEmpty)
              ...materials
                  .map<Widget>((e) => CharacterAscensionMaterial(
                        e.material?.id ?? '',
                        e.required,
                      ))
                  .separate(SizedBox(width: kSeparator4)),
            SizedBox(width: kSeparator4),
            if (materials.isNotEmpty)
              GsIconButton(
                size: 24,
                color: canAscend ? Colors.green : Colors.deepOrange,
                icon: canAscend ? Icons.check : Icons.close,
                onPress: canAscend
                    ? () => materials
                        .where((material) => material.material != null)
                        .forEach((e) =>
                            GsDatabase.instance.saveMaterials.changeAmount(
                              e.material!.id,
                              (e.owned - e.required).clamp(0, e.owned),
                            ))
                    : null,
              ),
            SizedBox(width: kSeparator4),
          ],
        ),
      ),
    );
  }
}

List<AscendMaterial> getAscendMaterials(String charId, int level) {
  final db = GsDatabase.instance;
  final char = db.infoCharacterDetails.getItemOrNull(charId);
  if (char == null) return [];
  final witsAmount = db.infoCharacterDetails.getAscensionHerosWit(level);
  return (char.ascension[level].materials.entries.toList()
        ..insert(0, MapEntry('heros_wit', witsAmount)))
      .map((e) => AscendMaterial.fromId(e.key, e.value))
      .toList();
}

class AscendMaterial {
  final int owned;
  final int required;
  final int craftable;
  final InfoMaterial? material;

  bool get hasRequired => owned + craftable >= required;

  AscendMaterial(
    this.owned,
    this.required,
    this.craftable,
    this.material,
  );

  factory AscendMaterial.fromId(String id, int required) {
    final db = GsDatabase.instance;
    final owned = db.saveMaterials.getMaterialAmount(id);
    final craft = db.saveMaterials.getCraftableAmount(id);
    final material = db.infoMaterials.getItemOrNull(id);
    return AscendMaterial(owned, required, craft, material);
  }
}
