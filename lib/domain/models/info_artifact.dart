import '../gs_domain.dart';

class InfoArtifact implements IdData {
  final String id;
  final String name;
  final String? image;
  final int rarity;

  InfoArtifact({
    required this.id,
    required this.name,
    required this.image,
    required this.rarity,
  });

  factory InfoArtifact.fromMap(Map<String, dynamic> map) {
    return InfoArtifact(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      rarity: map['rarity'],
    );
  }
}
