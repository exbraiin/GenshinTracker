import 'package:tracker/domain/gs_domain.dart';

class SaveWish extends Comparable<SaveWish> implements IdSaveData<SaveWish> {
  @override
  final String id;
  final int number;
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

  SaveWish.fromJsonData(JsonData data)
      : number = data.getInt('number'),
        id = data.getString('id'),
        itemId = data.getString('item'),
        bannerId = data.getString('banner'),
        date = data.getDate('date'),
        bannerDate = _getBannerDate(data.getString('banner'));

  @override
  SaveWish copyWith({
    String? id,
    int? number,
    String? itemId,
    String? bannerId,
    DateTime? date,
  }) {
    return SaveWish(
      id: id ?? this.id,
      date: date ?? this.date,
      itemId: itemId ?? this.itemId,
      number: number ?? this.number,
      bannerId: bannerId ?? this.bannerId,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
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
