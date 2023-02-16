import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';
import 'package:tracker/domain/enums/gs_weekday.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/theme/theme.dart';

class WeeklyScreen extends StatefulWidget {
  static const id = 'weekly_screen';

  const WeeklyScreen({super.key});

  @override
  State<WeeklyScreen> createState() => _WeeklyScreenState();
}

class _WeeklyScreenState extends State<WeeklyScreen> {
  var _owned = false;
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

    return Scaffold(
      appBar: GsAppBar(
        label: context.fromLabel(Labels.weeklyTasks),
        actions: [
          IconButton(
            icon: Icon(
              _owned ? Icons.visibility_rounded : Icons.visibility_off_rounded,
              color: Colors.white.withOpacity(0.5),
            ),
            onPressed: () => setState(() => _owned = !_owned),
          ),
          _getDropdown(context, now),
        ],
      ),
      body: Container(
        decoration: kMainBgDecoration,
        child: ListView(
          padding: const EdgeInsets.all(kSeparator4),
          children: materials
              .map<Widget>((e) {
                return GsDataBox.info(
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
                          const SizedBox(width: kSeparator4),
                          Text(
                            e.name,
                            style: context.textTheme.bigTitle3,
                          ),
                        ],
                      ),
                      const Divider(color: GsColors.dimWhite),
                      Wrap(
                        spacing: kSeparator4,
                        runSpacing: kSeparator4,
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: ic
                            .getItems()
                            .where(
                              (char) => GsDatabase.instance.infoCharactersInfo
                                  .getAllMaterials(char.id)
                                  .containsKey(e.id),
                            )
                            .where(
                              (e) =>
                                  !_owned ||
                                  GsUtils.characters.hasCaracter(e.id),
                            )
                            .sortedByDescending((element) => element.rarity)
                            .thenBy((element) => element.name)
                            .map((info) {
                          final exists =
                              GsUtils.characters.hasCaracter(info.id);
                          return Opacity(
                            opacity: exists ? 1 : kDisableOpacity,
                            child: ItemRarityBubble(
                              image: info.image,
                              rarity: info.rarity,
                              tooltip: info.name,
                              size: 60,
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
                            .where(
                              (weapon) => GsDatabase.instance.infoWeaponsInfo
                                  .getAscensionMaterials(weapon.id)
                                  .containsKey(e.id),
                            )
                            .where(
                              (e) => !_owned || GsUtils.weapons.hasWeapon(e.id),
                            )
                            .sortedByDescending((element) => element.rarity)
                            .thenBy((element) => element.name)
                            .map((info) {
                          return Opacity(
                            opacity: GsUtils.weapons.hasWeapon(info.id)
                                ? 1
                                : kDisableOpacity,
                            child: ItemRarityBubble(
                              image: info.image,
                              rarity: info.rarity,
                              tooltip: info.name,
                              size: 60,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              })
              .separate(const SizedBox(height: kSeparator4))
              .toList(),
        ),
      ),
    );
  }

  Padding _getDropdown(BuildContext context, int now) {
    return Padding(
      padding: const EdgeInsets.all(kSeparator4),
      child: DropdownButton(
        style: context.textTheme.description2.copyWith(color: Colors.white),
        value: _weekday - 1,
        underline: const SizedBox(),
        focusColor: Colors.transparent,
        iconEnabledColor: Colors.white,
        iconDisabledColor: Colors.white,
        items: GsWeekday.days.mapIndexed((idx, item) {
          late final color = context.themeColors.badValue;
          return DropdownMenuItem(
            value: idx,
            alignment: Alignment.center,
            child: Text(
              item,
              style: TextStyle(color: idx == now ? color : null),
            ),
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
