import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';
import 'package:tracker/common/widgets/text_style_parser.dart';

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
      height: 56,
      color: color,
      child: Container(
        margin: const EdgeInsets.all(kSeparator2),
        padding: const EdgeInsets.all(kSeparator8),
        decoration: BoxDecoration(
          border: Border.all(
            color: color1,
            width: kSeparator2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      '${widget.name} ',
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
              if (Navigator.of(context).canPop())
                Container(
                  margin: const EdgeInsets.only(left: 32),
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
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerInfo(BuildContext context) {
    final banner = widget.banner;
    final rarity = widget.rarity.coerceAtLeast(1);
    final color = context.themeColors.getRarityColor(rarity);
    final color1 = Color.lerp(Colors.black, color, 0.8)!;
    return Container(
      height: 180,
      width: double.infinity,
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(color: color1),
      foregroundDecoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: color1.withOpacity(0.6), width: 4),
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: ValueListenableBuilder<int>(
                      valueListenable: _page,
                      builder: (context, value, child) {
                        if (widget.asset != null) {
                          return Image.asset(
                            widget.asset!.call(context, value),
                          );
                        }
                        if (widget.image != null) {
                          return AspectRatio(
                            aspectRatio: 1,
                            child: CachedImageWidget(
                              widget.image!.call(context, value),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
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
          if (banner != null && banner.text.isNotEmpty)
            Positioned.fill(
              child: ClipRect(
                child: Banner(
                  color: banner.color,
                  message: banner.text,
                  location: banner.location,
                ),
              ),
            ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(kSeparator8),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: DefaultTextStyle(
                      style: context.textTheme.titleLarge!.copyWith(
                        color: context.themeColors.almostWhite,
                        fontSize: 16,
                        shadows: const [
                          BoxShadow(
                            color: Colors.black45,
                            offset: Offset(1, 1),
                            blurRadius: 1,
                          ),
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
            ),
        ],
      ),
    );
  }

  Widget _content(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: kSeparator8,
        horizontal: kSeparator8 * 2,
      ),
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
  final bool useMarkdown;
  final String? description;

  ItemDetailsCardContent({
    this.label,
    this.content,
    this.description,
    this.useMarkdown = false,
  });

  static Widget generate(
    BuildContext context,
    List<ItemDetailsCardContent> items,
  ) {
    final texts = <InlineSpan>[];

    final labelStyle = TextStyle(
      fontSize: 18,
      color: context.themeColors.primary80,
      fontWeight: FontWeight.bold,
    );

    final style = TextStyle(fontSize: 14, color: Colors.grey[600]);
    for (var item in items) {
      if (item.label != null) {
        if (texts.isNotEmpty) texts.add(const TextSpan(text: '\n\n'));
        texts.add(TextSpan(text: '${item.label}\n', style: labelStyle));

        if (item.description != null) {
          if (item.useMarkdown) {
            final parser = TextParserWidget(item.description!, style: style);
            texts.addAll(parser.getChildren(context));
          } else {
            texts.add(TextSpan(text: item.description, style: style));
          }
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

        if (item.useMarkdown) {
          final parser = TextParserWidget(item.description!, style: style);
          texts.addAll(parser.getChildren(context));
        } else {
          texts.add(TextSpan(text: item.description, style: style));
        }
      }
    }

    return DefaultTextStyle(
      style: TextStyle(
        fontSize: 16,
        color: Colors.black.withOpacity(0.75),
        fontWeight: FontWeight.w600,
      ),
      child: Text.rich(
        TextSpan(children: texts),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
