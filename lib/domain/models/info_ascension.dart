import 'package:tracker/domain/gs_domain.dart';

class InfoAscension {
  final int level;
  final Map<String, int> materials;
  final Map<GsAttributeStat, double> valuesAfter;
  final Map<GsAttributeStat, double> valuesBefore;

  InfoAscension({
    required this.level,
    required this.materials,
    required this.valuesAfter,
    required this.valuesBefore,
  });

  factory InfoAscension.fromMap(Map<String, dynamic> map) {
    return InfoAscension(
      level: map['level'],
      materials: (map['materials'] as Map? ?? {}).cast<String, int>(),
      valuesAfter: (map['values_after'] as Map? ?? {}).map(
        (key, value) => MapEntry(
          GsAttributeStat.values.firstWhere(
            (e) => e.name == key,
            orElse: () => GsAttributeStat.none,
          ),
          _toDouble(value),
        ),
      ),
      valuesBefore: (map['values_before'] as Map? ?? {}).map(
        (key, value) => MapEntry(
          GsAttributeStat.values.firstWhere(
            (e) => e.name == key,
            orElse: () => GsAttributeStat.none,
          ),
          _toDouble(value),
        ),
      ),
    );
  }
}

double _toDouble(Object obj) {
  if (obj is double) return obj;
  if (obj is int) return obj.toDouble();
  return double.tryParse(obj.toString()) ?? 0;
}
