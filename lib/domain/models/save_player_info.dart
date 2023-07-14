import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/remote/enka_service.dart';

class SavePlayerInfo extends SaveConfig {
  @override
  final String id = SaveConfig.kPlayerInfo;
  final String uid;
  final String avatarId;
  final String nickname;
  final String signature;
  final int level;
  final int worldLevel;
  final int namecardId;
  final int achievements;
  final int towerFloor;
  final int towerChamber;
  final Map<String, int> avatars;

  SavePlayerInfo({
    this.uid = '',
    this.avatarId = '',
    this.nickname = '',
    this.signature = '',
    this.level = 0,
    this.worldLevel = 0,
    this.namecardId = 0,
    this.achievements = 0,
    this.towerFloor = 0,
    this.towerChamber = 0,
    this.avatars = const {},
  });

  SavePlayerInfo.fromJsonData(JsonData m)
      : uid = m.getString('uid'),
        avatarId = m.getString('avatar_id'),
        nickname = m.getString('nickname'),
        signature = m.getString('signature'),
        level = m.getInt('level'),
        worldLevel = m.getInt('world_level'),
        namecardId = m.getInt('namecard'),
        achievements = m.getInt('achievements'),
        towerFloor = m.getInt('tower_floor'),
        towerChamber = m.getInt('tower_chamber'),
        avatars = m.getMap<String, int>('avatars');

  SavePlayerInfo.fromEnkaInfo(EnkaPlayerInfo player)
      : uid = player.uid,
        avatarId = player.avatarId,
        nickname = player.nickname,
        signature = player.signature,
        level = player.level,
        worldLevel = player.worldLevel,
        namecardId = player.namecardId,
        achievements = player.achievements,
        towerFloor = player.towerFloor,
        towerChamber = player.towerChamber,
        avatars = player.avatars;

  @override
  SavePlayerInfo copyWith({
    String? uid,
    String? avatarId,
    String? nickname,
    String? signature,
    int? level,
    int? worldLevel,
    int? namecardId,
    int? achievements,
    int? towerFloor,
    int? towerChamber,
    Map<String, int>? avatars,
  }) {
    return SavePlayerInfo(
      uid: uid ?? this.uid,
      avatarId: avatarId ?? this.avatarId,
      nickname: nickname ?? this.nickname,
      signature: signature ?? this.signature,
      level: level ?? this.level,
      worldLevel: worldLevel ?? this.worldLevel,
      namecardId: namecardId ?? this.namecardId,
      achievements: achievements ?? this.achievements,
      towerFloor: towerFloor ?? this.towerFloor,
      towerChamber: towerChamber ?? this.towerChamber,
      avatars: avatars ?? this.avatars,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'uid': uid,
        'avatar_id': avatarId,
        'nickname': nickname,
        'signature': signature,
        'level': level,
        'world_level': worldLevel,
        'namecard': namecardId,
        'achievements': achievements,
        'tower_floor': towerFloor,
        'tower_chamber': towerChamber,
        'avatars': avatars,
      };
}
