import 'package:tracker/domain/gs_domain.dart';

abstract class SaveConfig extends IdSaveData<SaveConfig> {
  static const kPlayerInfo = 'player_info';

  static SaveConfig fromJsonData(JsonData m) {
    return switch (m.getString('id')) {
      kPlayerInfo => SavePlayerInfo.fromJsonData(m),
      _ => _EmptySaveConfig()
    };
  }
}

class _EmptySaveConfig extends SaveConfig {
  @override
  final String id = '';
  @override
  SaveConfig copyWith() => _EmptySaveConfig();

  @override
  Map<String, dynamic> toMap() => {};
}
