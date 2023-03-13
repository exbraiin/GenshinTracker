abstract class IdData {
  String get id;
}

abstract class IdSaveData<T extends IdSaveData<T>> extends IdData {
  T copyWith();
  Map<String, dynamic> toMap();
}

abstract class GsEnum {
  String get id;
}
