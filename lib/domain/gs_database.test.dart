import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

typedef _VoidCallback = void Function();

class AchievementsData {
  final _map = <AchievementCategory>[];

  int get total => _map.expand((g) => g.groups.expand((r) => r.list)).length;

  Future<void> read() async {
    final src = await File('db/achievements.json').readAsString();
    final obj = (jsonDecode(src) as Map)['achievements'];
    _map.addAll((obj as List).map((e) => AchievementCategory.fromMap(e)));
  }

  Iterable<AchievementCategory> getItems() => _map.toList();
}

class AchievementsSaveData {
  final _ids = <int>{};
  final _VoidCallback onSave;

  int get total => _ids.length;

  AchievementsSaveData(this.onSave);

  void saveAchievement(int id, bool own) {
    if (own ? _ids.add(id) : _ids.remove(id)) {
      if (!own) _validateGroup(id);
      onSave.call();
    }
  }

  void _validateGroup(int id) {
    final categories = GsDatabase.instance.infoAchievements.getItems();
    for (var category in categories) {
      for (var group in category.groups) {
        final idx = group.list.indexWhere((e) => e.id == id);
        if (idx == -1) continue;
        for (var i = idx + 1; i < group.list.length; ++i) {
          _ids.remove(group.list[i].id);
        }
        return;
      }
    }
  }

  bool saved(int id) => _ids.contains(id);

  int owned(AchievementCategory item) =>
      item.groups.expand((e) => e.list).where((e) => saved(e.id)).length;
}

class AchievementCategory {
  final String name;
  final List<AchievementGroup> groups;

  int get total => groups.expand((e) => e.list).length;

  AchievementCategory._({
    required this.name,
    required this.groups,
  });

  factory AchievementCategory.fromMap(Map map) => AchievementCategory._(
        name: map['name'],
        groups: (map['achievements'] as List)
            .map((e) => AchievementGroup.fromList(e))
            .toList(),
      );
}

class AchievementGroup {
  final List<Achievement> list;
  AchievementGroup._({required this.list});

  factory AchievementGroup.fromList(List list) {
    final data = list.map((e) => Achievement.fromMap(e)).toList();
    return AchievementGroup._(list: data);
  }
}

class Achievement {
  final int id;
  final int reward;
  final String name;
  final String desc;
  final String version;

  Achievement._({
    required this.id,
    required this.reward,
    required this.name,
    required this.desc,
    required this.version,
  });

  factory Achievement.fromMap(Map map) => Achievement._(
        id: map['id'],
        reward: map['reward'],
        name: map['name'],
        desc: map['desc'],
        version: map['ver'],
      );
}

// =============================================================================

class JsonDetailsData {
  final _artifacts = <String, InfoArtifactDetails>{};
  final _characters = <String, InfoCharacterDetails>{};
  final _ascensionHerosWit = <int>[];

  Future<void> read() async {
    final path = kDebugMode
        ? 'D:/Software/Tracker_Genshin/db/details.json'
        : 'db/details.json';

    final file = File(path);
    final data = jsonDecode(await file.readAsString()) as Map<String, dynamic>;

    final characters = data['characters'] as Map<String, dynamic>;
    characters.entries
        .map((e) => InfoCharacterDetails.fromMap(e.key, e.value))
        .forEach((e) => _characters[e.id] = e);

    final artifacts = data['artifacts'] as Map<String, dynamic>;
    artifacts.entries
        .map((e) => InfoArtifactDetails.fromMap(e.key, e.value))
        .forEach((e) => _artifacts[e.id] = e);

    final values = (data['ascension_heros_wit'] as List).cast<int>();
    _ascensionHerosWit.addAll(values);
  }

  int getAscensionHerosWit(int level) => _ascensionHerosWit[level];

  InfoCharacterDetails getCharItem(String id) => _characters[id]!;
  InfoCharacterDetails? getCharItemOrNull(String id) => _characters[id];
  bool existsChar(String id) => _characters.containsKey(id);
  Iterable<InfoCharacterDetails> getCharItems() => _characters.values;

  InfoArtifactDetails getArtfItem(String id) => _artifacts[id]!;
  InfoArtifactDetails? getArtfItemOrNull(String id) => _artifacts[id];
  bool existsArtf(String id) => _artifacts.containsKey(id);
  Iterable<InfoArtifactDetails> getArtfItems() => _artifacts.values;
}
