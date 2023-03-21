import 'package:tracker/domain/gs_domain.dart';

class InfoBanner extends IdData<InfoBanner> {
  @override
  final String id;
  final String name;
  final String image;
  final String version;
  final DateTime dateStart;
  final DateTime dateEnd;
  final List<String> feature4;
  final List<String> feature5;
  final GsBanner type;

  InfoBanner.fromJsonData(JsonData data)
      : id = data.getString('id'),
        name = data.getString('name'),
        image = data.getString('image'),
        version = data.getString('version'),
        dateStart = data.getDate('date_start'),
        dateEnd = data.getDate('date_end'),
        feature4 = data.getStringList('feature_4'),
        feature5 = data.getStringList('feature_5'),
        type = data.getGsEnum('type', GsBanner.values);

  @override
  int compareTo(InfoBanner other) {
    if (id == other.id) return 0;
    return dateStart.compareTo(other.dateStart);
  }
}
