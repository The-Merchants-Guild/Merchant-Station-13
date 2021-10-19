#define ORE_PER_YIELD_PERCENT 20000

/datum/ore_vein
	var/yield
	var/datum/material/material

/datum/ore_vein/proc/lower_yield(amount_mined)
	if (yield <= 0.1) // Yield doesn't go lower than 10%
		return
	yield -= amount_mined / ORE_PER_YIELD_PERCENT

/obj/item/vein_analyser
	name = "ore vein analyser"
	desc = "A tool used for analysing underground ore veins."
	icon_state = "vein_scanner"
	icon = 'icons/obj/drilling.dmi'

/obj/item/vein_analyser/attack_self(mob/user, modifiers)
	. = ..()
	if (!SSmining.vein_grids["[loc.z]"])
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
		to_chat(user, span_warning("ERR! No possibility of ores at this location."))
		return
	var/datum/ore_vein/vein = SSmining.vein_grids["[loc.z]"][round(loc.x * SSmining.gwm_x) + 1][round(loc.y * SSmining.gwm_y) + 1]
	if (!vein)
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
		to_chat(user, span_warning("ERR! No ore veins detected."))
		return
	playsound(src, 'sound/machines/ping.ogg', 50, FALSE)
	to_chat(user, "<span class='notice'>BEEP! detected a vein of [initial(vein.material.name)] with yield of [round(vein.yield * 100, 1)]%.</span>")
