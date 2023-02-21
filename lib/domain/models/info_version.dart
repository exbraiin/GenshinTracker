import 'package:tracker/domain/gs_domain.dart';

class InfoVersion implements IdData {
  @override
  final String id;
  final String name;
  final String image;
  final DateTime releaseDate;

  InfoVersion.fromJsonData(JsonData data)
      : id = data.getString('id'),
        name = data.getString('name'),
        image = data.getString('image'),
        releaseDate = data.getDate('release_date');
}
