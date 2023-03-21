import 'package:tracker/domain/gs_domain.dart';

class SaveMaterial extends IdSaveData<SaveMaterial> {
  @override
  final String id;
  final int amount;

  SaveMaterial({
    required this.id,
    required this.amount,
  });

  SaveMaterial.fromJsonData(JsonData data)
      : id = data.getString('id'),
        amount = data.getInt('amount');

  @override
  SaveMaterial copyWith({
    int? amount,
  }) {
    return SaveMaterial(
      id: id,
      amount: amount ?? this.amount,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'amount': amount,
      };

  @override
  int compareTo(SaveMaterial other) {
    return id.compareTo(other.id);
  }
}
