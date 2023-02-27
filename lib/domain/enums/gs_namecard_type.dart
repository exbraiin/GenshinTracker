import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_domain.dart';

enum GsNamecardType implements GsEnum {
  defaultCard(
    'default',
    Labels.namecardDefault,
    menuIconWish,
  ),
  achievement(
    'achievement',
    Labels.namecardAchievement,
    menuIconAchievements,
  ),
  battlepass(
    'battlepass',
    Labels.namecardBattlepass,
    menuIconWeapons,
  ),
  character(
    'character',
    Labels.namecardCharacter,
    menuIconCharacters,
  ),
  event(
    'event',
    Labels.namecardEvent,
    menuIconFeedback,
  ),
  offering(
    'offering',
    Labels.namecardOffering,
    menuIconQuest,
  ),
  reputation(
    'reputation',
    Labels.namecardReputation,
    menuIconReputation,
  );

  @override
  final String id;
  final String label;
  final String asset;

  const GsNamecardType(this.id, this.label, this.asset);
}
