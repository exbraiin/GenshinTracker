import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/characters_screen/character_details_screen.dart';
import 'package:tracker/screens/materials_screen/material_details_card.dart';
import 'package:tracker/screens/recipes_screen/recipe_details_card.dart';
import 'package:tracker/screens/weapons_screen/weapon_details_card.dart';

typedef ContextCallback<T> = void Function(BuildContext context, T item);

void _callMaterial(BuildContext ctx, InfoMaterial info) =>
    MaterialDetailsCard(info).show(ctx);
void _callRecipe(BuildContext ctx, InfoRecipe info) =>
    RecipeDetailsCard(info).show(ctx);
void _callWeapon(BuildContext ctx, InfoWeapon info) =>
    WeaponDetailsCard(info).show(ctx);
void _callCharacter(BuildContext ctx, InfoCharacter info) =>
    Navigator.of(ctx).pushNamed(CharacterDetailsScreen.id, arguments: info);

enum ItemSize { small, medium, large }

class ItemGridWidget extends StatelessWidget {
  final int rarity;
  final ItemSize size;
  final bool disabled;
  final String label;
  final String tooltip;
  final String urlImage;
  final String assetImage;
  final void Function(BuildContext ctx)? onTap;

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
  });

  ItemGridWidget.material(
    InfoMaterial info, {
    super.key,
    this.size = ItemSize.small,
    this.label = '',
    this.disabled = false,
    ContextCallback<InfoMaterial>? onTap = _callMaterial,
  })  : rarity = info.rarity,
        tooltip = info.name,
        urlImage = info.image,
        assetImage = '',
        onTap = onTap != null ? ((ctx) => onTap(ctx, info)) : null;

  ItemGridWidget.recipe(
    InfoRecipe info, {
    super.key,
    this.size = ItemSize.small,
    this.label = '',
    this.disabled = false,
    ContextCallback<InfoRecipe>? onTap = _callRecipe,
  })  : rarity = info.rarity,
        tooltip = info.name,
        urlImage = info.image,
        assetImage = '',
        onTap = onTap != null ? ((ctx) => onTap(ctx, info)) : null;

  ItemGridWidget.weapon(
    InfoWeapon info, {
    super.key,
    this.size = ItemSize.small,
    this.label = '',
    this.disabled = false,
    ContextCallback<InfoWeapon>? onTap = _callWeapon,
  })  : rarity = info.rarity,
        tooltip = info.name,
        urlImage = info.image,
        assetImage = '',
        onTap = onTap != null ? ((ctx) => onTap(ctx, info)) : null;

  ItemGridWidget.character(
    InfoCharacter info, {
    super.key,
    this.size = ItemSize.small,
    this.label = '',
    this.disabled = false,
    ContextCallback<InfoCharacter>? onTap = _callCharacter,
  })  : rarity = info.rarity,
        tooltip = info.name,
        urlImage = GsUtils.characters.getImage(info.id),
        assetImage = '',
        onTap = onTap != null ? ((ctx) => onTap(ctx, info)) : null;

  @override
  Widget build(BuildContext context) {
    var child = urlImage.isNotEmpty
        ? CachedImageWidget(urlImage)
        : Image.asset(assetImage);

    if (label.isNotEmpty) {
      child = Stack(
        children: [
          Positioned.fill(child: child),
          Positioned.fill(
            top: null,
            child: Container(
              color: context.themeColors.mainColor1.withOpacity(0.6),
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

    final size = switch (this.size) {
      ItemSize.small => 48.0,
      ItemSize.medium => 56.0,
      ItemSize.large => 70.0,
    };

    child = Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.themeColors.mainColor1,
        borderRadius: kGridRadius,
        image: DecorationImage(
          image: AssetImage(getRarityBgImage(rarity)),
          fit: BoxFit.cover,
        ),
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

    if (disabled) {
      child = Opacity(
        opacity: kDisableOpacity,
        child: child,
      );
    }

    return child;
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

  const ItemCircleWidget({
    super.key,
    this.size = ItemSize.medium,
    this.child,
    this.bgColor,
    this.rarity = 0,
    this.label = '',
    this.tooltip = '',
    this.image = '',
    this.asset = '',
  });

  ItemCircleWidget.material(
    InfoMaterial info, {
    super.key,
    this.size = ItemSize.medium,
  })  : label = '',
        asset = '',
        tooltip = '',
        rarity = info.rarity,
        child = null,
        bgColor = null,
        image = info.image;

  ItemCircleWidget.city(
    InfoCity city, {
    super.key,
    this.size = ItemSize.medium,
  })  : label = '',
        child = null,
        asset = '',
        tooltip = '',
        rarity = 1,
        bgColor = city.element.color,
        image = city.image;

  ItemCircleWidget.setCategory(
    GsSetCategory info, {
    super.key,
    this.size = ItemSize.medium,
  })  : rarity = 1,
        child = null,
        label = '',
        tooltip = '',
        image = '',
        bgColor = info.color,
        asset = info.asset;

  @override
  Widget build(BuildContext context) {
    var child = image.isNotEmpty
        ? CachedImageWidget(image)
        : asset.isNotEmpty
            ? Image.asset(asset)
            : const SizedBox();

    child = Stack(
      children: [
        Positioned.fill(child: child),
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

    final size = switch (this.size) {
      ItemSize.small => 30.0,
      ItemSize.medium => 44.0,
      ItemSize.large => 56.0,
    };

    child = Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: bgColor ?? context.themeColors.mainColor0.withOpacity(0.4),
        border: Border.all(color: context.themeColors.mainColor1, width: 2),
        shape: BoxShape.circle,
        image: 1 <= rarity && rarity <= 5
            ? DecorationImage(
                image: AssetImage(getRarityBgImage(rarity)),
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
