import 'package:tracker/domain/gs_domain.dart';

class InfoDetails implements IdData {
  @override
  final String id = 'details';
  final List<int> ascensionHerosWit;

  InfoDetails({
    required this.ascensionHerosWit,
  });

  factory InfoDetails.fromMap(Map<String, dynamic> map) {
    return InfoDetails(
      ascensionHerosWit: (map['ascension_heros_wit'] as List).cast<int>(),
    );
  }

  int getAscensionHerosWit(int level) => ascensionHerosWit[level];
}
