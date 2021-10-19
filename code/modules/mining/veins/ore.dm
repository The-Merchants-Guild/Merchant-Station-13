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
	update_appearance()
	. = ..()

/obj/item/raw_ore/update_overlays()
	. = ..()
	if (process_phase != 0)
		return
	var/mutable_appearance/MA = mutable_appearance('icons/obj/drilling.dmi', "rock_vein")
	MA.color = initial(ore_material.greyscale_colors)
	. += MA

/obj/item/raw_ore/examine(mob/user)
	. = ..()
	. += "It seems to contain [initial(ore_material.name)]."
