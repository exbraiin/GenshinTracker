import 'package:flutter/material.dart';
import 'package:tracker/theme/theme.dart';

class GsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String label;
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  const GsAppBar({
    super.key,
    required this.label,
    this.leading,
    this.actions,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(label),
      leading: leading ?? _backButton(context),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight((bottom?.preferredSize.height ?? 0) + 1),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: context.themeColors.divider),
            ),
          ),
          child: bottom,
        ),
      ),
      actions: actions,
    );
  }

  Widget? _backButton(BuildContext context) {
    final canPop = ModalRoute.of(context)?.canPop ?? false;
    final hasEndDrawer = Scaffold.maybeOf(context)?.hasEndDrawer ?? false;
    return canPop && !hasEndDrawer
        ? IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            iconSize: 34,
            padding: const EdgeInsets.all((54 - 34) / 2),
            icon: const Icon(Icons.close_rounded),
          )
        : null;
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(54 + (bottom?.preferredSize.height ?? 0));
}
