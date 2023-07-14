import 'dart:convert';
import 'dart:io';

import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/domain/gs_domain.dart';

const _apiBaseUrl = 'https://enka.network';
const _gitBaseUrl = 'https://raw.githubusercontent.com/EnkaNetwork';

class EnkaService {
  static final i = EnkaService._();

  final _namecards = <String, dynamic>{};
  final _characters = <String, dynamic>{};
  EnkaService._();

  Future<EnkaPlayerInfo> getPlayerInfo(String uid) async {
    final url = '$_apiBaseUrl/api/uid/$uid?info';
    final data = await _downloadFile(url);
    final info = jsonDecode(data) as Map<String, dynamic>;
    return EnkaPlayerInfo._fromMap(info);
  }

  Future<String> getNamecardUrl(int namecardId) async {
    if (_namecards.isEmpty) {
      const url = '$_gitBaseUrl/API-docs/master/store/namecards.json';
      final data = await _downloadFile(url);
      _namecards.clear();
      _namecards.addAll(jsonDecode(data) as Map<String, dynamic>);
    }
    final alias = _namecards[namecardId.toString()]?['icon'];
    return '$_apiBaseUrl/ui/$alias.png';
  }

  Future<String> getCharacterUrl(int characterId) async {
    if (_characters.isEmpty) {
      const url = '$_gitBaseUrl/API-docs/master/store/characters.json';
      final data = await _downloadFile(url);
      _characters.clear();
      _characters.addAll(jsonDecode(data) as Map<String, dynamic>);
    }
    final alias = _characters[characterId.toString()]?['SideIconName'];
    return '$_apiBaseUrl/ui/$alias.png';
  }

  Future<String> _downloadFile(String url) {
    final client = HttpClient();
    try {
      return client
          .getUrl(Uri.parse(url))
          .then((value) => value.close())
          .then((value) => value.transform(utf8.decoder).join());
    } finally {
      client.close();
    }
  }
}

class EnkaPlayerInfo {
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

  EnkaPlayerInfo._({
    required this.uid,
    required this.avatarId,
    required this.nickname,
    required this.signature,
    required this.level,
    required this.worldLevel,
    required this.namecardId,
    required this.achievements,
    required this.towerFloor,
    required this.towerChamber,
    required this.avatars,
  });

  factory EnkaPlayerInfo._fromMap(Map<String, dynamic> json) {
    final m = JsonData(json);
    final info = JsonData(m.getDataOrDefault('playerInfo', const {}));
    final avtInfo = JsonData(info.getDataOrDefault('profilePicture', const {}));
    final avtId = avtInfo.getInt('avatarId').toString();
    final avatars = info
        .getDataOrDefault('showAvatarInfoList', const [])
        .cast<Map<String, dynamic>>()
        .map(JsonData.new);
    return EnkaPlayerInfo._(
      uid: m.getString('uid'),
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
}
