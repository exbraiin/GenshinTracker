import 'package:tracker/domain/gs_domain.dart';

class SaveSereniteaSet implements IdSaveData {
  final String id;
  final List<String> chars;

  SaveSereniteaSet({
    required this.id,
    required this.chars,
  });

  factory SaveSereniteaSet.fromMap(String id, Map<String, dynamic> map) {
    return SaveSereniteaSet(
      id: id,
      chars: (map['chars'] as List).cast<String>(),
    );
  }

  Map<String, dynamic> toMap() => {
        'chars': chars,
      };
}
