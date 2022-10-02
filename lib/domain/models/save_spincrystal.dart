import 'package:tracker/common/utils.dart';
import 'package:tracker/domain/gs_domain.dart';

class SaveSpincrystal implements IdSaveData {
  final int number;
  final bool obtained;

  @override
  String get id => number.toString();

  SaveSpincrystal({
    required this.number,
    required this.obtained,
  });

  factory SaveSpincrystal.fromMap(Map<String, dynamic> map) {
    return SaveSpincrystal(
      number: map['number'],
      obtained: GsConsts.toBool(map['obtained']),
    );
  }

  Map<String, dynamic> toMap() => {
        'number': number,
        'obtained': GsConsts.fromBool(obtained),
      };
}
