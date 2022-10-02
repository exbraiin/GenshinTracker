abstract class IdData {
  String get id;
}

abstract class IdSaveData extends IdData {
  Map<String, dynamic> toMap();
}
