import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/domain/gs_domain.dart';

class SaveSpincrystal extends GsModel<SaveSpincrystal> {
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
  SaveSpincrystal copyWith({
    bool? obtained,
  }) {
    return SaveSpincrystal(
      id: id,
      obtained: obtained ?? this.obtained,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'obtained': obtained,
      };
}
