import 'package:dartx/dartx.dart';
import 'package:tracker/domain/gs_domain.dart';

class InfoWeaponDetails implements IdData {
  final String id;
  final String effectName;
  final String effectDescription;
  final List<List<String>> effectValues;
  final List<InfoAscension> ascension;

  /// Gets all ascension materials.
  Map<String, int> get allMaterials => ascension
      .expand((e) => e.materials.entries)
      .groupBy((e) => e.key)
      .map((k, v) => MapEntry(k, v.sumBy((e) => e.value).toInt()));

  InfoWeaponDetails({
    required this.id,
    required this.effectName,
    required this.effectValues,
    required this.effectDescription,
    required this.ascension,
  });

  factory InfoWeaponDetails.fromMap(Map<String, dynamic> map) {
    return InfoWeaponDetails(
      id: map['id'],
      effectName: map['effect_name'] ?? '',
      effectValues: (map['effect_values'] as List? ?? [])
          .cast<List>()
          .map((e) => e.cast<String>())
          .toList(),
      effectDescription: map['effect_desc'] ?? '',
      ascension: (map['ascension'] as List)
          .map((e) => InfoAscension.fromMap(e))
          .toList(),
    );
  }
}
