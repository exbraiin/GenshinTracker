import 'package:tracker/domain/gs_domain.dart';

class SaveReputation implements IdSaveData {
  @override
  final String id;
  final int reputation;

  SaveReputation({
    required this.id,
    required this.reputation,
  });

  factory SaveReputation.fromMap(Map<String, dynamic> map) {
    return SaveReputation(
      id: map['id'],
      reputation: map['reputation'],
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'reputation': reputation,
      };
}
