import 'package:tracker/domain/gs_domain.dart';

class InfoNamecard implements IdData {
  @override
  final String id;
  final String name;
  final String desc;
  final String type;
  final String image;
  final String obtain;
  final String version;

  InfoNamecard({
    required this.id,
    required this.name,
    required this.desc,
    required this.type,
    required this.image,
    required this.obtain,
    required this.version,
  });

  factory InfoNamecard.fromMap(Map<String, dynamic> map) {
    return InfoNamecard(
      id: map['id'],
      name: map['name'],
      version: map['version'],
      image: map['image'],
      desc: map['desc'],
      obtain: map['obtain'],
      type: map['type'],
    );
  }
}
