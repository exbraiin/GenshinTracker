import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';
import 'package:tracker/domain/enums/enum_ext.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/characters_screen/character_details_card.dart';
import 'package:tracker/screens/materials_screen/material_details_card.dart';
import 'package:tracker/screens/recipes_screen/recipe_details_card.dart';
import 'package:tracker/screens/weapons_screen/weapon_details_card.dart';

typedef ContextCallback<T> = void Function(BuildContext context, T item);

void _callMaterial(BuildContext ctx, GsMaterial info) =>
    MaterialDetailsCard(info).show(ctx);
void _callRecipe(BuildContext ctx, GsRecipe info) =>
    RecipeDetailsCard(info).show(ctx);
void _callWeapon(BuildContext ctx, GsWeapon info) =>
    WeaponDetailsCard(info).show(ctx);
void _callCharacter(BuildContext ctx, GsCharacter info) =>
    CharacterDetailsCard(info).show(ctx);

enum ItemSize {
  small(50, 30),
  medium(56, 44),
  large(70, 56);

  final double gridSize;
  final double circleSize;

  const ItemSize(this.gridSize, this.circleSize);
}

class ItemGridWidget extends StatelessWidget {
  final int rarity;
  final ItemSize size;
  final bool disabled;
  final String label;
  final String tooltip;
  final String urlImage;
  final String assetImage;
  final void Function(BuildContext ctx)? onTap;
  final void Function(BuildContext ctx)? onAdd;
  final void Function(BuildContext ctx)? onRemove;

  const ItemGridWidget({
    super.key,
    this.size = ItemSize.small,
    this.label = '',
    this.rarity = 1,
    this.tooltip = '',
    this.urlImage = '',
    this.assetImage = '',
    this.disabled = false,
    this.onTap,
    this.onAdd,
    this.onRemove,
  });

  ItemGridWidget.material(
    GsMaterial info, {
    super.key,
    this.size = ItemSize.small,
    this.label = '',
    this.disabled = false,
    this.onAdd,
    this.onRemove,
    ContextCallback<GsMaterial>? onTap = _callMaterial,
  })  : rarity = info.rarity,
        tooltip = info.name,
        urlImage = info.image,
        assetImage = '',
        onTap = onTap != null ? ((ctx) => onTap(ctx, info)) : null;

  ItemGridWidget.recipe(
    GsRecipe info, {
    super.key,
    this.size = ItemSize.small,
    this.label = '',
    this.disabled = false,
    this.onAdd,
    this.onRemove,
    bool tooltip = true,
    ContextCallback<GsRecipe>? onTap = _callRecipe,
  })  : rarity = info.rarity,
        tooltip = tooltip ? info.name : '',
        urlImage = info.image,
        assetImage = '',
        onTap = onTap != null ? ((ctx) => onTap(ctx, info)) : null;

  ItemGridWidget.weapon(
    GsWeapon info, {
    super.key,
    this.size = ItemSize.small,
    this.label = '',
    this.disabled = false,
    this.onAdd,
    this.onRemove,
    ContextCallback<GsWeapon>? onTap = _callWeapon,
  })  : rarity = info.rarity,
        tooltip = info.name,
        urlImage = info.image,
        assetImage = '',
        onTap = onTap != null ? ((ctx) => onTap(ctx, info)) : null;

  ItemGridWidget.character(
    GsCharacter info, {
    super.key,
    this.size = ItemSize.small,
    this.label = '',
    this.disabled = false,
    this.onAdd,
    this.onRemove,
    ContextCallback<GsCharacter>? onTap = _callCharacter,
  })  : rarity = info.rarity,
        tooltip = info.name,
        urlImage = GsUtils.characters.getImage(info.id),
        assetImage = '',
        onTap = onTap != null ? ((ctx) => onTap(ctx, info)) : null;

