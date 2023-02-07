import 'package:tracker/domain/gs_domain.dart';

class InfoSpincrystal implements IdData {
  @override
  final String id;
  final int number;
  final int rarity;
  final String name;
  final String desc;
  final String source;
  final String version;

  bool get fromChubby => source == 'Chubby';

  InfoSpincrystal({
    required this.id,
    required this.name,
    required this.desc,
    required this.number,
    required this.rarity,
    required this.source,
    required this.version,
  });

  factory InfoSpincrystal.fromMap(Map<String, dynamic> map) {
    return InfoSpincrystal(
      id: map['id'],
      name: map['name'],
      desc: map['desc'] ?? '',
      number: map['number'],
      rarity: map['rarity'] ?? 4,
      source: map['source'],
      version: map['version'],
    );
  }
}
