#define ORE_MIN_PURITY 0.1
#define ORE_MAX_PURITY 0.8
#define ORE_MEAN 0.5
#define ORE_STD 0.2

#define ORE_MIN 10000
#define ORE_MAX_AMOUNT 100000

/obj/item/ore_rock
	name = "Ore bearing rock"
	desc = "A rock"
	icon = 'icons/obj/mining.dmi'
	icon_state = "ore"
	inhand_icon_state = "ore"

	var/mat_purity // 0 to 1, affects how much material you can recover
	var/mat_amount // Amount of material
	var/datum/material/ore_material

/turf/open/floor/plating/asteroid/basalt/lava_land_surface/ore
	name = "Ore bearing basalt"
	var/mat_amount
	var/mat_purity
	var/const/list/datum/material/possible_materials = list(
		/datum/material/iron = 100, /datum/material/gold = 50,
		/datum/material/silver = 50, /datum/material/titanium = 25,
		/datum/material/plasma = 25, /datum/material/diamond = 4,
		/datum/material/bluespace = 2
	)
	var/datum/material/ore_material

/turf/open/floor/plating/asteroid/basalt/lava_land_surface/ore/Initialize()
	. = ..()
	if (!ore_material)
		ore_material = pickweight(possible_materials)
	if (!mat_purity)
		mat_purity = clamp(gaussian(ORE_MEAN, ORE_STD), ORE_MIN_PURITY, ORE_MAX_PURITY)
	if (!mat_amount)
		mat_amount = rand(ORE_MIN_AMOUNT, ORE_MAX_AMOUNT)

/turf/open/floor/plating/asteroid/basalt/lava_land_surface/ore/examine(mob/user)
	. = ..()
	if (ore_material)
		. += "It seems to contain [ore_material.name]"

/turf/open/floor/plating/asteroid/basalt/lava_land_surface/ore/update_overlays()
	. = ..()

#undef ORE_MIN_PURITY
#undef ORE_MAX_PURITY
#undef ORE_MEAN
#undef ORE_STD
#undef ORE_MIN_AMOUNT
#undef ORE_MAX_AMOUNT
