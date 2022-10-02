import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_database.test.dart';

class AchievementGroupListItem extends StatelessWidget {
  final AchievementGroup group;

  AchievementGroupListItem(this.group);

  int previousAchievement(int id) {
    final idx = group.list.indexWhere((e) => e.id == id);
    if (0 < idx) return group.list[idx - 1].id;
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    final db = GsDatabase.instance.saveAchievements;
    return Container(
      decoration: BoxDecoration(
        color: GsColors.mainColor2,
        borderRadius: kMainRadius,
      ),
      child: Column(
        children: group.list
            .map<Widget>((e) {
              final saved = db.saved(e.id);
              final previous = previousAchievement(e.id);
              final blocked = previous != -1 ? !db.saved(previous) : false;
              return _AchievementRow(e, saved, blocked);
            })
            .separate(Divider(
              height: 0,
              thickness: 1,
              color: GsColors.mainColor1,
              indent: kSeparator4 * 2,
              endIndent: kSeparator4 * 2,
            ))
            .toList(),
      ),
    );
  }
}

class _AchievementRow extends StatelessWidget {
  final bool saved;
  final bool blocked;
  final Achievement item;

  _AchievementRow(this.item, this.saved, this.blocked);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(kSeparator4 * 2),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.name,
                      style: context.textTheme.subtitle1!
                          .copyWith(color: Colors.white),
                    ),
                    SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: GsColors.mainColor0,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                      alignment: Alignment.center,
                      child: Text(
                        item.version,
                        style: context.textTheme.cardLabel,
                      ),
                    ),
                  ],
                ),
                Text(
                  item.desc,
                  style: context.textTheme.description,
                ),
              ],
            ),
          ),
          Text(
            item.reward.toString(),
            style: context.textTheme.subtitle1!.copyWith(color: Colors.white),
          ),
          SizedBox(width: 4),
          Image.asset(
            imagePrimogem,
            fit: BoxFit.contain,
            width: 16,
            height: 16,
          ),
          SizedBox(width: 8),
          _Toggle(
            selected: saved,
            onSelect: !blocked
                ? () => GsDatabase.instance.saveAchievements
                    .saveAchievement(item.id, !saved)
                : null,
          ),
        ],
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  final bool selected;
  final VoidCallback? onSelect;

  _Toggle({
    required this.selected,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onSelect != null ? 1 : kDisableOpacity,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? GsColors.mainColor0 : Colors.transparent,
          border: Border.all(color: GsColors.mainColor0, width: 2),
          borderRadius: kMainRadius,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: kMainRadius,
          child: InkWell(
            onTap: onSelect,
            child: SizedBox(
              width: 24,
              height: 24,
              child: selected
                  ? Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                    )
                  : SizedBox(),
            ),
            splashColor: Colors.white.withOpacity(0.6),
            hoverColor: Colors.white.withOpacity(0.2),
            borderRadius: kMainRadius,
          ),
        ),
      ),
    );
  }
}
