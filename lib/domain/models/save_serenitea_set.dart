import 'package:tracker/domain/gs_domain.dart';

class SaveSereniteaSet implements IdSaveData {
  final String id;
  final List<String> chars;

  SaveSereniteaSet({
    required this.id,
    required this.chars,
  });

  factory SaveSereniteaSet.fromMap(Map<String, dynamic> map) {
    return SaveSereniteaSet(
      id: map['id'],
      chars: (map['chars'] as List).cast<String>(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'chars': chars,
      };
}
