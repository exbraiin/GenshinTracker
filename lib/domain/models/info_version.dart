import 'package:tracker/domain/gs_domain.dart';

class InfoVersion implements IdData {
  final String id;
  final String name;
  final String image;
  final DateTime releaseDate;

  InfoVersion({
    required this.id,
    required this.name,
    required this.image,
    required this.releaseDate,
  });

  factory InfoVersion.fromMap(Map<String, dynamic> map) {
    return InfoVersion(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      releaseDate: DateTime.parse(map['release_date']),
    );
  }
}
