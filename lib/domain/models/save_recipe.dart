import 'package:tracker/domain/gs_domain.dart';

class SaveRecipe implements IdSaveData {
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
  Map<String, dynamic> toMap() => {
        'id': id,
        'proficiency': proficiency,
      };
}
