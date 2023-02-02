import 'package:tracker/domain/gs_domain.dart';

class SaveRemarkableChest implements IdSaveData {
  @override
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

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'obtained': obtained,
      };
}
