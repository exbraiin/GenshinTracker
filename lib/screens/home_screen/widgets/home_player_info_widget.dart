import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_spacing.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/gs_no_results_state.dart';
import 'package:tracker/common/widgets/gs_number_field.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/common/widgets/value_notifier_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/remote/enka_service.dart';
import 'package:tracker/screens/widgets/item_info_widget.dart';
import 'package:tracker/theme/theme.dart';

class HomePlayerInfoWidget extends StatelessWidget {
  const HomePlayerInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueNotifierBuilder<bool>(
      value: false,
      builder: (context, notifier, child) {
        final busy = notifier.value;
        return ValueStreamBuilder<bool>(
          stream: Database.instance.loaded,
          builder: (context, snapshot) {
            final info = GsUtils.playerConfigs.getPlayerInfo();
            final hasValidId = info?.uid.length == 9;
            return GsDataBox.info(
              title: Row(
                children: [
                  Text(context.labels.cardPlayerInfo()),
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

  Widget _getWidgetContent(BuildContext context, GiPlayerInfo info) {
    final child = DefaultTextStyle(
      style: context.textTheme.bodyMedium?.copyWith(color: Colors.white) ??
          const TextStyle(color: Colors.white),
      child: Column(
        children: [
          Row(
            children: [
              FutureBuilder(
                future: EnkaService.i.getProfilePictureUrl(info.avatarId),
                builder: (context, snapshot) {
                  return Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    foregroundDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2,
                        color: context.themeColors.almostWhite,
                      ),
                    ),
                    child: ItemGridWidget(
                      rarity: 0,
                      size: ItemSize.large,
                      urlImage: snapshot.data ?? '',
                    ),
                  );
                },
              ),
              const SizedBox(width: kSeparator8),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info.nickname,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${context.labels.cardPlayerAr(info.level)}  |  '
                      '${context.labels.cardPlayerWl(info.worldLevel)}',
                      maxLines: 1,
                      style: TextStyle(
                        color: context.themeColors.dimWhite,
                      ),
                    ),
                    Text(
                      info.signature,
                      maxLines: 1,
                      style: TextStyle(
                        color: context.themeColors.dimWhite,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: kSeparator8),
              _playerInfoTable(context, info),
            ],
          ),
          const SizedBox(height: kSeparator8),
          ...info.avatars.entries.chunked(6).map<Widget>((list) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: list
                  .map((e) {
                    final char = Database.instance
                        .infoOf<GsCharacter>()
                        .items
                        .firstOrNullWhere((c) => c.enkaId == e.key);
                    if (char == null) return const SizedBox();
                    return ItemGridWidget.character(
                      char,
                      size: ItemSize.medium,
                    );
                  })
                  .separate(const SizedBox(width: kGridSeparator))
                  .toList(),
            );
          }).separate(const SizedBox(height: kGridSeparator)),
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
                  borderRadius: kGridRadius,
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

  Widget _playerInfoTable(BuildContext context, GiPlayerInfo info) {
    final labelStyle = TextStyle(color: context.themeColors.dimWhite);
    const valueStyle = TextStyle(
      shadows: [BoxShadow(blurRadius: 2, offset: Offset(2, 2))],
    );

    return Table(
      columnWidths: const {
        0: IntrinsicColumnWidth(),
        1: FixedColumnWidth(kSeparator8),
        2: IntrinsicColumnWidth(),
      },
      children: [
        TableRow(
          children: [
            Text(
              context.labels.cardPlayerAchievements(),
              textAlign: TextAlign.end,
              style: labelStyle,
            ),
            const SizedBox.shrink(),
            Text(
              context.labels
                  .cardPlayerAchievementsValue(info.achievements.format()),
              textAlign: TextAlign.end,
              style: valueStyle,
            ),
          ],
        ),
        TableRow(
          children: [
            Text(
              context.labels.cardPlayerAbyss(),
              textAlign: TextAlign.end,
              style: labelStyle,
            ),
            const SizedBox.shrink(),
            Text(
              context.labels.cardPlayerAbyssValue(
                info.towerFloor,
                info.towerChamber,
                info.towerStars,
              ),
              textAlign: TextAlign.end,
              style: valueStyle,
            ),
          ],
        ),
        TableRow(
          children: [
            Text(
              context.labels.cardPlayerTheater(),
              textAlign: TextAlign.end,
              style: labelStyle,
            ),
            const SizedBox.shrink(),
            Text(
              context.labels.cardPlayerTheaterValue(
                info.theaterAct,
                info.theaterStars,
              ),
              textAlign: TextAlign.end,
              style: valueStyle,
            ),
          ],
        ),
      ],
    );
  }
}

Future<void> _fetchAndInsert(String uid) async {
  final player = await EnkaService.i.getPlayerInfo(uid);
  final item = GiPlayerInfo(
    id: GsUtils.playerConfigs.kPlayerInfo,
    uid: uid,
    avatarId: player.pfpId,
    nickname: player.nickname,
    signature: player.signature,
    level: player.level,
    worldLevel: player.worldLevel,
    namecardId: player.namecardId,
    achievements: player.achievements,
    towerFloor: player.towerFloor,
    towerChamber: player.towerChamber,
    towerStars: player.towerStar,
    theaterAct: player.theaterAct,
    theaterMode: player.theaterMode,
    theaterStars: player.theaterStar,
    avatars: player.avatars,
  );
  Database.instance.saveOf<GiPlayerInfo>().setItem(item);
}
