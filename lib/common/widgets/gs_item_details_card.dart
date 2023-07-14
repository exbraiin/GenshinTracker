import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';

typedef Action<R> = R Function(BuildContext context, int page);

class ItemDetailsCard extends StatefulWidget {
  final int rarity;
  final int pages;
  final String name;
  final GsItemBanner? banner;
  final Action<Widget>? info;
  final Action<String>? asset;
  final Action<String>? image;
  final Action<String>? fgImage;
  final Action<Widget>? child;

  ItemDetailsCard.single({
    super.key,
    this.name = '',
    this.rarity = 0,
    this.banner,
    Widget? info,
    String? asset,
    String? image,
    String? fgImage,
    Widget? child,
  })  : pages = 1,
        info = info != null ? ((_, __) => info) : null,
        asset = asset != null ? ((_, __) => asset) : null,
        image = image != null ? ((_, __) => image) : null,
        fgImage = fgImage != null ? ((_, __) => fgImage) : null,
        child = child != null ? ((_, __) => child) : null;

  const ItemDetailsCard.paged({
    super.key,
    required this.pages,
    this.name = '',
    this.rarity = 0,
    this.banner,
    this.info,
    this.asset,
    this.image,
    this.fgImage,
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
    final rarity = widget.rarity.coerceAtLeast(1);
    final color = context.themeColors.getRarityColor(rarity);
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
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.name,
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white60, width: 2),
                borderRadius: BorderRadius.circular(48),
              ),
              child: Center(
                child: InkWell(
                  onTap: () => Navigator.of(context).maybePop(),
                  child: const AspectRatio(
                    aspectRatio: 1,
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white60,
                      size: 20,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _headerInfo(BuildContext context) {
    final rarity = widget.rarity.coerceAtLeast(1);
    final color = context.themeColors.getRarityColor(rarity);
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
                      if (widget.asset != null) {
                        return Image.asset(
                          widget.asset!.call(context, value),
                        );
                      }
                      if (widget.image != null) {
                        return CachedImageWidget(
                          widget.image!.call(context, value),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ),
          if (widget.fgImage != null)
            Positioned.fill(
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
          if (widget.banner != null && widget.banner!.text.isNotEmpty)
            Positioned.fill(
              child: ClipRect(
                child: Banner(
                  color: widget.banner!.color,
                  message: widget.banner!.text,
                  location: widget.banner!.location,
                ),
              ),
            ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(kSeparator4),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: DefaultTextStyle(
                      style: context.textTheme.titleLarge!.copyWith(
                        color: context.themeColors.dimWhite,
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
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: Row(
                      children: List.generate(
                        widget.rarity,
                        (i) => Transform.translate(
                          offset: Offset(i * -6, 0),
                          child: const Icon(
                            Icons.star_rounded,
                            size: 30,
                            color: Colors.yellow,
                            shadows: kMainShadow,
                          ),
                        ),
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

class ItemDetailsCardContent {
  final String? label;
  final Widget? content;
  final String? description;

  ItemDetailsCardContent({this.label, this.content, this.description});

  static Widget generate(
    BuildContext context,
    List<ItemDetailsCardContent> items,
  ) {
    final texts = <InlineSpan>[];

    final labelStyle = TextStyle(
      fontSize: 20,
      color: context.themeColors.primary80,
      fontWeight: FontWeight.bold,
    );

    for (var item in items) {
      if (item.label != null) {
        if (texts.isNotEmpty) texts.add(const TextSpan(text: '\n\n'));
        texts.add(TextSpan(text: '${item.label}\n', style: labelStyle));

        if (item.description != null) {
          texts.add(TextSpan(text: '${item.description}'));
        }
        if (item.content != null) {
          texts.add(
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(top: kSeparator4),
                child: item.content!,
              ),
            ),
          );
        }
      } else if (item.description != null) {
        if (texts.isNotEmpty) texts.add(const TextSpan(text: '\n\n'));
        final style = TextStyle(fontSize: 14, color: Colors.grey[600]);
        texts.add(TextSpan(text: item.description, style: style));
      }
    }

    return DefaultTextStyle(
      style: TextStyle(
        fontSize: 16,
        color: Colors.black.withOpacity(0.75),
        fontWeight: FontWeight.bold,
      ),
      child: Text.rich(
        TextSpan(children: texts),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

class ItemRarityBubble extends StatelessWidget {
  final int rarity;
  final double size;
  final String image;
  final String asset;
  final String tooltip;
  final Color? color;
  final Color? borderColor;
  final Widget? child;
  final VoidCallback? onTap;

  const ItemRarityBubble({
    super.key,
    this.size = 50,
    this.rarity = 0,
    this.asset = '',
    this.image = '',
    this.tooltip = '',
    this.color,
    this.borderColor,
    this.child,
    this.onTap,
  });

  ItemRarityBubble.withLabel({
    super.key,
    this.size = 50,
    this.rarity = 0,
    this.asset = '',
    this.image = '',
    this.tooltip = '',
    this.color,
    this.borderColor,
    this.onTap,
    required String label,
    Color labelColor = Colors.white,
  }) : child = IgnorePointer(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black54,
                child: Align(
                  alignment: Alignment.center,
                  heightFactor: 1,
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      color: labelColor,
                      shadows: kMainShadow,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

  @override
  Widget build(BuildContext context) {
    final img = asset.isNotEmpty
        ? Image.asset(asset)
        : image.isNotEmpty
            ? CachedImageWidget(image)
            : const SizedBox();

    Widget widget = Stack(
      children: [
        MouseHoverBuilder(
          builder: (context, value, child) => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: value && onTap != null
                  ? context.themeColors.almostWhite
                  : (borderColor ??
                      context.themeColors.mainColor0.withOpacity(0.6)),
              borderRadius: BorderRadius.circular(size),
            ),
            padding: const EdgeInsets.all(kSeparator2),
            child: child,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                image: rarity.between(1, 5)
                    ? DecorationImage(
                        image: AssetImage(getRarityBgImage(rarity)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: onTap != null
                  ? InkWell(
                      onTap: onTap,
                      child: img,
                    )
                  : img,
            ),
          ),
        ),
        if (child != null)
          SizedBox(
            width: size,
            height: size,
            child: DefaultTextStyle(
              style:
                  context.textTheme.bodySmall?.copyWith(color: Colors.white) ??
                      const TextStyle(),
              child: child!,
            ),
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
