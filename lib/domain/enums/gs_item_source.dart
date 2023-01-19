enum GsItemSource {
  none,
  shop,
  event,
  fishing,
  forging,
  battlepass,
  exploration,
  wishesStandard,
  wishesWeaponBanner,
  wishesCharacterBanner,
}

extension GsItemSourceList on List<GsItemSource> {
  GsItemSource fromName(String? id) {
    return const {
          'shop': GsItemSource.shop,
          'event': GsItemSource.event,
          'fishing': GsItemSource.fishing,
          'forging': GsItemSource.forging,
          'battlepass': GsItemSource.battlepass,
          'exploration': GsItemSource.exploration,
          'wishes_standard': GsItemSource.wishesStandard,
          'wishes_weapon_banner': GsItemSource.wishesWeaponBanner,
          'wishes_character_banner': GsItemSource.wishesCharacterBanner,
        }[id] ??
        GsItemSource.none;
  }
}
