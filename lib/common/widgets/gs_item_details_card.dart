import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';

class ItemDetailsCard extends StatefulWidget {
  final int rarity;
  final int pages;
  final String name;
  final Widget Function(BuildContext context, int page)? info;
  final String Function(BuildContext context, int page)? image;
  final String Function(BuildContext context, int page)? fgImage;
  final Widget Function(BuildContext context, int page)? child;

  const ItemDetailsCard({
    super.key,
    this.info,
    this.name = '',
    this.image,
    this.fgImage,
    this.pages = 1,
    this.rarity = 0,
    this.child,
  });

  @override
  State<ItemDetailsCard> createState() => _ItemDetailsCardState();
}

class _ItemDetailsCardState extends State<ItemDetailsCard> {
  late final ValueNotifier<int> _page;

  @override
  void initState() {
    super.initState();
    _page = ValueNotifier(0);
  }

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ItemDetailsCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pages != widget.pages) {
      _page.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _headerTitle(context),
        _headerInfo(context),
        _content(context),
      ],
    );
  }

  Widget _headerTitle(BuildContext context) {
    final color = GsColors.getRarityColor(widget.rarity.coerceAtLeast(1));
    final color1 = Color.lerp(Colors.black, color, 0.8)!;
    return Container(
      height: 48,
      color: color,
      child: Container(
        margin: const EdgeInsets.all(kSeparator2),
        padding: const EdgeInsets.all(kSeparator4),
        decoration: BoxDecoration(
          border: Border.all(
            color: color1,
            width: kSeparator2,
          ),
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          widget.name,
          maxLines: 1,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
          ),
        ),
      ),
    );
  }

  Widget _headerInfo(BuildContext context) {
    final color = GsColors.getRarityColor(widget.rarity.coerceAtLeast(1));
    final color1 = Color.lerp(Colors.black, color, 0.8)!;
    return Container(
      height: 180,
      width: double.infinity,
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        color: color1,
        border: Border(
          bottom: BorderSide(color: color1, width: 4),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            left: null,
            child: AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: [
                  ShaderMask(
                    shaderCallback: (rect) {
                      return LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.black, Colors.black.withOpacity(0)],
                        stops: const [0, 0.8],
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.dstOut,
                    child: Image.asset(
                      getRarityBgImage(widget.rarity.coerceAtLeast(1)),
                      alignment: Alignment.centerRight,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  ValueListenableBuilder<int>(
                    valueListenable: _page,
                    builder: (context, value, child) {
                      if (widget.image == null) return const SizedBox();
                      return CachedImageWidget(
                        widget.image?.call(context, value),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          if (widget.fgImage != null)
            Positioned.fill(
              child: Opacity(
                opacity: 0.8,
                child: ValueListenableBuilder<int>(
                  valueListenable: _page,
                  builder: (context, value, child) {
                    return CachedImageWidget(
                      widget.fgImage?.call(context, value),
                      showPlaceholder: false,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(kSeparator4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: DefaultTextStyle(
                        style: context.textTheme.headline6!.copyWith(
                          color: GsColors.dimWhite,
                          fontSize: 16,
                          shadows: const [
                            BoxShadow(
                              color: Colors.black45,
                              offset: Offset(1, 1),
                              blurRadius: 1,
                            )
                          ],
                        ),
                        child: ValueListenableBuilder<int>(
                          valueListenable: _page,
                          builder: (context, value, child) =>
                              widget.info?.call(context, value) ??
                              const SizedBox(),
                        )),
                  ),
                  Row(
                    children: List.generate(
                      widget.rarity,
                      (i) => const Icon(
                        Icons.star_rounded,
                        color: Colors.yellow,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.pages > 1)
            ValueListenableBuilder(
              valueListenable: _page,
              builder: (context, value, child) {
                return Row(
                  children: [
                    if (value != 0)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Transform.translate(
                          offset: const Offset(-30, 0),
                          child: IconButton(
                            iconSize: 80,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            color: Colors.white30,
                            onPressed: () => _page.value--,
                            icon: const Icon(Icons.arrow_left_rounded),
                          ),
                        ),
                      ),
                    const Spacer(),
                    if (value != widget.pages - 1)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Transform.translate(
                          offset: const Offset(30, 0),
                          child: IconButton(
                            iconSize: 80,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            color: Colors.white30,
                            onPressed: () => _page.value++,
                            icon: const Icon(Icons.arrow_right_rounded),
                          ),
                        ),
                      ),
                  ],
                );
              },
            )
        ],
      ),
    );
  }

  Widget _content(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(kSeparator8),
      decoration: const BoxDecoration(
        color: Color(0xFFEDE5D8),
        border: Border(
          bottom: BorderSide(color: Color(0xFFDDDAC2), width: 4),
        ),
      ),
      child: ValueListenableBuilder<int>(
        valueListenable: _page,
        builder: (context, value, child) =>
            widget.child?.call(context, value) ?? const SizedBox(),
      ),
    );
  }
}

class ItemRarityBubble extends StatelessWidget {
  final int rarity;
  final double size;
  final String image;
  final String tooltip;
  final Widget? child;
  final VoidCallback? onTap;

  const ItemRarityBubble({
    super.key,
    this.size = 48,
    this.rarity = 1,
    this.image = '',
    this.tooltip = '',
    this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget widget = Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: GsColors.mainColor0.withOpacity(0.6),
            borderRadius: BorderRadius.circular(size),
          ),
          padding: const EdgeInsets.all(kSeparator2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(getRarityBgImage(rarity)),
                  fit: BoxFit.cover,
                ),
              ),
              child: onTap != null
                  ? InkWell(
                      onTap: onTap,
                      child: CachedImageWidget(image),
                    )
                  : CachedImageWidget(image),
            ),
          ),
        ),
        SizedBox(
          width: size,
          height: size,
          child: child,
        )
      ],
    );
    if (tooltip.isNotEmpty) {
      widget = Tooltip(
        message: tooltip,
        child: widget,
      );
    }

    return widget;
  }
}
