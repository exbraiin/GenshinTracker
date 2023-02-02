import 'package:tracker/domain/gs_domain.dart';

class SaveCharacter implements IdSaveData {
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

  factory SaveCharacter.fromMap(Map<String, dynamic> map) {
    return SaveCharacter(
      id: map['id'],
      owned: map['owned'] ?? 0,
      outfit: map['outfit'] ?? '',
      ascension: map['ascension'] ?? 0,
      friendship: map['friendship'] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'owned': owned,
        'outfit': outfit,
        'ascension': ascension,
        'friendship': friendship,
      };

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
