import 'package:tracker/domain/gs_domain.dart';

class InfoSpincrystal implements IdData {
  final int number;
  final String name;
  final String source;
  final String version;

  bool get fromChubby => source == 'Chubby';

  @override
  String get id => '$number';

  InfoSpincrystal({
    required this.name,
    required this.number,
    required this.source,
    required this.version,
  });

  factory InfoSpincrystal.fromMap(Map<String, dynamic> map) {
    return InfoSpincrystal(
      name: map['name'],
      number: map['number'],
      source: map['source'],
      version: map['version'],
    );
  }
}
