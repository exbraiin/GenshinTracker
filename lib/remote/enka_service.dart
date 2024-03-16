import 'dart:convert';
import 'dart:io';

import 'package:tracker/common/extensions/extensions.dart';

const _apiBaseUrl = 'https://enka.network';
const _gitBaseUrl = 'https://raw.githubusercontent.com/EnkaNetwork';

class EnkaService {
  static final i = EnkaService._();

  final _namecards = <String, dynamic>{};
  final _characters = <String, dynamic>{};
  final _profilePics = <String, dynamic>{};
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

  Future<String> getProfilePictureUrl(String pictureId) async {
    if (_profilePics.isEmpty) {
      const url = '$_gitBaseUrl/API-docs/master/store/pfps.json';
      final data = await _downloadFile(url);
      _profilePics
        ..clear()
        ..addAll(jsonDecode(data) as Map<String, dynamic>);
    }
    final alias = _profilePics[pictureId]?['iconPath'];
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
  final String pfpId;
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
    required this.pfpId,
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
    final info = (json['playerInfo'] as Map? ?? {}).cast<String, dynamic>();
    final avtInfo =
        (info['profilePicture'] as Map? ?? {}).cast<String, dynamic>();
    final avtId = (avtInfo['id'] as int? ?? 0).toString();
    final avatars = (info['showAvatarInfoList'] as List? ?? [])
        .cast<Map<String, dynamic>>();
    return EnkaPlayerInfo._(
      uid: json['uid'] as String? ?? '',
      pfpId: avtId,
      nickname: info['nickname'] as String? ?? '',
      signature: info['signature'] as String? ?? '',
      level: info['level'] as int? ?? 0,
      worldLevel: info['worldLevel'] as int? ?? 0,
      namecardId: info['nameCardId'] as int? ?? 0,
      achievements: info['finishAchievementNum'] as int? ?? 0,
      towerFloor: info['towerFloorIndex'] as int? ?? 0,
      towerChamber: info['towerLevelIndex'] as int? ?? 0,
      avatars: avatars.toMap(
        (e) => (e['avatarId'] as int? ?? 0).toString(),
        (e) => e['level'] as int? ?? 0,
      ),
    );
  }
}
