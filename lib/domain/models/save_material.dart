import 'package:tracker/domain/gs_domain.dart';

class SaveMaterial implements IdSaveData {
  final String id;
  final int amount;

  SaveMaterial({
    required this.id,
    required this.amount,
  });

  factory SaveMaterial.fromMap(String id, Map<String, dynamic> map) {
    return SaveMaterial(
      id: id,
      amount: map['amount'] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'amount': amount,
      };
}
