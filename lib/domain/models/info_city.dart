import '../gs_domain.dart';

class InfoCity implements IdData {
  final String id;
  final String name;
  final String? image;
  final GsElement element;
  final List<int> reputation;

  InfoCity({
    required this.id,
    required this.name,
    required this.image,
    required this.element,
    required this.reputation,
  });

  factory InfoCity.fromMap(String id, Map<String, dynamic> map) {
    return InfoCity(
      id: id,
      name: map['name'],
      image: map['image'],
      element: GsElement.values.fromName(map['element']),
      reputation: (map['reputation'] as List).cast<int>(),
    );
  }
}
