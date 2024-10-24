import 'dart:convert';

import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/utils/network.dart';

const _apiBaseUrl = 'https://enka.network';
const _gitBaseUrl = 'https://raw.githubusercontent.com/EnkaNetwork';

class EnkaService {
  static final i = EnkaService._();

  final cache = <String, JsonMap>{};

  EnkaService._();

  Future<EnkaPlayerInfo> getPlayerInfo(String uid) async {
    final url = '$_apiBaseUrl/api/uid/$uid?info';
    final data = await Network.downloadFile(url);
    final info = data != null ? jsonDecode(data) : const {};
    return EnkaPlayerInfo._fromMap(info);
  }

  Future<JsonMap> _getCache(String url) async {
    if (cache[url] == null) {
      cache[url] = <String, dynamic>{};
      final data = await Network.downloadFile(url);
      if (data != null) cache[url]?.addAll(jsonDecode(data));
    }
    return cache[url]!;
  }

  Future<String> getNamecardUrl(int namecardId) async {
    const url = '$_gitBaseUrl/API-docs/master/store/namecards.json';
    final cache = await _getCache(url);
    final alias = cache[namecardId.toString()]?['icon'];
    return '$_apiBaseUrl/ui/$alias.png';
  }

  Future<String> getCharacterUrl(int characterId) async {
    const url = '$_gitBaseUrl/API-docs/master/store/characters.json';
    final cache = await _getCache(url);
    final alias = cache[characterId.toString()]?['SideIconName'];
    return '$_apiBaseUrl/ui/$alias.png';
  }

  Future<String> getProfilePictureUrl(String pictureId) async {
    const url = '$_gitBaseUrl/API-docs/master/store/pfps.json';
    final cache = await _getCache(url);
    final alias = cache[pictureId]?['iconPath'];
    return '$_apiBaseUrl/ui/$alias.png';
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
  final int towerFloor, towerChamber, towerStar;
  final int theaterAct, theaterMode, theaterStar;
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
    required this.towerStar,
    required this.theaterAct,
    required this.theaterMode,
    required this.theaterStar,
    required this.avatars,
  });

  factory EnkaPlayerInfo._fromMap(Map<String, dynamic> json) {
    final info = (json['playerInfo'] as Map? ?? {}).cast<String, dynamic>();
    final avtInfo =
        (info['profilePicture'] as Map? ?? {}).cast<String, dynamic>();
    final avtId = avtInfo.getString('id');
    final avatars = (info['showAvatarInfoList'] as List? ?? [])
        .cast<Map<String, dynamic>>();
    return EnkaPlayerInfo._(
      uid: json.getString('uid'),
      pfpId: avtId,
      nickname: info.getString('nickname'),
      signature: info.getString('signature'),
      level: info.getInt('level'),
      worldLevel: info.getInt('worldLevel'),
      namecardId: info.getInt('nameCardId'),
      achievements: info.getInt('finishAchievementNum'),
      towerFloor: info.getInt('towerFloorIndex'),
      towerChamber: info.getInt('towerLevelIndex'),
      towerStar: info.getInt('towerStarIndex'),
      theaterAct: info.getInt('theaterActIndex'),
      theaterMode: info.getInt('theaterModeIndex'),
      theaterStar: info.getInt('theaterStarIndex'),
      avatars: avatars.toMap(
        (e) => e.getString('avatarId'),
        (e) => e.getInt('level'),
      ),
    );
  }
}

extension on JsonMap {
  int getInt(String key, [int fallback = 0]) {
    return (this[key] as num?)?.toInt() ?? fallback;
  }

  String getString(String key, [String fallback = '']) {
    return this[key]?.toString() ?? fallback;
  }
}
