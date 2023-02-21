import 'package:tracker/domain/gs_domain.dart';

enum GsBanner implements GsEnum {
  standard,
  character,
  weapon,
  beginner;

  @override
  String get id => name;
}
