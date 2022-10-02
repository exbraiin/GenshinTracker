import 'package:tracker/domain/gs_domain.dart';

class InfoMaterial implements IdData {
  final String id;
  final String name;
  final String group;
  final String? image;
  final int rarity;
  final int subgroup;

  InfoMaterial({
    required this.id,
    required this.name,
    required this.image,
    required this.group,
    required this.rarity,
    required this.subgroup,
  });

  factory InfoMaterial.fromMap(Map<String, dynamic> map) {
    return InfoMaterial(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      group: map['group'],
      rarity: map['rarity'],
      subgroup: map['subgroup'],
    );
  }
}
