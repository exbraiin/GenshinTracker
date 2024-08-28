import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_detailed_dialog.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/common/widgets/static/circle_widget.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/enums/enum_ext.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/widgets/item_info_widget.dart';

class EventDetailsCard extends StatelessWidget with GsDetailedDialogMixin {
  final GsEvent item;

  EventDetailsCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final weapons = GsUtils.events.getEventWeapons(item.id);
    final characters = GsUtils.events.getEventCharacters(item.id);

    return ItemDetailsCard.single(
      name: item.name,
      info: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.fromLabel(item.type.label),
            style: context.themeStyles.title18n,
          ),
        ],
      ),
      rarity: item.type == GeEventType.flagship ? 5 : 4,
      fgImage: item.image,
      banner: GsItemBanner.fromVersion(context, item.version),
      child: ItemDetailsCardContent.generate(context, [
        ItemDetailsCardContent(
          label: context.fromLabel(Labels.duration),
          description: item.dateStart.year != 0 && item.dateEnd.year != 0
              ? '${DateTimeUtils.format(context, item.dateStart, item.dateEnd)} '
                  '(${item.dateEnd.difference(item.dateStart).toShortTime(context)})'
              : context.fromLabel(Labels.itemUpcoming),
        ),
        ItemDetailsCardContent(
          label: context.fromLabel(Labels.version),
          description: item.version,
        ),
        if (weapons.isNotEmpty)
          ItemDetailsCardContent(
            label: context.fromLabel(Labels.weapons),
            content: ValueStreamBuilder(
              stream: Database.instance.loaded,
              builder: (context, snapshot) {
                return Wrap(
                  spacing: kSeparator4,
                  runSpacing: kSeparator4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: weapons.map((weapon) {
                    final marked =
                        GsUtils.events.ownsWeapon(item.id, weapon.id);
                    return _item(
                      child: ItemGridWidget.weapon(
                        weapon,
                        onTap: (context, weapon) => GsUtils.events
                            .toggleObtainedtWeapon(item.id, weapon.id),
                      ),
                      marked: marked,
                    );
                  }).toList(),
                );
              },
            ),
          ),
        if (characters.isNotEmpty)
          ItemDetailsCardContent(
            label: context.fromLabel(Labels.characters),
            content: ValueStreamBuilder(
              stream: Database.instance.loaded,
              builder: (context, snapshot) {
                return Wrap(
                  spacing: kSeparator4,
                  runSpacing: kSeparator4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: characters.map((char) {
                    final marked =
                        GsUtils.events.ownsCharacter(item.id, char.id);
                    return _item(
                      child: ItemGridWidget.character(
                        char,
                        onTap: (context, char) => GsUtils.events
                            .toggleObtainedCharacter(item.id, char.id),
                      ),
                      marked: marked,
                    );
                  }).toList(),
                );
              },
            ),
          ),
      ]),
    );
  }

  Widget _item({required Widget child, required bool marked}) {
    return Stack(
      children: [
        child,
        if (marked)
          const Positioned(
            right: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.bottomRight,
              child: CircleWidget(
                color: Colors.black,
                borderColor: Colors.white,
                borderSize: 1.6,
                size: 20,
                child: Icon(
                  Icons.check_rounded,
                  color: Colors.lightGreen,
                  size: 16,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
