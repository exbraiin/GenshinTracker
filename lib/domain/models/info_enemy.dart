import 'package:tracker/domain/enums/gs_enemy_family.dart';
import 'package:tracker/domain/enums/gs_enemy_type.dart';
import 'package:tracker/domain/gs_domain.dart';

class InfoEnemy extends IdData<InfoEnemy> {
  @override
  final String id;
  final String name;
  final String title;
  final String image;
  final String version;
  final String fullImage;
  final String splashImage;
  final int order;
  final GsEnemyType type;
  final GsEnemyFamily family;
  final List<String> drops;

  int get rarityByType => switch (type) {
        GsEnemyType.none => 1,
        GsEnemyType.common => 2,
        GsEnemyType.elite => 3,
        GsEnemyType.normalBoss => 4,
        GsEnemyType.weeklyBoss => 5,
      };

  InfoEnemy.fromJsonData(JsonData data)
      : id = data.getString('id'),
        name = data.getString('name'),
        title = data.getString('title'),
        image = data.getString('image'),
        version = data.getString('version'),
        fullImage = data.getString('full_image'),
        splashImage = data.getString('splash_image'),
        order = data.getInt('order'),
        type = data.getGsEnum('type', GsEnemyType.values),
        family = data.getGsEnum('family', GsEnemyFamily.values),
        drops = data.getStringList('drops');

  @override
  List<Comparator<InfoEnemy>> get comparators => [
        (a, b) => a.family.index.compareTo(b.family.index),
        (a, b) => a.order.compareTo(b.order),
        (a, b) => a.type.index.compareTo(b.type.index),
        (a, b) => a.version.compareTo(b.version),
        (a, b) => a.name.compareTo(b.name),
      ];
}
