import 'package:tracker/domain/gs_domain.dart';

class SaveRecipe implements IdSaveData {
  final String id;
  final int proficiency;

  SaveRecipe({
    required this.id,
    required this.proficiency,
  });

  factory SaveRecipe.fromMap(String id, Map<String, dynamic> map) {
    return SaveRecipe(
      id: id,
      proficiency: map['proficiency'],
    );
  }

  Map<String, dynamic> toMap() => {
        'proficiency': proficiency,
      };
}
