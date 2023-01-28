import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/cards/gs_rarity_item_card.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';
import 'package:tracker/domain/enums/gs_weekday.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/characters_screen/character_details_screen.dart';
import 'package:tracker/screens/weapons_screen/weapon_details_screen.dart';

class WeeklyScreen extends StatefulWidget {
  static const id = 'weekly_screen';

  @override
  State<WeeklyScreen> createState() => _WeeklyScreenState();
}

class _WeeklyScreenState extends State<WeeklyScreen> {
  var _weekday = 0;

  @override
  void initState() {
    super.initState();
    _weekday = DateTime.now().weekday;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().weekday - 1;
    final name = GsWeekday.days[_weekday - 1];
    final materials = GsDatabase.instance.infoMaterials
        .getItems()
        .where((element) => element.weekdays.contains(name))
        .groupBy((e) => '${e.group}-${e.subgroup}')
        .entries
        .map((e) => e.value.sortedBy((r) => r.rarity).first);

    final ic = GsDatabase.instance.infoCharacters;
    final iw = GsDatabase.instance.infoWeapons;
    final sw = GsDatabase.instance.saveWishes;

    return Scaffold(
      appBar: GsAppBar(
        label: context.fromLabel(Labels.weeklyTasks),
        actions: [
          _getDropdown(context, now),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(kSeparator4),
        children: materials
            .map<Widget>((e) {
              return GsDataBox.summary(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: CachedImageWidget(e.image),
                        ),
                        SizedBox(width: kSeparator4),
                        Text(
                          e.name,
                          style: context.textTheme.bigTitle3,
                        ),
                      ],
                    ),
                    Divider(color: GsColors.dimWhite),
                    Wrap(
                      spacing: kSeparator4,
                      runSpacing: kSeparator4,
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: ic
                          .getItems()
                          .where((char) => GsDatabase
                              .instance.infoCharactersInfo
                              .getAllMaterials(char.id)
                              .containsKey(e.id))
                          .sortedBy((element) => element.rarity)
                          .thenBy((element) => element.name)
                          .map((info) {
                        final exists = GsUtils.characters.hasCaracter(info.id);
                        final ascension =
                            GsUtils.characters.getCharAscension(info.id);
                        return Opacity(
                          opacity: exists ? 1 : kDisableOpacity,
                          child: GsRarityItemCard.withLabels(
                            labelFooter: info.name,
                            image: info.image,
                            rarity: info.rarity,
                            labelHeader: exists ? '$ascension ✦' : '',
                            onTap: () => Navigator.of(context).pushNamed(
                              CharacterDetailsScreen.id,
                              arguments: info,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    Wrap(
                      spacing: kSeparator4,
                      runSpacing: kSeparator4,
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: iw
                          .getItems()
                          .where((weapon) => GsDatabase.instance.infoWeaponsInfo
                              .getAscensionMaterials(weapon.id)
                              .containsKey(e.id))
                          .sortedBy((element) => element.rarity)
                          .thenBy((element) => element.name)
                          .map((info) => Opacity(
                                opacity:
                                    sw.hasWeapon(info.id) ? 1 : kDisableOpacity,
                                child: GsRarityItemCard.withLabels(
                                  labelFooter: info.name,
                                  image: info.image,
                                  rarity: info.rarity,
                                  onTap: () => Navigator.of(context).pushNamed(
                                    WeaponDetailsScreen.id,
                                    arguments: info,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              );
            })
            .separate(SizedBox(height: kSeparator4))
            .toList(),
      ),
    );
  }

  Padding _getDropdown(BuildContext context, int now) {
    return Padding(
      padding: const EdgeInsets.all(kSeparator4),
      child: DropdownButton(
        style: context.textTheme.description2.copyWith(color: Colors.white),
        value: _weekday - 1,
        underline: SizedBox(),
        focusColor: Colors.transparent,
        iconEnabledColor: Colors.white,
        iconDisabledColor: Colors.white,
        items: GsWeekday.days.mapIndexed((idx, item) {
          return DropdownMenuItem(
            child: Text(
              item,
              style: TextStyle(color: idx == now ? GsColors.missing : null),
            ),
            value: idx,
            alignment: Alignment.center,
          );
        }).toList(),
        onChanged: (int? i) => setState(() => _weekday = (i ?? 0) + 1),
        alignment: Alignment.center,
        borderRadius: kMainRadius,
        elevation: 1,
      ),
    );
  }
}
