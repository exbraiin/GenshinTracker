import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/widgets/item_info_widget.dart';

class HomeLastBannerWidget extends StatelessWidget {
  const HomeLastBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const type = GsBanner.character;
    const source = GsItemSource.wishesCharacterBanner;
    final banners = GsUtils.wishes.geReleasedInfoBannerByType(type);
    final characters = GsDatabase.instance.infoCharacters
        .getItems()
        .where((chr) => chr.rarity == 5 && chr.source == source)
        .map((chr) => _toMapEntry(chr, banners))
        .where((e) => e.value.inDays > 0)
        .sortedByDescending((e) => e.value);
    return GsDataBox.info(
      title: Text(context.fromLabel(Labels.lastBanner)),
      child: LayoutBuilder(
        builder: (context, layout) {
          final width = layout.maxWidth;
          final items = (width ~/ 74).coerceAtMost(8);
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: characters
                .take(items)
                .map<Widget>((e) => _getCardItem(context, e))
                .separate(const SizedBox(width: kSeparator4))
                .toList(),
          );
        },
      ),
    );
  }

  MapEntry<InfoCharacter, Duration> _toMapEntry(
    InfoCharacter chr,
    List<InfoBanner> releasedBanners,
  ) {
    final banner = releasedBanners
        .where((bnr) => bnr.feature5.contains(chr.id))
        .sortedBy((bnr) => bnr.dateStart)
        .lastOrNull;
    final duration = banner == null
        ? Duration.zero
        : DateTime.now().difference(banner.dateStart);
    return MapEntry(chr, duration);
  }

  Widget _getCardItem(
    BuildContext context,
    MapEntry<InfoCharacter, Duration> entry,
  ) {
    return ItemGridWidget.character(
      entry.key,
      label: context.fromLabel(Labels.shortDay, entry.value.inDays),
    );
  }
}
