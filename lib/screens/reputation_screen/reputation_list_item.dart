import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/common/widgets/gs_number_field.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

class ReputationListItem extends StatefulWidget {
  final InfoCity city;

  const ReputationListItem(this.city, {super.key});

  @override
  State<ReputationListItem> createState() => _ReputationListItemState();
}

class _ReputationListItemState extends State<ReputationListItem> {
  final _notifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final utils = GsUtils.cities;
    final rp = utils.getSavedReputation(widget.city.id);
    final pRep = utils.getCityPreviousXpValue(widget.city.id);
    final nRep = utils.getCityNextXpValue(widget.city.id);
    final nextLvlWeeks = utils.getCityNextLevelWeeks(widget.city.id);
    final lastLvlWeeks = utils.getCityMaxLevelWeeks(widget.city.id);

    final current = rp - pRep;
    final total = nRep - pRep;
    final pg = total < 1 ? 1.0 : (current / total).clamp(0.0, 1.0);

    return Container(
      width: 300,
      height: 100,
      decoration: BoxDecoration(
        color: context.themeColors.mainColor2,
        borderRadius: kMainRadius,
        boxShadow: kMainShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 36,
                        child: CachedImageWidget(widget.city.image),
                      ),
                      const SizedBox(width: kSeparator4),
                      Text(
                        widget.city.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.white),
                      ),
                      const SizedBox(width: kSeparator4),
                      const Spacer(),
                      ItemRarityBubble(
                        size: 24,
                        asset: widget.city.element.assetPath,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: kSeparator4),
                    child: GsNumberField(
                      onDbUpdate: () =>
                          GsUtils.cities.getSavedReputation(widget.city.id),
                      onUpdate: (amount) {
                        final saved =
                            GsUtils.cities.getSavedReputation(widget.city.id);
                        if (saved == amount) return;
                        GsUtils.cities.updateReputation(widget.city.id, amount);
                      },
                    ),
                  ),
                  LinearProgressIndicator(
                    value: pg,
                    minHeight: 2,
                    color: context.themeColors.primary,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        pRep.format(),
                        style: context.textTheme.titleSmall!.copyWith(
                          fontSize: 10,
                          color: context.themeColors.almostWhite,
                        ),
                      ),
                      const Spacer(),
                      if (nRep != -1)
                        Text(
                          nRep.toString(),
                          style: context.textTheme.titleSmall!.copyWith(
                            fontSize: 10,
                            color: context.themeColors.almostWhite,
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            width: 100,
            decoration: BoxDecoration(
              color: context.themeColors.mainColor0,
              borderRadius: BorderRadius.horizontal(
                right: kMainRadius.topRight,
              ),
            ),
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: context.fromLabel(Labels.levelShort),
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: Colors.white, fontSize: 16),
                    ),
                    TextSpan(
                      text: utils.getCityLevel(widget.city.id).toString(),
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: Colors.white, fontSize: 26),
                    ),
                    TextSpan(
                      text: nextLvlWeeks != lastLvlWeeks
                          ? '\n${Lang.of(context).getValue(
                              Labels.nnWeeks,
                              nargs: {'from': nextLvlWeeks, 'to': lastLvlWeeks},
                            )}'
                          : lastLvlWeeks != 0
                              ? '\n${context.fromLabel(Labels.nWeeks, lastLvlWeeks)}'
                              : '',
                      style: context.textTheme.titleSmall!
                          .copyWith(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
