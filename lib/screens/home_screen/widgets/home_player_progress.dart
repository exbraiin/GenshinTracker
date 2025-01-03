import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';

class HomePlayerProgress extends StatelessWidget {
  const HomePlayerProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder<bool>(
      stream: Database.instance.loaded,
      builder: (context, snapshot) {
        return GsDataBox.info(
          title: Text(context.labels.progress()),
          children: <Widget>[
            _ProgressInfo(
              GsAssets.menuAchvmnt,
              context.labels.achievements(),
              GsUtils.achievements.countSaved(),
              GsUtils.achievements.countTotal(),
            ),
            _ProgressInfo(
              GsAssets.menuRecipes,
              context.labels.recipes(),
              GsUtils.recipes.owned,
              GsUtils.recipes.total,
            ),
            _ProgressInfo(
              GsAssets.menuRecipes,
              context.labels.proficiency(),
              GsUtils.recipes.mastered,
              GsUtils.recipes.owned,
            ),
            _ProgressInfo(
              GsAssets.menuMap,
              context.labels.remarkableChests(),
              GsUtils.remarkableChests.owned,
              GsUtils.remarkableChests.total,
            ),
            _ProgressInfo(
              GsAssets.menuEchos,
              context.labels.envisagedEchoes(),
              GsUtils.echos.owned,
              GsUtils.echos.total,
            ),
            _ProgressInfo(
              GsAssets.menuInventory,
              context.labels.spincrystals(),
              GsUtils.spincrystals.owned,
              GsUtils.spincrystals.total,
            ),
            _ProgressInfo(
              GsAssets.menuPot,
              context.labels.sereniteaSets(),
              GsUtils.sereniteaSets.owned,
              GsUtils.sereniteaSets.total,
            ),
          ].separate(const SizedBox(height: kSeparator8 * 2)).toList(),
        );
      },
    );
  }
}

class _ProgressInfo extends StatelessWidget {
  final int owned;
  final int total;
  final String asset;
  final String label;

  const _ProgressInfo(this.asset, this.label, this.owned, this.total);

  @override
  Widget build(BuildContext context) {
    final percentage = (owned / total.coerceAtLeast(1)).clamp(0.0, 1.0);
    final missing = total - owned;

    final style = context.themeStyles.label12n;

    return Row(
      children: [
        Image.asset(asset, width: 46, height: 46),
        const SizedBox(width: kSeparator8),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(child: Text(label)),
                  Text(
                    owned.format(),
                    textAlign: TextAlign.end,
                    style: style.copyWith(
                      color: missing > 0
                          ? context.themeColors.badValue
                          : Colors.white,
                    ),
                  ),
                  if (missing > 0)
                    Text(
                      ' +${missing.format()}',
                      style: style.copyWith(
                        fontStyle: FontStyle.italic,
                        fontSize: 10,
                        color: context.themeColors.goodValue,
                      ),
                      strutStyle: style.copyWith(fontSize: 10).toStrut(),
                    ),
                  Text(
                    ' / ${total.format()}',
                    textAlign: TextAlign.end,
                    style: style,
                  ),
                ],
              ),
              const SizedBox(height: kSeparator8),
              _progressBar(context, percentage),
            ],
          ),
        ),
      ],
    );
  }

  Widget _progressBar(BuildContext context, double percentage) {
    return Container(
      height: kSeparator6,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.themeColors.mainColor1,
        borderRadius: BorderRadius.circular(4),
      ),
      child: AnimatedFractionallySizedBox(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        widthFactor: percentage,
        alignment: Alignment.centerLeft,
        child: Container(
          height: 4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
