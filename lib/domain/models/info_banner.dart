import '../gs_domain.dart';

class InfoBanner extends Comparable<InfoBanner> implements IdData {
  final String id;
  final String name;
  final String image;
  final String version;
  final DateTime dateStart;
  final DateTime dateEnd;
  final List<String> feature4;
  final List<String> feature5;
  final GsBanner type;

  InfoBanner({
    required this.id,
    required this.name,
    required this.image,
    required this.version,
    required this.dateStart,
    required this.dateEnd,
    required this.feature4,
    required this.feature5,
    required this.type,
  });

  factory InfoBanner.fromMap(Map<String, dynamic> map) {
    return InfoBanner(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      version: map['version'] ?? '',
      dateStart: DateTime.parse(map['date_start']),
      dateEnd: DateTime.parse(map['date_end']),
      feature4: (map['feature_4'] as List).cast<String>(),
      feature5: (map['feature_5'] as List).cast<String>(),
      type: GsBanner.values.fromName(map['type']),
    );
  }

  @override
  int compareTo(InfoBanner other) {
    if (id == other.id) return 0;
    return dateStart.compareTo(other.dateStart);
  }
}
