import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_grid_view.dart';
import 'package:tracker/common/widgets/gs_no_results_state.dart';
import 'package:tracker/common/widgets/gs_time_dialog.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/add_wish_screen/add_wish_item_data_list_item.dart';
import 'package:tracker/screens/add_wish_screen/add_wish_wish_list_item.dart';
import 'package:tracker/screens/screen_filters/screen_filter_builder.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';

class AddWishScreen extends StatefulWidget {
  static const id = 'add_wishes_screen';

  const AddWishScreen({super.key});

  @override
  State<AddWishScreen> createState() => _AddWishScreenState();
}

class _AddWishScreenState extends State<AddWishScreen> {
  late final ValueNotifier<List<GsWish>> _wishes;

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
    final banner = args as GsBanner?;

    return ScreenFilterBuilder<GsWish>(
      builder: (context, filter, button, toggle) {
        if (banner == null) return const SizedBox();

        return InventoryPage(
          appBar: InventoryAppBar(
            iconAsset: GsAssets.menuWish,
            label: context.labels.addWishes(),
            actions: [button],
          ),
          child: Row(
            children: [
              Expanded(
                child: InventoryBox(
                  child: _getItemsList(context, banner, filter),
                ),
              ),
              const SizedBox(width: kGridSeparator),
              InventoryBox(
                width: 220,
                child: _getTemporaryList(banner),
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveWishes(GsBanner banner) async {
    final date = await GsTimeDialog.show(context);
    if (date == null) return;

    final ids = _wishes.value.reversed.map((e) => e.id);
    GsUtils.wishes.addWishes(
      ids: ids,
      date: date,
      bannerId: banner.id,
    );

    if (!mounted) return;
    Navigator.of(context).maybePop();
  }

  Widget _getItemsList(
    BuildContext context,
    GsBanner banner,
    ScreenFilter<GsWish> filter,
  ) {
    bool featured(GsWish itemData) =>
        banner.feature4.contains(itemData.id) ||
        banner.feature5.contains(itemData.id);

    final filtered = filter
        .match(GsUtils.wishes.getBannerItemsData(banner))
        .map((e) => e.copyWith(featured: featured(e)))
        .sorted();
    if (filtered.isEmpty) return const GsNoResultsState();

    return GsGridView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) => AddWishItemDataListItem(
        item: filtered[index],
        isItemFeatured: featured(filtered[index]),
        onAdd: () {
          if (_wishes.value.length >= 10) return;
          _wishes.value = (_wishes.value..insert(0, filtered[index])).toList();
        },
      ),
    );
  }

  Widget _getTemporaryList(GsBanner banner) {
    return Column(
      children: [
        Expanded(
          child: ValueListenableBuilder<List<GsWish>>(
            valueListenable: _wishes,
            builder: (context, list, child) {
              final roll = GsUtils.wishes.countBannerWishes(banner.id);
              return ListView.separated(
                itemCount: list.length,
                separatorBuilder: (_, index) =>
                    const SizedBox(height: kListSeparator),
                itemBuilder: (context, index) {
                  return AddWishWishListItem(
                    item: list[index],
                    roll: roll + (list.length - index),
                    onRemove: () => _wishes.value =
                        (_wishes.value..removeAt(index)).toList(),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<List<GsWish>>(
          valueListenable: _wishes,
          builder: (context, list, child) {
            return Opacity(
              opacity: list.isEmpty ? kDisableOpacity : 1,
              child: InkWell(
                onTap: list.isEmpty ? null : () => _saveWishes(banner),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: context.themeColors.mainColor0,
                    borderRadius: kGridRadius,
                  ),
                  child: Center(
                    child: Text(
                      '${context.labels.addWishes()} (x${list.length})',
                      style: context.textTheme.titleSmall!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
