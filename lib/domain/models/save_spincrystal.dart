import 'package:tracker/domain/gs_domain.dart';

class SaveSpincrystal implements IdSaveData {
  @override
  final String id;
  final bool obtained;

  SaveSpincrystal({
    required this.id,
    required this.obtained,
  });

  SaveSpincrystal.fromJsonData(JsonData data)
      : id = data.getString('id'),
        obtained = data.getBool('obtained');

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'obtained': obtained,
      };
}
