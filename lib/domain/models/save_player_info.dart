import 'dart:convert';
import 'dart:io';

import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/domain/gs_domain.dart';

class SavePlayerInfo implements IdSaveData<SavePlayerInfo> {
  @override
  final String id;
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
    required this.id,
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
      : id = m.getString('id'),
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

  factory SavePlayerInfo.fromRequestMap(JsonData m) {
    final info = JsonData(m.getDataOrDefault('playerInfo', const {}));
    final avtInfo = JsonData(info.getDataOrDefault('profilePicture', const {}));
    final avtId = avtInfo.getInt('avatarId').toString();
    final avatars = info
        .getDataOrDefault('showAvatarInfoList', const [])
        .cast<Map<String, dynamic>>()
        .map(JsonData.new);
    return SavePlayerInfo(
      id: m.getString('uid'),
      avatarId: avtId,
      nickname: info.getString('nickname'),
      signature: info.getString('signature'),
      level: info.getInt('level'),
      worldLevel: info.getInt('worldLevel'),
      namecardId: info.getInt('nameCardId'),
      achievements: info.getInt('finishAchievementNum'),
      towerFloor: info.getInt('towerFloorIndex'),
      towerChamber: info.getInt('towerLevelIndex'),
      avatars: avatars.toMap(
        (e) => e.getInt('avatarId').toString(),
        (e) => e.getInt('level'),
      ),
    );
  }

  static Future<SavePlayerInfo> fetchEnkaPlayerInfo(String uid) async {
    final url = 'https://enka.network/api/uid/$uid?info';
    final client = HttpClient();
    final request = await client.getUrl(Uri.parse(url));
    final response = await request.close();
    final data = await response.transform(utf8.decoder).join();
    client.close();
    final info = JsonData(jsonDecode(data) as Map<String, dynamic>);
    return SavePlayerInfo.fromRequestMap(info);
  }

  @override
  SavePlayerInfo copyWith({
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
      id: id,
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

  @override
  int compareTo(SavePlayerInfo other) {
    return id.compareTo(other.id);
  }
}
