import 'package:tracker/domain/gs_domain.dart';

class InfoCity extends IdData<InfoCity> {
  @override
  final String id;
  final String name;
  final String image;
  final GsElement element;
  final List<int> reputation;

  InfoCity.fromJsonData(JsonData data)
      : id = data.getString('id'),
        name = data.getString('name'),
        image = data.getString('image'),
        element = data.getGsEnum('element', GsElement.values),
        reputation = data.getIntList('reputation');

  @override
  int compareTo(InfoCity other) {
    return element.index.compareTo(other.element.index);
  }
}
