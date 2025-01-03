import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/gs_detailed_dialog.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';
import 'package:tracker/domain/enums/enum_ext.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/widgets/ascension_status.dart';
import 'package:tracker/screens/widgets/item_info_widget.dart';

class CharacterDetailsCard extends StatelessWidget with GsDetailedDialogMixin {
  final GsCharacter item;
  final Color bgColor;

  CharacterDetailsCard(this.item, {super.key})
      : bgColor =
            Color.lerp(Colors.black, item.element.color, 0.2)!.withOpacity(0.6);

  @override
  Widget build(BuildContext context) {
    final ascension = GsUtils.characters.getCharAscension(item.id);
    final friendship = GsUtils.characters.getCharFriendship(item.id);
    final constellation =
        GsUtils.characters.getTotalCharConstellations(item.id);
    final hasChar = GsUtils.characters.hasCaracter(item.id);

    return ItemDetailsCard.single(
      name: item.name,
      rarity: item.rarity,
      image: item.image,
      contentImage: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage(item.element.assetBgPath),
      ),
      info: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: context.themeStyles.label14n,
          ),
          const SizedBox(height: kSeparator4),
          Row(
            children: [
              GsItemCardLabel(
                asset: item.element.assetPath,
                label: constellation != null ? 'C$constellation' : null,
              ),
              const SizedBox(width: kSeparator4),
              if (hasChar)
                GsItemCardLabel(
                  asset: GsAssets.imageXp,
                  label: friendship.toString(),
                  onTap: () =>
                      GsUtils.characters.increaseFriendshipCharacter(item.id),
                ),
            ],
          ),
          const SizedBox(width: kSeparator4),
          if (hasChar)
            InkWell(
              onTap: () => GsUtils.characters.increaseAscension(item.id),
              child: Text(
                '${'✦' * ascension}${'✧' * (6 - ascension)}',
                style: context.themeStyles.title20n,
              ),
            ),
        ],
      ),
      child: Stack(
        children: [
          if (item.constellationImage.isNotEmpty)
            Positioned.fill(
              bottom: null,
              child: CachedImageWidget(
                item.constellationImage,
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                scaleToSize: false,
                showPlaceholder: false,
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: kSeparator6),
            child: Column(
              children: [
                Text(
                  item.description,
                  style: context.themeStyles.label12n
                      .copyWith(color: context.themeColors.almostWhite),
                ),
                _getAttributes(context, item),
                _getStats(context, item),
                _getMaterials(context, item),
              ].separate(const SizedBox(height: kSeparator8)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getAttributes(BuildContext context, GsCharacter info) {
    final style = context.textTheme.titleSmall!;
    final stLabel = style.copyWith(color: context.themeColors.almostWhite);
    final stStyle = style.copyWith(color: Colors.white);
    final db = Database.instance.infoOf<GsRecipe>();
    final dish = db.getItem(info.specialDish);

    final data = <String, Widget>{
      context.labels.element():
          Text(info.element.label(context), style: stStyle),
      context.labels.weapon(): Text(info.weapon.label(context), style: stStyle),
      context.labels.constellation(): Text(info.constellation),
      context.labels.affiliation(): Text(info.affiliation, style: stStyle),
      context.labels.version(): Text(info.version, style: stStyle),
      context.labels.birthday(): Text(info.birthday.toPrettyDate(context)),
      context.labels.releaseDate(): Text(
        info.releaseDate.toPrettyDate(context),
        style: stStyle,
      ),
      context.labels.specialDish(): dish != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(child: Text(dish.name)),
                const SizedBox(width: kSeparator8),
                ItemGridWidget.recipe(dish, tooltip: false),
              ],
            )
          : Text(context.labels.wsNone(), style: stStyle),
    };

    return GsDataBox.info(
      title: Text(context.labels.attributes()),
      bgColor: bgColor,
      children: [
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: IntrinsicColumnWidth(),
          },
          border: TableBorder(
            horizontalInside: BorderSide(
              color: context.themeColors.divider,
              width: 0.4,
            ),
          ),
          children: data.entries.map((entry) {
            return TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
                  child: Text(entry.key, style: stLabel),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
                  child: DefaultTextStyle(
                    style: stStyle,
                    textAlign: TextAlign.end,
                    child: entry.value,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _getStats(BuildContext context, GsCharacter item) {
    return GsDataBox.info(
      bgColor: bgColor,
      title: Text(context.labels.status()),
      child: AscensionStatus.character(item),
    );
  }

  Widget _getMaterials(BuildContext context, GsCharacter item) {
    final im = Database.instance.infoOf<GsMaterial>();
    const ic = GsUtils.characterMaterials;
    final tltMats = ic.getTalentMaterials(item.id);
    final ascMats = ic.getAscensionMaterials(item.id);

    int existance(String? id) {
      if (id == null) return 0;
      final a = tltMats.containsKey(id) ? 1 : 0;
      final b = ascMats.containsKey(id) ? 1 : 0;
      return a + b;
    }

    TableRow getTableRow(
      String label,
      Map<String, int> mats,
      Widget Function(MapEntry<GsMaterial, int> e) mapper,
    ) {
      return TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.all(kSeparator8),
            child: Text(
              label,
              style:
                  context.textTheme.titleSmall!.copyWith(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kSeparator4),
            child: Wrap(
              spacing: kSeparator4,
              runSpacing: kSeparator4,
              textDirection: TextDirection.rtl,
              children: mats.entries
                  .map((e) => MapEntry(im.getItem(e.key), e.value))
                  .where((e) => e.key != null)
                  .map((e) => MapEntry(e.key!, e.value))
                  .sortedBy((e) => existance(e.key.id))
                  .thenBy((e) => e.key.group.index)
                  .thenBy((e) => e.key.subgroup)
                  .thenBy((e) => e.key.rarity)
                  .thenBy((e) => e.key.name)
                  .reversed
                  .map(mapper)
                  .toList(),
            ),
          ),
        ],
      );
    }

    return GsDataBox.info(
      bgColor: bgColor,
      title: Text(context.labels.materials()),
      child: Table(
        columnWidths: const {
          0: IntrinsicColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder(
          horizontalInside: BorderSide(
            color: context.themeColors.divider,
            width: 0.4,
          ),
        ),
        children: [
          getTableRow(
            context.labels.ascension(),
            ascMats,
            (e) => ItemGridWidget.material(e.key, label: e.value.compact()),
          ),
          getTableRow(
            context.labels.talents(),
            tltMats,
            (e) => ItemGridWidget.material(e.key, label: e.value.compact()),
          ),
        ],
      ),
    );
  }
}
