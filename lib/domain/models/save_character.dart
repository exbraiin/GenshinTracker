import 'package:tracker/domain/gs_domain.dart';

class SaveCharacter implements IdSaveData {
  final String id;
  final int owned;
  final int ascension;
  final int friendship;

  SaveCharacter({
    required this.id,
    this.owned = 0,
    this.ascension = 0,
    this.friendship = 1,
  });

  factory SaveCharacter.fromMap(String id, Map<String, dynamic> map) {
    return SaveCharacter(
      id: id,
      owned: map['owned'],
      ascension: map['ascension'],
      friendship: map['friendship'],
    );
  }

  Map<String, dynamic> toMap() => {
        'owned': owned,
        'ascension': ascension,
        'friendship': friendship,
      };

  SaveCharacter copyWith({
    int? owned,
    int? ascension,
    int? friendship,
  }) {
    return SaveCharacter(
      id: id,
      owned: owned ?? this.owned,
      ascension: ascension ?? this.ascension,
      friendship: friendship ?? this.friendship,
    );
  }
}
