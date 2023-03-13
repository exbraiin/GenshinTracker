import 'package:tracker/domain/gs_domain.dart';

class SaveRecipe implements IdSaveData<SaveRecipe> {
  @override
  final String id;
  final int proficiency;

  SaveRecipe({
    required this.id,
    required this.proficiency,
  });

  SaveRecipe.fromJsonData(JsonData data)
      : id = data.getString('id'),
        proficiency = data.getInt('proficiency');

  @override
  SaveRecipe copyWith({
    int? proficiency,
  }) {
    return SaveRecipe(
      id: id,
      proficiency: proficiency ?? this.proficiency,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'proficiency': proficiency,
      };
}
