import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';
import 'package:tracker/common/widgets/static/circle_widget.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

class ReputationListItem extends StatefulWidget {
  final InfoCity city;

  ReputationListItem(this.city);

  @override
  _ReputationListItemState createState() => _ReputationListItemState();
}

class _ReputationListItemState extends State<ReputationListItem> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final db = GsDatabase.instance;
    final value = db.saveReputations.getSavedReputation(widget.city.id);
    _controller = TextEditingController(text: value.toString());
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = GsDatabase.instance.saveReputations;
    final rp = db.getSavedReputation(widget.city.id);
    final pRep = db.getCityPreviousXpValue(widget.city.id);
    final nRep = db.getCityNextXpValue(widget.city.id);

    final current = rp - pRep;
    final total = nRep - pRep;
    final pg = total < 1 ? 1.0 : (current / total).clamp(0.0, 1.0);

    return Container(
      width: 300,
      height: 100,
      decoration: BoxDecoration(
        color: GsColors.mainColor2,
        borderRadius: kMainRadius,
        boxShadow: kMainShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 34,
                            child: CachedImageWidget(widget.city.image),
                          ),
                        ],
                      ),
                      SizedBox(width: kSeparator4),
                      Text(
                        widget.city.name,
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(color: Colors.white),
                      ),
                      SizedBox(width: kSeparator4),
                      CircleWidget(
                        size: 16,
                        color: GsColors.mainColor1,
                        child: Padding(
                          padding: EdgeInsets.all(2),
                          child: Image.asset(
                            widget.city.element.assetPath,
                            width: 16,
                            height: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  TextFormField(
                    controller: _controller,
                    onFieldSubmitted: (value) {
                      final v = int.tryParse(value) ?? 0;
                      _controller.text = v.toString();
                      GsDatabase.instance.saveReputations
                          .setSavedReputation(widget.city.id, v);
                    },
                    style: context.textTheme.subtitle1!
                        .copyWith(color: Colors.white),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: GsColors.almostWhite),
                      ),
                    ),
                  ),
                  LinearProgressIndicator(
                    value: pg,
                    minHeight: 2,
                    color: Colors.green,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        pRep.toString(),
                        style: context.textTheme.subtitle2!.copyWith(
                          fontSize: 10,
                          color: GsColors.almostWhite,
                        ),
                      ),
                      Spacer(),
                      if (nRep != -1)
                        Text(
                          nRep.toString(),
                          style: context.textTheme.subtitle2!.copyWith(
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
              color: GsColors.mainColor3,
              borderRadius: BorderRadius.horizontal(
                right: kMainRadius.topRight,
              ),
            ),
            child: Center(
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _controller,
                builder: (context, text, child) {
                  final values = widget.city.reputation;
                  final rep = values.lastWhere(
                    (e) => e <= (int.tryParse(text.text) ?? 0),
                    orElse: () => values.first,
                  );

                  final sr = GsDatabase.instance.saveReputations;
                  final nextLvlWeeks = sr.getCityNextLevelWeeks(widget.city.id);
                  final lastLvlWeeks = sr.getCityMaxLevelWeeks(widget.city.id);

                  final weeks = nextLvlWeeks != lastLvlWeeks
                      ? '\n' +
                          Lang.of(context).getValue(
                            Labels.nnWeeks,
                            nargs: {
                              'from': nextLvlWeeks,
                              'to': lastLvlWeeks,
                            },
                          )
                      : lastLvlWeeks != 0
                          ? '\n' +
                              Lang.of(context).getValue(
                                Labels.nWeeks,
                                nargs: {'weeks': lastLvlWeeks},
                              )
                          : '';

                  final lvl = sr.getCityLevel(widget.city.id);

                  return RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: Lang.of(context).getValue(Labels.levelShort),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(color: Colors.white, fontSize: 16),
                        ),
                        TextSpan(
                          text: '$lvl',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(color: Colors.white, fontSize: 26),
                        ),
                        TextSpan(
                          text: '\n${rep.format()} Rp$weeks',
                          style: context.textTheme.subtitle2!
                              .copyWith(color: Colors.white, fontSize: 10),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
