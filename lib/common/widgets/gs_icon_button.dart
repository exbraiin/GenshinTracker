import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/gs_incrementer.dart';

class GsCircleIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;

  GsCircleIcon({
    required this.icon,
    this.size = 24,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 2,
          )
        ],
      ),
      child: Center(
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }
}

class GsIconButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;
  final VoidCallback? onPress;

  GsIconButton({
    required this.icon,
    this.size = 24,
    this.onPress,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onPress != null ? 1 : kDisableOpacity,
      child: InkWell(
        onTap: () => onPress?.call(),
        child: GsCircleIcon(
          size: size,
          icon: icon,
          color: color,
        ),
      ),
    );
  }
}

class GsIconButtonHold extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;
  final void Function(int i)? onPress;

  GsIconButtonHold({
    required this.icon,
    this.size = 24,
    this.onPress,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return GsIncrementer(
      onTap: onPress != null ? () => onPress!(1) : null,
      onHold: onPress != null ? (i) => onPress!(_intFromTick(i)) : null,
      child: Opacity(
        opacity: onPress != null ? 1 : kDisableOpacity,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GsCircleIcon(
            size: size,
            icon: icon,
            color: color,
          ),
        ),
      ),
    );
  }
}

int _intFromTick(int tick) {
  if (tick < 50) return 1;
  if (tick < 100) return 10;
  if (tick < 150) return 100;
  return 1000;
}
