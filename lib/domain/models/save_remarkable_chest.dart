import 'package:tracker/domain/gs_domain.dart';

class SaveRemarkableChest implements IdSaveData {
  final String id;
  final bool obtained;

  SaveRemarkableChest({
    required this.id,
    required this.obtained,
  });

  factory SaveRemarkableChest.fromMap(Map<String, dynamic> map) {
    return SaveRemarkableChest(
      id: map['id'],
      obtained: map['obtained'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'obtained': obtained,
      };
}
