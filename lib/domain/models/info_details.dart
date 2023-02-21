import 'package:tracker/domain/gs_domain.dart';

class InfoDetails implements IdData {
  @override
  final String id = 'details';
  final List<int> ascensionHerosWit;

  InfoDetails.fromJsonData(JsonData data)
      : ascensionHerosWit = data.getIntList('ascension_heros_wit');

  int getAscensionHerosWit(int level) => ascensionHerosWit[level];
}
