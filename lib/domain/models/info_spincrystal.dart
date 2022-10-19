import 'package:tracker/domain/gs_domain.dart';

class InfoSpincrystal implements IdData {
  final String id;
  final int number;
  final String name;
  final String source;
  final String version;

  bool get fromChubby => source == 'Chubby';

  InfoSpincrystal({
    required this.id,
    required this.name,
    required this.number,
    required this.source,
    required this.version,
  });

  factory InfoSpincrystal.fromMap(String id, Map<String, dynamic> map) {
    return InfoSpincrystal(
      id: id,
      name: map['name'],
      number: map['number'],
      source: map['source'],
      version: map['version'],
    );
  }
}
