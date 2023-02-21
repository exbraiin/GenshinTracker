import 'package:tracker/domain/gs_domain.dart';

class SaveReputation implements IdSaveData {
  @override
  final String id;
  final int reputation;

  SaveReputation({
    required this.id,
    required this.reputation,
  });

  SaveReputation.fromJsonData(JsonData data)
      : id = data.getString('id'),
        reputation = data.getInt('reputation');

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'reputation': reputation,
      };
}