  @override
  Widget build(BuildContext context) {
    var child = urlImage.isNotEmpty
        ? CachedImageWidget(urlImage)
        : assetImage.isNotEmpty
            ? Image.asset(assetImage)
            : const SizedBox();

    if (label.isNotEmpty) {
      child = Stack(
        children: [
          Positioned.fill(child: child),
          Positioned.fill(
            top: null,
            left: -1,
            right: -1,
            bottom: -1,
            child: Container(
              color: context.themeColors.mainColor1.withOpacity(0.8),
              alignment: Alignment.center,
              child: Text(
                label,
                maxLines: 1,
                style: context.themeStyles.label14n,
                strutStyle: context.themeStyles.label14n.toStrut(),
              ),
            ),
          ),
        ],
      );
    }

    child = Container(
      width: size.gridSize,
      height: size.gridSize,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.themeColors.mainColor1,
        borderRadius: kGridRadius,
        image: rarity.between(1, 5)
            ? DecorationImage(
                image: AssetImage(GsAssets.getRarityBgImage(rarity)),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: child,
    );

    if (tooltip.isNotEmpty) {
      child = Tooltip(
        message: tooltip,
        child: child,
      );
    }

    if (onTap != null) {
      child = MouseHoverBuilder(
        builder: (context, value, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            foregroundDecoration: BoxDecoration(
              borderRadius: kGridRadius,
              border: Border.all(
                color: value
                    ? context.themeColors.almostWhite
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: child,
          );
        },
        child: InkWell(
          onTap: () => onTap!(context),
          child: child,
        ),
      );
    }

    child = Stack(
      children: [
        child,
        if (onAdd != null)
          Positioned(
            top: 0,
            right: 0,
            child: _button(
              onTap: () => onAdd!(context),
              icon: Icons.add_rounded,
              color: Colors.green,
              iconColor: Colors.white,
              isTopLeft: false,
            ),
          ),
        if (onRemove != null)
          Positioned(
            top: 0,
            left: 0,
            child: _button(
              onTap: () => onRemove!(context),
              icon: Icons.remove_rounded,
              color: context.themeColors.setIndoor,
              iconColor: Colors.white,
              isTopLeft: true,
            ),
          ),
      ],
    );

    if (disabled) {
      child = Opacity(
        opacity: kDisableOpacity,
        child: child,
      );
    }

    return child;
  }

  Widget _button({
    required Color color,
    required Color iconColor,
    required IconData icon,
    required VoidCallback onTap,
    required bool isTopLeft,
  }) {
    return MouseHoverBuilder(
      builder: (context, value, child) {
        return InkWell(
          onTap: onTap,
          child: AnimatedContainer(
            width: 20,
            height: 20,
            duration: const Duration(milliseconds: 400),
            decoration: BoxDecoration(
              color: value ? iconColor : color,
              borderRadius: kGridRadius.copyWith(
                topLeft: !isTopLeft ? Radius.zero : null,
                topRight: isTopLeft ? Radius.zero : null,
                bottomLeft: isTopLeft ? Radius.zero : null,
                bottomRight: !isTopLeft ? Radius.zero : null,
              ),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 2,
                  offset: Offset(1, 1),
                  color: Colors.black26,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                icon,
                size: 16,
                color: value ? color : iconColor,
              ),
            ),
          ),
        );
      },
    );
  }
}

class ItemCircleWidget extends StatelessWidget {
  final ItemSize size;
  final Color? bgColor;
  final int rarity;
  final Widget? child;
  final String label;
  final String tooltip;
  final String image;
  final String asset;
  final EdgeInsetsGeometry padding;

  const ItemCircleWidget({
    super.key,
    this.size = ItemSize.medium,
    this.padding = const EdgeInsets.all(2),
    this.child,
    this.bgColor,
    this.rarity = 0,
    this.label = '',
    this.tooltip = '',
    this.image = '',
    this.asset = '',
  });

  factory ItemCircleWidget.element(
    GeElementType element, {
    ItemSize size = ItemSize.small,
    String label = '',
  }) {
    return ItemCircleWidget(
      size: size,
      asset: element.assetPath,
      label: label,
    );
  }

  factory ItemCircleWidget.material(
    GsMaterial info, {
    ItemSize size = ItemSize.medium,
  }) {
    return ItemCircleWidget(
      size: size,
      image: info.image,
      rarity: info.rarity,
    );
  }

  factory ItemCircleWidget.region(
    GeRegionType type, {
    ItemSize size = ItemSize.medium,
  }) {
    return ItemCircleWidget(
      rarity: 1,
      size: size,
      asset: GsAssets.iconRegionType(type),
      bgColor: type.color,
    );
  }

  factory ItemCircleWidget.setCategory(
    GeSereniteaSetType info, {
    ItemSize size = ItemSize.medium,
  }) {
    return ItemCircleWidget(
      rarity: 1,
      size: size,
      asset: GsAssets.iconSetType(info),
      bgColor: info.color,
    );
  }

  @override
  Widget build(BuildContext context) {
    var child = image.isNotEmpty
        ? CachedImageWidget(image)
        : asset.isNotEmpty
            ? Image.asset(asset)
            : const SizedBox();

    child = Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
        if (this.child != null)
          Padding(
            padding: const EdgeInsets.all(2),
            child: DefaultTextStyle(
              style: context.themeStyles.label12n,
              child: this.child!,
            ),
          ),
        if (label.isNotEmpty)
          Positioned.fill(
            top: null,
            child: Container(
              color: context.themeColors.mainColor1.withOpacity(0.6),
              alignment: Alignment.center,
              child: Text(
                label,
                maxLines: 1,
                style: context.themeStyles.label12n,
                strutStyle: context.themeStyles.label12n.toStrut(),
              ),
            ),
          ),
      ],
    );

    child = Container(
      width: size.circleSize,
      height: size.circleSize,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: bgColor ?? context.themeColors.mainColor0.withOpacity(0.4),
        border: Border.all(color: context.themeColors.mainColor1, width: 2),
        shape: BoxShape.circle,
        image: 1 <= rarity && rarity <= 5
            ? DecorationImage(
                image: AssetImage(GsAssets.getRarityBgImage(rarity)),
                colorFilter: bgColor != null
                    ? ColorFilter.mode(bgColor!, BlendMode.softLight)
                    : null,
              )
            : null,
      ),
      foregroundDecoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: context.themeColors.mainColor1, width: 2),
      ),
      child: child,
    );

    if (tooltip.isNotEmpty) {
      child = Tooltip(
        message: tooltip,
        child: child,
      );
    }

    return child;
  }
}
