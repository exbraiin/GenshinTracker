abstract class IdData<T extends IdData<T>> implements Comparable<T> {
  String get id;

  List<Comparator<T>> get comparators => const [];

  @override
  int compareTo(T other) {
    for (final comparator in comparators) {
      final result = comparator(this as T, other);
      if (result != 0) return result;
    }
    return id.compareTo(other.id);
  }
}

abstract class IdSaveData<T extends IdSaveData<T>> extends IdData<T> {
  T copyWith();
  Map<String, dynamic> toMap();
}

abstract class GsEnum {
  String get id;
}
