import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/common/widgets/file_image.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/gs_icon_button.dart';
import 'package:tracker/common/widgets/item_card_button.dart';
import 'package:tracker/common/widgets/no_results.dart';
import 'package:tracker/common/widgets/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/characters_screen/character_ascension_materials_screen.dart';

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
    final sc = GsDatabase.instance.saveCharacters;
    final saved = sc.getItemOrNull(item.id);
    final ascension = saved?.ascension ?? 0;
    final maxAscend = sc.getCharMaxAscended(item.id);
    final materials = !maxAscend
        ? AscMat.values.map((e) => AscensionMaterial.fromAscension(e, item))
        : <AscensionMaterial>[];
    final canAscend = materials.all((e) => e.hasRequired);
    return Opacity(
      opacity: maxAscend ? kDisableOpacity : 1,
      child: Container(
        decoration: BoxDecoration(
          color: GsColors.getRarityColor(item.rarity),
          borderRadius: radius,
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              margin: EdgeInsets.all(kSeparator4).copyWith(bottom: 0),
              child: CachedImageWidget(
                item.image,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: kSeparator4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name),
                SizedBox(height: kSeparator2),
                ItemCardLabel(
                  label: '$ascension✦',
                  onTap: () => GsDatabase.instance.saveCharacters
                      .increaseAscension(item.id),
                ),
              ],
            ),
            Spacer(),
            if (materials.isNotEmpty)
              ...materials
                  .map((e) => _material(context: context, asc: e))
                  .separate(SizedBox(width: kSeparator4)),
            SizedBox(width: kSeparator4),
            if (materials.isNotEmpty)
              GsIconButton(
                size: 24,
                color: canAscend ? Colors.green : Colors.deepOrange,
                icon: canAscend ? Icons.check : Icons.close,
                onPress: canAscend
                    ? () {
                        materials.forEach((e) =>
                            GsDatabase.instance.saveMaterials.changeAmount(
                              e.material!.id,
                              (e.owned - e.required).clamp(0, e.owned),
                            ));
                      }
                    : null,
              ),
            SizedBox(width: kSeparator4),
          ],
        ),
      ),
    );
  }

  Widget _material({
    required BuildContext context,
    required AscensionMaterial asc,
  }) {
    final table = GsDatabase.instance.saveMaterials;
    final mat = asc.material;
    final amount = asc.owned;
    final onlyCraftable = asc.owned == 0 && asc.craftable > 0;

    const colorValid = Colors.lightGreen;
    const colorCraft = Colors.yellow;
    const colorInvalid = Colors.deepOrange;

    return Container(
      foregroundDecoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(color: GsColors.mainColor0, width: 2),
      ),
      child: Stack(
        children: [
          Container(
            width: 96,
            height: 64,
            decoration: BoxDecoration(
              color: GsColors.mainColor0,
              borderRadius: radius,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(getRarityBgImage(asc.material?.rarity ?? 1)),
              ),
            ),
          ),
          Container(
            width: 96,
            height: 64,
            padding: EdgeInsets.only(bottom: 12),
            child: CachedImageWidget(
              asc.material?.image,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: GsColors.mainColor0,
                borderRadius: radius.copyWith(
                  topLeft: Radius.zero,
                  topRight: Radius.zero,
                ),
              ),
              padding: EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GsIconButtonHold(
                    icon: Icons.remove,
                    size: 16,
                    onPress: amount > 0 && mat != null
                        ? (i) => table.changeAmount(
                              mat.id,
                              (amount - i).clamp(0, amount),
                            )
                        : null,
                  ),
                  Spacer(),
                  if (!onlyCraftable)
                    Text(
                      asc.owned.toString(),
                      style: context.textTheme.infoLabel.copyWith(
                        fontSize: 12,
                        color: asc.owned >= asc.required ||
                                asc.owned + asc.craftable >= asc.required
                            ? colorValid
                            : colorInvalid,
                      ),
                    ),
                  if (asc.owned < asc.required && asc.craftable > 0)
                    Text(
                      '+${(asc.required - asc.owned).clamp(0, asc.craftable)}',
                      style: context.textTheme.infoLabel.copyWith(
                        fontSize: 12,
                        color: colorCraft,
                      ),
                    ),
                  Text(
                    '/${asc.required}',
                    style: context.textTheme.infoLabel.copyWith(
                      fontSize: 12,
                      color: asc.hasRequired ? colorValid : colorInvalid,
                    ),
                  ),
                  Spacer(),
                  GsIconButtonHold(
                    icon: Icons.add,
                    size: 16,
                    onPress: amount < 9999 && mat != null
                        ? (i) => table.changeAmount(
                              mat.id,
                              (amount + i).clamp(amount, 9999),
                            )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const animate = false;
const radius = BorderRadius.all(Radius.circular(6));

enum AscMat {
  books,
  gems,
  boss,
  region,
  mobs,
}

class AscensionMaterial {
  static const _values = {
    AscMat.books: [6, 28, 29, 42, 59, 80],
    AscMat.gems: [1, 3, 6, 3, 6, 6],
    AscMat.boss: [0, 2, 4, 8, 12, 20],
    AscMat.region: [3, 10, 20, 30, 45, 60, 171],
    AscMat.mobs: [3, 15, 12, 18, 12, 24],
  };

  static List<AscMat> get keys => _values.keys.toList();

  final int owned;
  final int required;
  final int craftable;
  final InfoMaterial? material;

  bool get hasRequired => owned + craftable >= required;

  AscensionMaterial({
    this.material,
    this.owned = 0,
    this.required = 0,
    this.craftable = 0,
  });

  static String _getId(AscMat key, InfoCharacterDetails info, int ascension) {
    ascension = ascension - 1;
    if (key == AscMat.books) return 'heros_wit';
    if (key == AscMat.gems && info.gems.length > 3) {
      return info.gems[(ascension + 1) ~/ 2];
    }
    if (key == AscMat.boss) return info.boss;
    if (key == AscMat.region) return info.region;
    if (key == AscMat.mobs && info.mobs.length > 2) {
      return info.mobs[ascension ~/ 2];
    }
    return '';
  }

  factory AscensionMaterial.fromAscension(AscMat key, InfoCharacter char) {
    final db = GsDatabase.instance;
    final sc = db.saveCharacters.getItemOrNull(char.id);
    final sd = db.infoCharacterDetails.exists(char.id)
        ? db.infoCharacterDetails.getItem(char.id)
        : null;
    if (sd == null) return AscensionMaterial();

    final ascension = (sc?.ascension ?? 0) + 1;
    final id = _getId(key, sd, ascension);
    if (!db.infoMaterials.exists(id)) return AscensionMaterial();
    final mat = db.infoMaterials.getItem(id);

    final owned = db.saveMaterials.getItemOrNull(mat.id)?.amount ?? 0;
    final total = _values[key]?[ascension - 1] ?? 0;
    final craft = owned < total ? db.saveMaterials.getCraftableAmount(mat) : 0;

    return AscensionMaterial(
      material: mat,
      owned: owned,
      required: total,
      craftable: craft,
    );
  }

  static Iterable<MapEntry<String, int>> getMats(
    AscMat key,
    InfoCharacter char,
  ) sync* {
    final db = GsDatabase.instance;
    final sc = db.saveCharacters.getItemOrNull(char.id);
    final sd = db.infoCharacterDetails.exists(char.id)
        ? db.infoCharacterDetails.getItem(char.id)
        : null;
    if (sd == null) return;
    final ascension = (sc?.ascension ?? 0) + 1;
    for (var i = 0; i < 7 - ascension; ++i) {
      final asc = i + ascension;
      final id = _getId(key, sd, asc);
      if (!db.infoMaterials.exists(id)) continue;
      final total = _values[key]?[asc - 1] ?? 0;
      yield MapEntry(id, total);
    }
  }
}
