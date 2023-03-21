import 'package:tracker/domain/gs_domain.dart';

class SaveSereniteaSet implements IdSaveData<SaveSereniteaSet> {
  @override
  final String id;
  final List<String> chars;

  SaveSereniteaSet({
    required this.id,
    required this.chars,
  });

  SaveSereniteaSet.fromJsonData(JsonData data)
      : id = data.getString('id'),
        chars = data.getStringList('chars');

  @override
  SaveSereniteaSet copyWith({
    List<String>? chars,
  }) {
    return SaveSereniteaSet(
      id: id,
      chars: chars ?? this.chars,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'chars': chars,
      };

  @override
  int compareTo(SaveSereniteaSet other) {
    return id.compareTo(other.id);
  }
}
