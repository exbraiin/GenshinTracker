import 'package:tracker/domain/gs_domain.dart';

class SaveRemarkableChest implements IdSaveData {
  @override
  final String id;
  final bool obtained;

  SaveRemarkableChest({
    required this.id,
    required this.obtained,
  });

  SaveRemarkableChest.fromJsonData(JsonData data)
      : id = data.getString('id'),
        obtained = data.getBool('obtained');

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'obtained': obtained,
      };
}
