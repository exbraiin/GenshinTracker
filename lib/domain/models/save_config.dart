import 'package:tracker/domain/gs_database.json.dart';
import 'package:tracker/domain/gs_domain.dart';

abstract class SaveConfig extends IdSaveData<SaveConfig> {
  static const kPlayerInfo = 'player_info';

  static SaveConfig fromJsonData(JsonData m) {
    switch (m.getString('id')) {
      case kPlayerInfo:
        return SavePlayerInfo.fromJsonData(m);
      default:
        return _EmptySaveConfig();
    }
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

extension SaveConfigsExt on JsonSaveDetails<SaveConfig> {
  T? getItemOrNullAs<T extends SaveConfig>() {
    const types = <Type, String>{
      SavePlayerInfo: SaveConfig.kPlayerInfo,
    };
    return getItemOrNull(types[T] ?? '') as T?;
  }
}
