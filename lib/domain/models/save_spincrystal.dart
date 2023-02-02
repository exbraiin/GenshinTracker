import 'package:tracker/domain/gs_domain.dart';

class SaveSpincrystal implements IdSaveData {
  @override
  final String id;
  final bool obtained;

  SaveSpincrystal({
    required this.id,
    required this.obtained,
  });

  factory SaveSpincrystal.fromMap(Map<String, dynamic> map) {
    return SaveSpincrystal(
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
