abstract class IdData<T extends IdData<T>> implements Comparable<T> {
  String get id;
}

abstract class IdSaveData<T extends IdSaveData<T>> extends IdData<T> {
  T copyWith();
  Map<String, dynamic> toMap();
}

abstract class GsEnum {
  String get id;
}

class GsComparator<T> {
  final List<Comparator<T>> comparators;

  const GsComparator(this.comparators);

  int compare(T a, T b) {
    for (final comparator in comparators) {
      final result = comparator(a, b);
      if (result != 0) return result;
    }
    return 0;
  }
}
