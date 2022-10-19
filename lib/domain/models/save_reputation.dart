import 'package:tracker/domain/gs_domain.dart';

class SaveReputation implements IdSaveData {
  final String id;
  final int reputation;

  SaveReputation({
    required this.id,
    required this.reputation,
  });

  factory SaveReputation.fromMap(String id, Map<String, dynamic> map) {
    return SaveReputation(
      id: id,
      reputation: map['reputation'],
    );
  }

  Map<String, dynamic> toMap() => {
        'reputation': reputation,
      };
}
