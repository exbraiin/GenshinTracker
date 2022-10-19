import 'package:tracker/domain/gs_domain.dart';

class SaveWish extends Comparable<SaveWish> implements IdSaveData {
  final int number;
  final String id;
  final String itemId;
  final String bannerId;
  final DateTime date;

  final DateTime bannerDate;

  SaveWish({
    required this.id,
    required this.date,
    required this.itemId,
    required this.number,
    required this.bannerId,
  }) : bannerDate = _getBannerDate(bannerId);

  factory SaveWish.fromMap(String id, Map<String, dynamic> map) {
    return SaveWish(
      id: id,
      date: DateTime.parse(map['date']),
      number: map['number'],
      itemId: map['item'],
      bannerId: map['banner'],
    );
  }

  Map<String, dynamic> toMap() => {
        'date': date.toString().split('.').first,
        'number': number,
        'item': itemId,
        'banner': bannerId,
      };

  @override
  int compareTo(SaveWish other) {
    final c0 = bannerDate.compareTo(other.bannerDate);
    if (c0 != 0) return c0;
    final c1 = bannerId.compareTo(other.bannerId);
    if (c1 != 0) return c1;
    final c2 = number.compareTo(other.number);
    if (c2 != 0) return c2;
    return date.compareTo(other.date);
  }
}

DateTime _getBannerDate(String bannerId) {
  final e = bannerId.split('_').toList();
  return DateTime.parse(
    '${e[e.length - 3]}-${e[e.length - 2]}-${e[e.length - 1]}',
  );
}
