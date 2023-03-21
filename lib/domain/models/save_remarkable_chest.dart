import 'package:tracker/domain/gs_domain.dart';

class SaveRemarkableChest implements IdSaveData<SaveRemarkableChest> {
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
  SaveRemarkableChest copyWith({
    bool? obtained,
  }) {
    return SaveRemarkableChest(
      id: id,
      obtained: obtained ?? this.obtained,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'obtained': obtained,
      };

  @override
  int compareTo(SaveRemarkableChest other) {
    return id.compareTo(other.id);
  }
}
