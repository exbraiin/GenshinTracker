import 'package:tracker/domain/gs_domain.dart';

class SaveRecipe implements IdSaveData {
  final String id;
  final int proficiency;

  SaveRecipe({
    required this.id,
    required this.proficiency,
  });

  factory SaveRecipe.fromMap(Map<String, dynamic> map) {
    return SaveRecipe(
      id: map['id'],
      proficiency: map['proficiency'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'proficiency': proficiency,
      };
}
