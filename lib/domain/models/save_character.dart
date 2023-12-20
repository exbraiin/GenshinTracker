import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/domain/gs_domain.dart';

class SaveCharacter extends GsModel<SaveCharacter> {
  @override
  final String id;
  final String outfit;
  final int owned;
  final int ascension;
  final int friendship;

  SaveCharacter({
    required this.id,
    this.owned = 0,
    this.outfit = '',
    this.ascension = 0,
    this.friendship = 1,
  });

  SaveCharacter.fromJsonData(JsonData data)
      : id = data.getString('id'),
        outfit = data.getString('outfit'),
        owned = data.getInt('owned'),
        ascension = data.getInt('ascension'),
        friendship = data.getInt('friendship');

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'owned': owned,
        'outfit': outfit,
        'ascension': ascension,
        'friendship': friendship,
      };

  @override
  SaveCharacter copyWith({
    int? owned,
    int? ascension,
    int? friendship,
    String? outfit,
  }) {
    return SaveCharacter(
      id: id,
      owned: owned ?? this.owned,
      outfit: outfit ?? this.outfit,
      ascension: ascension ?? this.ascension,
      friendship: friendship ?? this.friendship,
    );
  }
}
