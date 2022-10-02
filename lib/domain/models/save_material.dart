import 'package:tracker/domain/gs_domain.dart';

class SaveMaterial implements IdSaveData {
  final String id;
  final int amount;

  SaveMaterial({
    required this.id,
    required this.amount,
  });

  factory SaveMaterial.fromMap(Map<String, dynamic> map) {
    return SaveMaterial(
      id: map['id'] ?? '',
      amount: map['amount'] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toMap() => {'id': id, 'amount': amount};
}
