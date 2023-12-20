import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/domain/gs_domain.dart';

class SaveWish extends GsModel<SaveWish> {
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
}

DateTime _getBannerDate(String bannerId) {
  final e = bannerId.split('_').toList();
  final date = '${e[e.length - 3]}-${e[e.length - 2]}-${e[e.length - 1]}';
  return DateTime.parse(date);
}
