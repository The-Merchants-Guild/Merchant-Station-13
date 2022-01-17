/////////////////////////
//  ORE VEIN ANALYSER  //
/////////////////////////

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

/////////////////////////
// COLD WELD DISPOSAL  //
/////////////////////////
/obj/item/disposal_dispenser
	name = "Rapid Disposal Dispenser"
	desc = "A device used for quickly deploying disposals in low pressure environments."
	icon_state = "rdd"
	icon = 'icons/obj/drilling.dmi'
	usesound = 'sound/machines/click.ogg'
	var/set_direction = SOUTH

/obj/item/disposal_dispenser/equipped(mob/user, slot, initial)
	. = ..()
	if(slot == ITEM_SLOT_HANDS)
		RegisterSignal(user, COMSIG_MOUSE_SCROLL_ON, .proc/mouse_wheeled)
	else
		UnregisterSignal(user,COMSIG_MOUSE_SCROLL_ON)

/obj/item/disposal_dispenser/dropped(mob/user, silent)
	UnregisterSignal(user, COMSIG_MOUSE_SCROLL_ON)
	return ..()

/obj/item/disposal_dispenser/attack_self(mob/user, modifiers)
	. = ..()
	var/list/choices = list(
		"North" = image(icon = 'icons/obj/atmospherics/pipes/disposal.dmi', icon_state = "conpipe", dir = NORTH),
		"North east" = image(icon = 'icons/obj/atmospherics/pipes/disposal.dmi', icon_state = "conpipe", dir = NORTHEAST),
		"East" = image(icon = 'icons/obj/atmospherics/pipes/disposal.dmi', icon_state = "conpipe", dir = EAST),
		"South east" = image(icon = 'icons/obj/atmospherics/pipes/disposal.dmi', icon_state = "conpipe", dir = SOUTHEAST),
		"South" = image(icon = 'icons/obj/atmospherics/pipes/disposal.dmi', icon_state = "conpipe", dir = SOUTH),
		"South west" = image(icon = 'icons/obj/atmospherics/pipes/disposal.dmi', icon_state = "conpipe", dir = SOUTHWEST),
		"West" = image(icon = 'icons/obj/atmospherics/pipes/disposal.dmi', icon_state = "conpipe", dir = WEST),
		"North west" = image(icon = 'icons/obj/atmospherics/pipes/disposal.dmi', icon_state = "conpipe", dir = NORTHWEST)
	)

	var/choice = show_radial_menu(user, src, choices, custom_check = CALLBACK(src, .proc/check_menu, user), require_near = TRUE, tooltips = TRUE)
	if(!check_menu(user))
		return

	switch (choice)
		if ("North")
			set_direction = NORTH
		if ("North east")
			set_direction = NORTHEAST
		if ("East")
			set_direction = EAST
		if ("South east")
			set_direction = SOUTHEAST
		if ("South")
			set_direction = SOUTH
		if ("South west")
			set_direction = SOUTHWEST
		if ("West")
			set_direction = WEST
		if ("North west")
			set_direction = WEST

/obj/item/disposal_dispenser/pre_attack(atom/A, mob/user, params)
	. = ..()
	if (!do_after(user, 0.5 SECONDS, target = A))
		return FALSE
	if (istype(A, /obj/structure/disposalconstruct))
		var/obj/structure/disposalconstruct/DC = A
		if (DC.anchored)
			to_chat(user, span_warning("You can only remove the [A] if it is unanchored."))
			return FALSE
		playsound(src.loc, 'sound/machines/click.ogg', 50, TRUE)
		qdel(A)
		return FALSE
	playsound(src.loc, 'sound/machines/click.ogg', 50, TRUE)
	var/turf/T = get_turf(A)
	var/obj/structure/disposalconstruct/C = new(T, null, set_direction)
	if (!do_after(user, 0.5 SECONDS, target = C))
		return FALSE
	if (!C.wrench_act(user, src) || !lavaland_equipment_pressure_check(T))
		return FALSE
	playsound(src.loc, 'sound/machines/click.ogg', 50, TRUE)
	new /obj/structure/disposalpipe/segment(T, C)
	return FALSE

/obj/item/disposal_dispenser/proc/check_menu(mob/living/user, remote_anchor)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	if(remote_anchor && user.remote_control != remote_anchor)
		return FALSE
	return TRUE

/obj/item/disposal_dispenser/proc/mouse_wheeled(mob/source, atom/A, delta_x, delta_y, params)
	SIGNAL_HANDLER
	if(source.incapacitated(ignore_restraints = TRUE, ignore_stasis = TRUE))
		return

	if(delta_y < 0)
		set_direction = angle2dir(dir2angle(set_direction) - 45)
	else if(delta_y > 0)
		set_direction = angle2dir(dir2angle(set_direction) + 45)
	else
		return
	to_chat(source, span_notice("You set the direction to [dir2text(set_direction)]."))

/////////////////////////
// MASSIVE GUIDE BOOK  //
/////////////////////////
/obj/item/book/manual/vein_drilling
	name = "Drilling and how to not cry in a corner."
	icon_state ="book"
	author = ""
	title = "Drilling and how to not cry in a corner."
	dat = {"<html>
				<head>
					<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
				</head>
				<body>
					<h3>Drilling</h3>
					<h3>How to not cry in a corner</h3>
					<i>the pages have been torn off...</i>
				</body>
				</html>
			"}
