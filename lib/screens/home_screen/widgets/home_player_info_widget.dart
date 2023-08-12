import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_spacing.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/common/widgets/gs_no_results_state.dart';
import 'package:tracker/common/widgets/gs_number_field.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/common/widgets/value_notifier_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/remote/enka_service.dart';
import 'package:tracker/screens/characters_screen/character_details_screen.dart';
import 'package:tracker/theme/theme.dart';

class HomePlayerInfoWidget extends StatelessWidget {
  const HomePlayerInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final info = GsUtils.playerConfigs.getPlayerInfo();
    return ValueNotifierBuilder<bool>(
      value: false,
      builder: (context, notifier, child) {
        final busy = notifier.value;
        return ValueStreamBuilder<bool>(
          stream: GsDatabase.instance.loaded,
          builder: (context, snapshot) {
            final hasValidId = info?.uid.length == 9;
            return GsDataBox.info(
              title: Row(
                children: [
                  const Text('Player Info'),
                  Expanded(
                    child: GsNumberField(
                      enabled: !busy,
                      length: 9,
                      align: TextAlign.right,
                      onDbUpdate: () {
                        final info = GsUtils.playerConfigs.getPlayerInfo();
                        return int.tryParse(info?.uid ?? '') ?? 0;
                      },
                      onUpdate: (i) {
                        if (info?.uid == i.toString()) return;
                        if (i.toString().length != 9) {
                          GsUtils.playerConfigs.deletePlayerInfo();
                          return;
                        }
                        _fetchAndInsert(i.toString());
                      },
                    ),
                  ),
                  busy
                      ? Container(
                          width: 24,
                          height: 24,
                          margin: const EdgeInsets.all(8),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : IconButton(
                          color: Colors.white,
                          disabledColor: context.themeColors.dimWhite,
                          onPressed: info != null && hasValidId
                              ? () {
                                  notifier.value = true;
                                  _fetchAndInsert(info.uid).whenComplete(
                                    () => notifier.value = false,
                                  );
                                }
                              : null,
                          icon: const Icon(Icons.refresh_rounded),
                        ),
                ],
              ),
              child: info == null || info.nickname.isEmpty
                  ? const GsNoResultsState.small()
                  : _getWidgetContent(context, info),
            );
          },
        );
      },
    );
  }

  Widget _getWidgetContent(BuildContext context, SavePlayerInfo info) {
    final char = GsDatabase.instance.infoCharacters
        .getItems()
        .firstOrNullWhere((c) => c.enkaId == info.avatarId);
    final child = DefaultTextStyle(
      style: context.textTheme.bodyMedium?.copyWith(color: Colors.white) ??
          const TextStyle(color: Colors.white),
      child: Column(
        children: [
          Row(
            children: [
              ItemRarityBubble(
                size: 80,
                rarity: char?.rarity ?? 4,
                image: GsUtils.characters.getImage(char?.id ?? ''),
              ),
              const SizedBox(width: kSeparator8),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: info.nickname,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '\nAR ${info.level}  |  WL ${info.worldLevel}',
                        style: TextStyle(
                          color: context.themeColors.dimWhite,
                        ),
                      ),
                      TextSpan(
                        text: '\n${info.signature}',
                        style: TextStyle(
                          color: context.themeColors.dimWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: kSeparator8),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Achievements   ',
                      style: TextStyle(
                        color: context.themeColors.dimWhite,
                      ),
                    ),
                    TextSpan(text: info.achievements.format()),
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '\nAbyss    ',
                          style: TextStyle(
                            color: context.themeColors.dimWhite,
                          ),
                        ),
                        TextSpan(
                          text: '${info.towerFloor}-${info.towerChamber}',
                        ),
                      ],
                    ),
                  ],
                ),
                textAlign: TextAlign.end,
              ),
            ],
          ),
          const SizedBox(height: kSeparator8),
          Wrap(
            spacing: kSeparator4,
            runSpacing: kSeparator4,
            alignment: WrapAlignment.center,
            children: info.avatars.entries.map((e) {
              final char = GsDatabase.instance.infoCharacters
                  .getItems()
                  .firstOrNullWhere((c) => c.enkaId == e.key);
              return ItemRarityBubble.withLabel(
                label: e.value.format(),
                rarity: char?.rarity ?? 4,
                image: GsUtils.characters.getImage(char?.id ?? ''),
                onTap: char != null
                    ? () => Navigator.of(context).pushNamed(
                          CharacterDetailsScreen.id,
                          arguments: char,
                        )
                    : null,
              );
            }).toList(),
          ),
        ],
      ),
    );

    return FutureBuilder<String>(
      future: EnkaService.i.getNamecardUrl(info.namecardId),
      builder: (context, snaphot) {
        final url = snaphot.data;
        return Container(
          decoration: url != null
              ? BoxDecoration(
                  borderRadius: kMainRadius,
                  image: DecorationImage(
                    image: NetworkImage(url),
                    fit: BoxFit.cover,
                    opacity: 0.5,
                  ),
                )
              : null,
          padding: const EdgeInsets.all(kSeparator4),
          child: child,
        );
      },
    );
  }
}

Future<void> _fetchAndInsert(String uid) async {
  final player = await EnkaService.i.getPlayerInfo(uid);
  final item = SavePlayerInfo.fromEnkaInfo(player);
  GsDatabase.instance.saveUserConfigs.insertItem(item);
}
