import 'package:tracker/domain/gs_domain.dart';

class InfoMaterial implements IdData {
  final String id;
  final String name;
  final String image;
  final String version;
  final int rarity;
  final int subgroup;
  final GsMaterialGroup group;
  final List<String> weekdays;

  int get maxAmount => id == 'mora' ? 9999999999 : 9999;

  InfoMaterial({
    required this.id,
    required this.name,
    required this.image,
    required this.version,
    required this.group,
    required this.rarity,
    required this.subgroup,
    required this.weekdays,
  });

  factory InfoMaterial.fromMap(Map<String, dynamic> map) {
    return InfoMaterial(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      version: map['version'] ?? '',
      group: GsMaterialGroup.values.fromName(map['group'] as String? ?? ''),
      rarity: map['rarity'],
      subgroup: map['subgroup'],
      weekdays: (map['weekdays'] as List? ?? []).cast<String>(),
    );
  }
}
