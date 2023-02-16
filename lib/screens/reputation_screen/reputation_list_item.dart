import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_number_field.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';
import 'package:tracker/common/widgets/static/circle_widget.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/theme/theme.dart';

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
    final db = GsDatabase.instance.saveReputations;
    final rp = db.getSavedReputation(widget.city.id);
    final pRep = db.getCityPreviousXpValue(widget.city.id);
    final nRep = db.getCityNextXpValue(widget.city.id);
    final nextLvlWeeks = db.getCityNextLevelWeeks(widget.city.id);
    final lastLvlWeeks = db.getCityMaxLevelWeeks(widget.city.id);

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
                      Stack(
                        children: [
                          SizedBox(
                            width: 34,
                            child: CachedImageWidget(widget.city.image),
                          ),
                        ],
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
                      CircleWidget(
                        size: 16,
                        color: context.themeColors.mainColor1,
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Image.asset(
                            widget.city.element.assetPath,
                            width: 16,
                            height: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: kSeparator4),
                    child: GsNumberField(
                      onDbUpdate: () {
                        final db = GsDatabase.instance.saveReputations;
                        return db.getSavedReputation(widget.city.id);
                      },
                      onUpdate: (amount) {
                        final db = GsDatabase.instance.saveReputations;
                        final saved = db.getSavedReputation(widget.city.id);
                        if (saved == amount) return;
                        db.setSavedReputation(widget.city.id, amount);
                      },
                    ),
                  ),
                  LinearProgressIndicator(
                    value: pg,
                    minHeight: 2,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        pRep.toString(),
                        style: context.textTheme.titleSmall!.copyWith(
                          fontSize: 10,
                          color: GsColors.almostWhite,
                        ),
                      ),
                      const Spacer(),
                      if (nRep != -1)
                        Text(
                          nRep.toString(),
                          style: context.textTheme.titleSmall!.copyWith(
                            fontSize: 10,
                            color: GsColors.almostWhite,
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
              color: context.themeColors.mainColor3,
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
                      text: Lang.of(context).getValue(Labels.levelShort),
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: Colors.white, fontSize: 16),
                    ),
                    TextSpan(
                      text: db.getCityLevel(widget.city.id).toString(),
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
                              ? '\n${context.fromLabel(
                                  Labels.nWeeks,
                                  lastLvlWeeks,
                                )}'
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
