#define ORE_MIN_AMOUNT 500000  // 500 plates
#define ORE_MAX_AMOUNT 4000000 // 4000 plates

/obj/item/raw_ore
	name = "raw ore"
	desc = "It looks like a rock."
	icon = 'icons/obj/drilling.dmi'
	icon_state = "rock"
	inhand_icon_state = "ore"

	var/mat_amount // Amount of material
	var/process_phase = 0 // Current phase of ore processing
	var/datum/material/ore_material

/obj/item/raw_ore/Initialize(mapload, mat, mat_amnt)
	if (!mat)
		return INITIALIZE_HINT_QDEL
	ore_material = mat
	mat_amount = mat_amnt
	var/mutable_appearance/MA = mutable_appearance('icons/obj/drilling.dmi', "rock_vein")
	MA.color = initial(ore_material.greyscale_colors)
	overlays += MA
	. = ..()

/turf/open/floor/plating/asteroid/basalt/lava_land_surface/ore
	name = "cracked volcanic floor"
	var/mat_amount
	var/list/datum/material/possible_materials = list(
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
		var/mutable_appearance/MA = mutable_appearance('icons/obj/drilling.dmi', "crack", TURF_DECAL_LAYER)
		MA.color = initial(ore_material.greyscale_colors)
		overlays += MA
	if (!mat_amount)
		mat_amount = rand(ORE_MIN_AMOUNT, ORE_MAX_AMOUNT)

/turf/open/floor/plating/asteroid/basalt/lava_land_surface/ore/examine(mob/user)
	. = ..()
	if (ore_material)
		. += "It seems to have a vein of [initial(ore_material.name)]."

/turf/open/floor/plating/asteroid/basalt/lava_land_surface/ore/update_overlays()
	. = ..()

/obj/item/vein_analyser
	name = "ore vein analyser"
	desc = "A tool used for analysing underground ore veins."
	icon_state = "vein_scanner"
	icon = 'icons/obj/drilling.dmi'

/obj/item/vein_analyser/pre_attack(atom/A, mob/user)
	. = ..()
	A = get_turf(A)
	if (!istype(A, /turf/open/floor/plating/asteroid/basalt/lava_land_surface/ore))
		return
	var/turf/open/floor/plating/asteroid/basalt/lava_land_surface/ore/O = A
	playsound(src, 'sound/machines/ping.ogg', 50, FALSE)
	to_chat(user, "<span class='notice'>BEEP! detected [round(O.mat_amount, 100)] of [initial(O.ore_material.name)].</span>")

#undef ORE_MIN_AMOUNT
#undef ORE_MAX_AMOUNT
