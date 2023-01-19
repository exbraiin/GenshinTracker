import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/gs_grid_view.dart';
import 'package:tracker/common/widgets/gs_no_results_state.dart';
import 'package:tracker/common/widgets/gs_time_dialog.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/add_wish_screen/add_wish_item_data_list_item.dart';
import 'package:tracker/screens/add_wish_screen/add_wish_wish_list_item.dart';
import 'package:tracker/screens/screen_filters/screen_filter.dart';
import 'package:tracker/screens/screen_filters/screen_filter_drawer.dart';
import 'package:tracker/screens/wishes_screen/wish_utils.dart';

class AddWishScreen extends StatefulWidget {
  static const id = 'add_wishes_screen';

  @override
  _AddWishScreenState createState() => _AddWishScreenState();
}

class _AddWishScreenState extends State<AddWishScreen> {
  late final ValueNotifier<List<ItemData>> _wishes;

  @override
  void initState() {
    super.initState();
    _wishes = ValueNotifier([]);
  }

  @override
  void dispose() {
    _wishes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final banner = args as InfoBanner?;
    return ScreenDrawerBuilder<ItemData>(
      filter: () => ScreenFilters.itemDataFilter,
      builder: (context, filter, drawer) {
        if (banner == null) return SizedBox();
        return Scaffold(
          appBar: GsAppBar(
            label: Lang.of(context).getValue(Labels.addWishes),
            leading: CloseButton(),
          ),
          body: Row(
            children: [
              _getItemsList(context, banner, filter),
              Container(
                width: 220,
                color: GsColors.mainColor0,
                padding: EdgeInsets.all(4),
                child: Column(
                  children: [
                    Expanded(
                      child: ValueListenableBuilder<List<ItemData>>(
                        valueListenable: _wishes,
                        builder: (context, list, child) {
                          final roll = GsDatabase.instance.saveWishes
                              .countBannerWishes(banner.id);
                          return ListView.separated(
                            itemCount: list.length,
                            separatorBuilder: (_, index) =>
                                SizedBox(height: kSeparator2),
                            itemBuilder: (context, index) {
                              return AddWishWishListItem(
                                item: list[index],
                                roll: (roll + (list.length - index)),
                                onRemove: () => _wishes.value =
                                    (_wishes.value..removeAt(index)).toList(),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 8),
                    ValueListenableBuilder<List<ItemData>>(
                      valueListenable: _wishes,
                      builder: (context, list, child) {
                        return Opacity(
                          opacity: list.isEmpty ? kDisableOpacity : 1,
                          child: InkWell(
                            onTap:
                                list.isEmpty ? null : () => _saveWishes(banner),
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: GsColors.mainColor1,
                                borderRadius: kMainRadius,
                              ),
                              child: Center(
                                child: Text(
                                  Lang.of(context).getValue(Labels.addWishes) +
                                      ' (x${list.length})',
                                  style: context.textTheme.subtitle2!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          endDrawer: drawer,
          endDrawerEnableOpenDragGesture: false,
        );
      },
    );
  }

  void _saveWishes(InfoBanner banner) async {
    final date = await GsTimeDialog.show(context);
    if (date == null) return;

    final ids = _wishes.value.reversed.map((e) => e.id);
    GsDatabase.instance.saveWishes.addWishes(
      ids: ids,
      date: date,
      bannerId: banner.id,
    );

    Navigator.of(context).maybePop();
  }

  Widget _getItemsList(
    BuildContext context,
    InfoBanner banner,
    ScreenFilter<ItemData> filter,
  ) {
    bool featured(ItemData itemData) =>
        banner.feature4.contains(itemData.id) ||
        banner.feature5.contains(itemData.id);

    final filtered = filter
        .match(getBannerItemsData(banner))
        .sortedBy((element) => element.rarity)
        .thenBy((element) => element.type.index)
        .thenBy((element) => featured(element) ? 0 : 1)
        .thenBy((element) => element.name);
    if (filtered.isEmpty) return GsNoResultsState();

    return Expanded(
      child: GsGridView.builder(
        itemCount: filtered.length,
        itemBuilder: (context, index) => AddWishItemDataListItem(
          item: filtered[index],
          isItemFeatured: featured(filtered[index]),
          onAdd: () {
            if (_wishes.value.length >= 10) return;
            _wishes.value =
                (_wishes.value..insert(0, filtered[index])).toList();
          },
        ),
      ),
    );
  }
}
