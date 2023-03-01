import 'package:tracker/common/lang/labels.dart';
import 'package:tracker/domain/abstraction/info_data.dart';

enum GsRecipeType implements GsEnum {
  event('event', Labels.recipeEvent),
  permanent('permanent', Labels.recipePermanent);

  @override
  final String id;
  final String label;

  const GsRecipeType(this.id, this.label);
}
