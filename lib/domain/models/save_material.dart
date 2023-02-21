import 'package:tracker/domain/gs_domain.dart';

class SaveMaterial implements IdSaveData {
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
  Map<String, dynamic> toMap() => {
        'id': id,
        'amount': amount,
      };
}
