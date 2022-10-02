import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/circle.dart';
import 'package:tracker/common/widgets/file_image.dart';
import 'package:tracker/domain/gs_database.dart';

class SereniteaCharacterButton extends StatelessWidget {
  final String id;
  final bool owned;
  final bool collected;
  final VoidCallback onTap;

  SereniteaCharacterButton({
    Key? key,
    required this.id,
    required this.owned,
    required this.collected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final item = GsDatabase.instance.infoCharacters.getItem(id);
    return InkWell(
      onTap: owned ? onTap : null,
      child: Stack(
        children: [
          Opacity(
            opacity: owned ? 1 : kDisableOpacity,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Color(0xFF25294A),
                borderRadius: BorderRadius.circular(44),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(getRarityBgImage(item.rarity)),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 2,
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(44),
                child: CachedImageWidget(item.image),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: _CheckCircle(
              collected,
              child: Icon(
                Icons.check_rounded,
                size: 12,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckCircle extends StatefulWidget {
  final bool show;
  final Widget? child;

  _CheckCircle(this.show, {this.child});

  @override
  __CheckCircleState createState() => __CheckCircleState();
}

class __CheckCircleState extends State<_CheckCircle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      value: widget.show ? 1 : 0,
      duration: Duration(milliseconds: 300),
    );
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _CheckCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.show != widget.show) {
      _controller.animateTo(widget.show ? 1 : 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final curved = Curves.elasticInOut.transform(_controller.value);
        return Transform.scale(
          scale: curved,
          child: Opacity(
            opacity: _controller.value,
            child: child,
          ),
        );
      },
      child: Circle(
        color: Colors.black,
        borderColor: Colors.white,
        borderSize: 1.6,
        size: 22,
        child: widget.child,
      ),
    );
  }
}
