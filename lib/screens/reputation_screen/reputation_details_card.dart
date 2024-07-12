import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/common/widgets/gs_number_field.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/enums/enum_ext.dart';
import 'package:tracker/domain/gs_database.dart';

class ReputationDetailsCard extends StatelessWidget {
  final GsRegion item;

  const ReputationDetailsCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder(
      stream: Database.instance.loaded,
      builder: (context, snapshot) {
        final utils = GsUtils.cities;
        final rp = utils.getSavedReputation(item.id);
        final pRep = utils.getCityPreviousXpValue(item.id);
        final nRep = utils.getCityNextXpValue(item.id);
        final nextLvlWeeks = utils.getCityNextLevelWeeks(item.id);
        final lastLvlWeeks = utils.getCityMaxLevelWeeks(item.id);

        final current = rp - pRep;
        final total = nRep - pRep;
        final pg = total < 1 ? 1.0 : (current / total).clamp(0.0, 1.0);

        final oculi =
            Database.instance.infoOf<GsMaterial>().getItem(item.oculi);

        final color0 = Color.lerp(Colors.black, item.element.color, 0.8);
        final color1 = Color.lerp(Colors.black, item.element.color, 0.4);

        return ItemDetailsCard.single(
          name: item.name,
          fgImage: item.imageInGame,
          info: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CachedImageWidget(
                        oculi?.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: kSeparator4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.archon,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: kSeparator2),
                        Text(
                          item.ideal,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 100),
                  decoration: BoxDecoration(
                    color: context.themeColors.mainColor0
                        .withOpacity(kDisableOpacity),
                    borderRadius: kGridRadius,
                  ),
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
                          text: utils.getCityLevel(item.id).toString(),
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: Colors.white, fontSize: 26),
                        ),
                        TextSpan(
                          text: nextLvlWeeks != lastLvlWeeks
                              ? '\n${Lang.of(context).getValue(
                                  Labels.nnWeeks,
                                  nargs: {
                                    'from': nextLvlWeeks,
                                    'to': lastLvlWeeks,
                                  },
                                )}'
                              : lastLvlWeeks != 0
                                  ? '\n${context.fromLabel(Labels.nWeeks, lastLvlWeeks)}'
                                  : '',
                          style: context.textTheme.titleSmall!.copyWith(
                            color: Colors.white,
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(kSeparator4),
                child: GsNumberField(
                  key: ValueKey(item.id),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: context.themeColors.mainColor1,
                  ),
                  onDbUpdate: () => GsUtils.cities.getSavedReputation(item.id),
                  onUpdate: (amount) {
                    final saved = GsUtils.cities.getSavedReputation(item.id);
                    if (saved == amount) return;
                    GsUtils.cities.updateReputation(item.id, amount);
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: color1,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: LinearProgressIndicator(
                  value: pg,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(8),
                  color: color0,
                  backgroundColor: color1,
                ),
              ),
              const SizedBox(height: kSeparator4),
              Row(
                children: [
                  Text(
                    pRep.format(),
                    style: context.textTheme.titleSmall!.copyWith(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: context.themeColors.mainColor1,
                    ),
                  ),
                  const Spacer(),
                  if (nRep != -1)
                    Text(
                      nRep.toString(),
                      style: context.textTheme.titleSmall!.copyWith(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: context.themeColors.mainColor1,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
