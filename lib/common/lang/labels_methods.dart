final class LabelsMethods {
	final String Function(String key, [Map<String, dynamic> params]) transformer;

	/// Creates a new [LabelsMethods] instance.
	LabelsMethods(this.transformer);

	/// Ok
	String ok() {
		return transformer('ok');
	}

	/// Home
	String home() {
		return transformer('home');
	}

	/// Character Wishes
	String charWishes() {
		return transformer('char_wishes');
	}

	/// Weapon Wishes
	String weaponWishes() {
		return transformer('weapon_wishes');
	}

	/// Standard Wishes
	String stndWishes() {
		return transformer('stnd_wishes');
	}

	/// Beginners' Wishes
	String noviceWishes() {
		return transformer('novice_wishes');
	}

	/// Chronicled Wish
	String chronicledWishes() {
		return transformer('chronicled_wishes');
	}

	/// Serenitea Sets
	String sereniteaSets() {
		return transformer('serenitea_sets');
	}

	/// Recipes
	String recipes() {
		return transformer('recipes');
	}

	/// Last Banner
	String lastBanner() {
		return transformer('last_banner');
	}

	/// Energy: {number}
	String energyN(dynamic number) {
		return transformer('energy_n', {'number': number});
	}

	/// Remarkable Chests
	String remarkableChests() {
		return transformer('remarkable_chests');
	}

	/// Envisaged Echoes
	String envisagedEchoes() {
		return transformer('envisaged_echoes');
	}

	/// Weapon
	String weapon() {
		return transformer('weapon');
	}

	/// Wishes
	String wishes() {
		return transformer('wishes');
	}

	/// Time
	String time() {
		return transformer('time');
	}

	/// Pity
	String pity() {
		return transformer('pity');
	}

	/// Roll
	String roll() {
		return transformer('roll');
	}

	/// World
	String world() {
		return transformer('world');
	}

	/// Chubby
	String chubby() {
		return transformer('chubby');
	}

	/// Source
	String source() {
		return transformer('source');
	}

	/// Outfits
	String outfits() {
		return transformer('outfits');
	}

	/// Spincrystals
	String spincrystals() {
		return transformer('spincrystals');
	}

	/// Weapons
	String weapons() {
		return transformer('weapons');
	}

	/// Character
	String character() {
		return transformer('character');
	}

	/// Characters
	String characters() {
		return transformer('characters');
	}

	/// Achievements
	String achievements() {
		return transformer('achievements');
	}

	/// Ingredients
	String ingredients() {
		return transformer('ingredients');
	}

	/// Reputation
	String reputation() {
		return transformer('reputation');
	}

	/// Rarity
	String rarity() {
		return transformer('rarity');
	}

	/// Type
	String type() {
		return transformer('type');
	}

	/// Filter
	String filter() {
		return transformer('filter');
	}

	/// Talents
	String talents() {
		return transformer('talents');
	}

	/// Constellations
	String constellations() {
		return transformer('constellations');
	}

	/// Owned
	String owned() {
		return transformer('owned');
	}

	/// Unowned
	String unowned() {
		return transformer('unowned');
	}

	/// Element
	String element() {
		return transformer('element');
	}

	/// Total
	String total() {
		return transformer('total');
	}

	/// Percent
	String per() {
		return transformer('per');
	}

	/// {star}★
	String rarityStar(dynamic star) {
		return transformer('rarity_star', {'star': star});
	}

	/// Master
	String master() {
		return transformer('master');
	}

	/// City
	String city() {
		return transformer('city');
	}

	/// Current
	String current() {
		return transformer('current');
	}

	/// Max
	String max() {
		return transformer('max');
	}

	/// Remove
	String remove() {
		return transformer('remove');
	}

	/// Are you sure?
	String youSure() {
		return transformer('you_sure');
	}

	/// Do you want to remove "{name}" last wish?
	String removeWish(dynamic name) {
		return transformer('remove_wish', {'name': name});
	}

	/// Status
	String status() {
		return transformer('status');
	}

	/// Obtainable
	String obtainable() {
		return transformer('obtainable');
	}

	/// Ongoing
	String ongoing() {
		return transformer('ongoing');
	}

	/// Name
	String name() {
		return transformer('name');
	}

	/// Version
	String version() {
		return transformer('version');
	}

	/// Proficiency
	String proficiency() {
		return transformer('proficiency');
	}

	/// 2nd Stat
	String ndStat() {
		return transformer('nd_stat');
	}

	/// Add Wish
	String addWish() {
		return transformer('add_wish');
	}

	/// Add Wishes
	String addWishes() {
		return transformer('add_wishes');
	}

	/// No Wishes
	String noWishes() {
		return transformer('no_wishes');
	}

	/// No Results Found!
	String noResults() {
		return transformer('no_results');
	}

	/// {weeks} Weeks
	String nWeeks(dynamic weeks) {
		return transformer('n_weeks', {'weeks': weeks});
	}

	/// {from} to {to} Weeks
	String nnWeeks(dynamic from, dynamic to) {
		return transformer('nn_weeks', {'from': from, 'to': to});
	}

	/// Lv. 
	String levelShort() {
		return transformer('level_short');
	}

	/// Lifetime Pulls
	String lifetimePulls() {
		return transformer('lifetime_pulls');
	}

	/// 4★ Pity
	String l4sPity() {
		return transformer('l4s_pity');
	}

	/// 5★ Pity
	String l5sPity() {
		return transformer('l5s_pity');
	}

	/// Weekly Tasks
	String weeklyTasks() {
		return transformer('weekly_tasks');
	}

	/// Friend
	String friend() {
		return transformer('friend');
	}

	/// Friendship
	String friendship() {
		return transformer('friendship');
	}

	/// Indoor
	String indoor() {
		return transformer('indoor');
	}

	/// Outdoor
	String outdoor() {
		return transformer('outdoor');
	}

	/// Catalyst
	String wpCatalyst() {
		return transformer('wp_catalyst');
	}

	/// Polearm
	String wpPolearm() {
		return transformer('wp_polearm');
	}

	/// Claymore
	String wpClaymore() {
		return transformer('wp_claymore');
	}

	/// Sword
	String wpSword() {
		return transformer('wp_sword');
	}

	/// Bow
	String wpBow() {
		return transformer('wp_bow');
	}

	/// Geo
	String elGeo() {
		return transformer('el_geo');
	}

	/// Cryo
	String elCryo() {
		return transformer('el_cryo');
	}

	/// Pyro
	String elPyro() {
		return transformer('el_pyro');
	}

	/// Hydro
	String elHydro() {
		return transformer('el_hydro');
	}

	/// Anemo
	String elAnemo() {
		return transformer('el_anemo');
	}

	/// Dendro
	String elDendro() {
		return transformer('el_dendro');
	}

	/// Electro
	String elElectro() {
		return transformer('el_electro');
	}

	/// None
	String wsNone() {
		return transformer('ws_none');
	}

	/// HP
	String wsHp() {
		return transformer('ws_hp');
	}

	/// ATK
	String wsAtk() {
		return transformer('ws_atk');
	}

	/// DEF
	String wsDef() {
		return transformer('ws_def');
	}

	/// Crit DMG
	String wsCritdmg() {
		return transformer('ws_critDmg');
	}

	/// Crit Rate
	String wsCritrate() {
		return transformer('ws_critRate');
	}

	/// Physical DMG
	String wsPhysicaldmg() {
		return transformer('ws_physicalDmg');
	}

	/// Elemental Mastery
	String wsElementalmastery() {
		return transformer('ws_elementalMastery');
	}

	/// Energy Recharge
	String wsEnergyrecharge() {
		return transformer('ws_energyRecharge');
	}

	/// Healing
	String wsHealing() {
		return transformer('ws_healing');
	}

	/// HP%
	String wsHpPercent() {
		return transformer('ws_hp_percent');
	}

	/// ATK%
	String wsAtkPercent() {
		return transformer('ws_atk_percent');
	}

	/// DEF%
	String wsDefPercent() {
		return transformer('ws_def_percent');
	}

	/// Anemo DMG
	String wsAnemoDmg() {
		return transformer('ws_anemo_dmg');
	}

	/// Geo DMG
	String wsGeoBonus() {
		return transformer('ws_geo_bonus');
	}

	/// Electro DMG
	String wsElectroBonus() {
		return transformer('ws_electro_bonus');
	}

	/// Dendro DMG
	String wsDendroBonus() {
		return transformer('ws_dendro_bonus');
	}

	/// Hydro DMG
	String wsHydroBonus() {
		return transformer('ws_hydro_bonus');
	}

	/// Pyro DMG
	String wsPyroBonus() {
		return transformer('ws_pyro_bonus');
	}

	/// Cryo DMG
	String wsCryoBonus() {
		return transformer('ws_cryo_bonus');
	}

	/// Resource Calculator
	String resourceCalculator() {
		return transformer('resource_calculator');
	}

	/// Required
	String required() {
		return transformer('required');
	}

	/// Missing
	String missing() {
		return transformer('missing');
	}

	/// Craftable
	String craftable() {
		return transformer('craftable');
	}

	/// Hide empty banners!
	String hideEmptyBanners() {
		return transformer('hide_empty_banners');
	}

	/// Won 50/50
	String won5050() {
		return transformer('won_5050');
	}

	/// Won 75/25
	String won7525() {
		return transformer('won_7525');
	}

	/// Lost 50/50
	String lost5050() {
		return transformer('lost_5050');
	}

	/// Lost 75/25
	String lost7525() {
		return transformer('lost_7525');
	}

	/// Guaranteed
	String guaranteed() {
		return transformer('guaranteed');
	}

	/// Select Date
	String selectDate() {
		return transformer('select_date');
	}

	/// Ascension
	String ascension() {
		return transformer('ascension');
	}

	/// Show extra info
	String showExtraInfo() {
		return transformer('show_extra_info');
	}

	/// Region
	String region() {
		return transformer('region');
	}

	/// None
	String regionNone() {
		return transformer('region_none');
	}

	/// Mondstadt
	String regionMondstadt() {
		return transformer('region_mondstadt');
	}

	/// Liyue
	String regionLiyue() {
		return transformer('region_liyue');
	}

	/// Inazuma
	String regionInazuma() {
		return transformer('region_inazuma');
	}

	/// Sumeru
	String regionSumeru() {
		return transformer('region_sumeru');
	}

	/// Fontaine
	String regionFontaine() {
		return transformer('region_fontaine');
	}

	/// Natlan
	String regionNatlan() {
		return transformer('region_natlan');
	}

	/// Snezhnaya
	String regionSnezhnaya() {
		return transformer('region_snezhnaya');
	}

	/// Khaenri'ah
	String regionKhaenriah() {
		return transformer('region_khaenriah');
	}

	/// Artifacts
	String artifacts() {
		return transformer('artifacts');
	}

	/// Revive
	String rbRevive() {
		return transformer('rb_revive');
	}

	/// Adventure
	String rbAdventure() {
		return transformer('rb_adventure');
	}

	/// DEF Boost
	String rbDef() {
		return transformer('rb_def');
	}

	/// ATK Boost
	String rbAtk() {
		return transformer('rb_atk');
	}

	/// ATK CRIT Boost
	String rbAtkCrit() {
		return transformer('rb_atk_crit');
	}

	/// HP Recovery
	String rbHpRecovery() {
		return transformer('rb_hp_recovery');
	}

	/// HP All Recovery
	String rbHpAllRecovery() {
		return transformer('rb_hp_all_recovery');
	}

	/// Stamina Increase
	String rbStaminaIncrease() {
		return transformer('rb_stamina_increase');
	}

	/// Stamina Reduction
	String rbStaminaReduction() {
		return transformer('rb_stamina_reduction');
	}

	/// Special
	String rbSpecial() {
		return transformer('rb_special');
	}

	/// Materials
	String materials() {
		return transformer('materials');
	}

	/// Category
	String category() {
		return transformer('category');
	}

	/// Oculi
	String matOculi() {
		return transformer('mat_oculi');
	}

	/// Ascension Gems
	String matAscensionGems() {
		return transformer('mat_ascension_gems');
	}

	/// Normal Boss Drops
	String matNormalBossDrops() {
		return transformer('mat_normal_boss_drops');
	}

	/// Normal Drops
	String matNormalDrops() {
		return transformer('mat_normal_drops');
	}

	/// Elite Drops
	String matEliteDrops() {
		return transformer('mat_elite_drops');
	}

	/// Forging
	String matForging() {
		return transformer('mat_forging');
	}

	/// Furnishing
	String matFurnishing() {
		return transformer('mat_furnishing');
	}

	/// Specialties
	String matLocalSpecialties() {
		return transformer('mat_local_specialties');
	}

	/// Weapons
	String matWeaponMaterials() {
		return transformer('mat_weapon_materials');
	}

	/// Talents
	String matTalentMaterials() {
		return transformer('mat_talent_materials');
	}

	/// Weekly Boss Drops
	String matWeeklyBossDrops() {
		return transformer('mat_weekly_boss_drops');
	}

	/// {n} Piece Bonus
	String nPieceBonus(dynamic n) {
		return transformer('n_piece_bonus', {'n': n});
	}

	/// Attributes
	String attributes() {
		return transformer('attributes');
	}

	/// Birthday
	String birthday() {
		return transformer('birthday');
	}

	/// Constellation
	String constellation() {
		return transformer('constellation');
	}

	/// Title
	String title() {
		return transformer('title');
	}

	/// Affiliation
	String affiliation() {
		return transformer('affiliation');
	}

	/// Special Dish
	String specialDish() {
		return transformer('special_dish');
	}

	/// Release Date
	String releaseDate() {
		return transformer('release_date');
	}

	/// Level
	String level() {
		return transformer('level');
	}

	/// Namecards
	String namecards() {
		return transformer('namecards');
	}

	/// Default
	String namecardDefault() {
		return transformer('namecard_default');
	}

	/// Achievement
	String namecardAchievement() {
		return transformer('namecard_achievement');
	}

	/// Battlepass
	String namecardBattlepass() {
		return transformer('namecard_battlepass');
	}

	/// Character
	String namecardCharacter() {
		return transformer('namecard_character');
	}

	/// Event
	String namecardEvent() {
		return transformer('namecard_event');
	}

	/// Offering
	String namecardOffering() {
		return transformer('namecard_offering');
	}

	/// Reputation
	String namecardReputation() {
		return transformer('namecard_reputation');
	}

	/// Event
	String recipeEvent() {
		return transformer('recipe_event');
	}

	/// Permanent
	String recipePermanent() {
		return transformer('recipe_permanent');
	}

	/// No
	String buttonNo() {
		return transformer('button_no');
	}

	/// Yes
	String buttonYes() {
		return transformer('button_yes');
	}

	/// Update date for all {wishes} wishes?
	String updateAllWishes(dynamic wishes) {
		return transformer('update_all_wishes', {'wishes': wishes});
	}

	/// Other
	String achTypeNone() {
		return transformer('ach_type_none');
	}

	/// Boss
	String achTypeBoss() {
		return transformer('ach_type_boss');
	}

	/// Quest
	String achTypeQuest() {
		return transformer('ach_type_quest');
	}

	/// Commission
	String achTypeCommission() {
		return transformer('ach_type_commission');
	}

	/// Exploration
	String achTypeExploration() {
		return transformer('ach_type_exploration');
	}

	/// Hidden
	String achHidden() {
		return transformer('ach_hidden');
	}

	/// Visible
	String achVisible() {
		return transformer('ach_visible');
	}

	/// Featured
	String featured() {
		return transformer('featured');
	}

	/// Settings
	String settings() {
		return transformer('settings');
	}

	/// Family
	String family() {
		return transformer('family');
	}

	/// Enemies
	String enemies() {
		return transformer('enemies');
	}

	/// Elemental Lifeform
	String efElementalLifeform() {
		return transformer('ef_elemental_lifeform');
	}

	/// Hilichurl
	String efHilichurl() {
		return transformer('ef_hilichurl');
	}

	/// Abyss
	String efAbyss() {
		return transformer('ef_abyss');
	}

	/// Fatui
	String efFatui() {
		return transformer('ef_fatui');
	}

	/// Automaton
	String efAutomaton() {
		return transformer('ef_automaton');
	}

	/// Human Faction
	String efHumanFaction() {
		return transformer('ef_human_faction');
	}

	/// Mystical Beast
	String efMysticalBeast() {
		return transformer('ef_mystical_beast');
	}

	/// Weekly Boss
	String efWeeklyBoss() {
		return transformer('ef_weekly_boss');
	}

	/// Common
	String etCommon() {
		return transformer('et_common');
	}

	/// Elite
	String etElite() {
		return transformer('et_elite');
	}

	/// Normal Boss
	String etNormalBoss() {
		return transformer('et_normal_boss');
	}

	/// Weekly Boss
	String etWeeklyBoss() {
		return transformer('et_weekly_boss');
	}

	/// Search
	String hintSearch() {
		return transformer('hint_search');
	}

	/// (max: {value})
	String maxProficiency(dynamic value) {
		return transformer('max_proficiency', {'value': value});
	}

	/// Player Info
	String cardPlayerInfo() {
		return transformer('card_player_info');
	}

	/// AR {value}
	String cardPlayerAr(dynamic value) {
		return transformer('card_player_ar', {'value': value});
	}

	/// WL {value}
	String cardPlayerWl(dynamic value) {
		return transformer('card_player_wl', {'value': value});
	}

	/// Achievements
	String cardPlayerAchievements() {
		return transformer('card_player_achievements');
	}

	/// Abyss
	String cardPlayerAbyss() {
		return transformer('card_player_abyss');
	}

	/// Theater
	String cardPlayerTheater() {
		return transformer('card_player_theater');
	}

	/// {value}
	String cardPlayerAchievementsValue(dynamic value) {
		return transformer('card_player_achievements_value', {'value': value});
	}

	/// {floor}-{chamber} • {stars}★
	String cardPlayerAbyssValue(dynamic floor, dynamic chamber, dynamic stars) {
		return transformer('card_player_abyss_value', {'floor': floor, 'chamber': chamber, 'stars': stars});
	}

	/// Act {act} • {stars}★
	String cardPlayerTheaterValue(dynamic act, dynamic stars) {
		return transformer('card_player_theater_value', {'act': act, 'stars': stars});
	}

	/// Radiant Spincrystal {number}
	String radiantSpincrystal(dynamic number) {
		return transformer('radiant_spincrystal', {'number': number});
	}

	/// January
	String month1() {
		return transformer('month_1');
	}

	/// February
	String month2() {
		return transformer('month_2');
	}

	/// March
	String month3() {
		return transformer('month_3');
	}

	/// April
	String month4() {
		return transformer('month_4');
	}

	/// May
	String month5() {
		return transformer('month_5');
	}

	/// June
	String month6() {
		return transformer('month_6');
	}

	/// July
	String month7() {
		return transformer('month_7');
	}

	/// August
	String month8() {
		return transformer('month_8');
	}

	/// September
	String month9() {
		return transformer('month_9');
	}

	/// October
	String month10() {
		return transformer('month_10');
	}

	/// November
	String month11() {
		return transformer('month_11');
	}

	/// December
	String month12() {
		return transformer('month_12');
	}

	/// Monday
	String weekday1() {
		return transformer('weekday_1');
	}

	/// Tuesday
	String weekday2() {
		return transformer('weekday_2');
	}

	/// Wednesday
	String weekday3() {
		return transformer('weekday_3');
	}

	/// Thursday
	String weekday4() {
		return transformer('weekday_4');
	}

	/// Friday
	String weekday5() {
		return transformer('weekday_5');
	}

	/// Saturday
	String weekday6() {
		return transformer('weekday_6');
	}

	/// Sunday
	String weekday7() {
		return transformer('weekday_7');
	}

	/// {value}y
	String shortYear(dynamic value) {
		return transformer('short_year', {'value': value});
	}

	/// {value}d
	String shortDay(dynamic value) {
		return transformer('short_day', {'value': value});
	}

	/// {value}w
	String shortWeek(dynamic value) {
		return transformer('short_week', {'value': value});
	}

	/// {value}h
	String shortHour(dynamic value) {
		return transformer('short_hour', {'value': value});
	}

	/// Ends in {value}
	String bannerEnds(dynamic value) {
		return transformer('banner_ends', {'value': value});
	}

	/// Ended {value} ago
	String bannerEnded(dynamic value) {
		return transformer('banner_ended', {'value': value});
	}

	/// Starts in {value}
	String bannerStarts(dynamic value) {
		return transformer('banner_starts', {'value': value});
	}

	/// Started {value} ago
	String bannerStarted(dynamic value) {
		return transformer('banner_started', {'value': value});
	}

	/// {n} Pulls
	String bannerNRolls(dynamic n) {
		return transformer('banner_n_rolls', {'n': n});
	}

	/// {n} Primogems
	String bannerNPrimogems(dynamic n) {
		return transformer('banner_n_primogems', {'n': n});
	}

	/// New
	String itemNew() {
		return transformer('item_new');
	}

	/// Upcoming
	String itemUpcoming() {
		return transformer('item_upcoming');
	}

	/// Date
	String dateDialogDate() {
		return transformer('date_dialog_date');
	}

	/// Hour
	String dateDialogHour() {
		return transformer('date_dialog_hour');
	}

	/// Normal Attack
	String charTalNa() {
		return transformer('char_tal_na');
	}

	/// Elemental Skill
	String charTalEs() {
		return transformer('char_tal_es');
	}

	/// Elemental Burst
	String charTalEb() {
		return transformer('char_tal_eb');
	}

	/// Alternate Sprint
	String charTalAs() {
		return transformer('char_tal_as');
	}

	/// 1st Ascension Passive
	String charTal1a() {
		return transformer('char_tal_1a');
	}

	/// 4th Ascension Passive
	String charTal4a() {
		return transformer('char_tal_4a');
	}

	/// Night Realm's Gift Passive
	String charTalNr() {
		return transformer('char_tal_nr');
	}

	/// Utility Passive
	String charTalUp() {
		return transformer('char_tal_up');
	}

	/// Duration
	String duration() {
		return transformer('duration');
	}

	/// Quest
	String eventQuest() {
		return transformer('event_quest');
	}

	/// Login
	String eventLogin() {
		return transformer('event_login');
	}

	/// Event
	String eventNormal() {
		return transformer('event_normal');
	}

	/// Flagship
	String eventFlagship() {
		return transformer('event_flagship');
	}

	/// Permanent
	String eventPermanent() {
		return transformer('event_permanent');
	}

	/// Ousia & Pneuma
	String arkheBoth() {
		return transformer('arkhe_both');
	}

	/// Ousia
	String arkheOusia() {
		return transformer('arkhe_ousia');
	}

	/// Pneuma
	String arkhePneuma() {
		return transformer('arkhe_pneuma');
	}
}
