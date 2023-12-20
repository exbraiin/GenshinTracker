import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/domain/gs_domain.dart';

class SaveAchievement extends GsModel<SaveAchievement> {
  @override
  final String id;
  final int obtained;

  SaveAchievement({
    required this.id,
    required this.obtained,
  });

  SaveAchievement.fromJsonData(JsonData data)
      : id = data.getString('id'),
        obtained = data.getInt('obtained');

  @override
  SaveAchievement copyWith({
    String? id,
    int? obtained,
  }) {
    return SaveAchievement(
      id: id ?? this.id,
      obtained: obtained ?? this.obtained,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'obtained': obtained,
      };
}
