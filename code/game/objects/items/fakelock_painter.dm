/obj/item/airlock_painter/fakelock_painter
	name = "fakelock painter"
	desc = "An advanced autopainter preprogrammed with several paintjobs for airlocks. It's been hacked to work convincingly on walls and windows instead of airlocks."
	icon = 'icons/obj/objects.dmi'
	icon_state = "paint sprayer"
	inhand_icon_state = "paint sprayer"
	worn_icon_state = "painter"
	w_class = WEIGHT_CLASS_SMALL

	custom_materials = list(/datum/material/iron=50, /datum/material/glass=50)

	flags_1 = CONDUCT_1
	item_flags = NOBLUDGEON
	slot_flags = ITEM_SLOT_BELT
	usesound = 'sound/effects/spray2.ogg'

	var/stun_time = 50

/obj/item/airlock_painter/fakelock_painter/afterattack(atom/target, mob/user, proximity)
	. = ..()
	var/turf/closed/wall/F = target
	if(!proximity)
		to_chat(user, span_notice("You need to get closer!"))
		return
	if(use_paint(user) && isturf(F))
		// reads from the airlock painter's `available paintjob` list. lets the player choose a paint option, or cancel painting
		var/current_paintjob = input(user, "Please select a paintjob for this wall.") as null|anything in sortList(available_paint_jobs)
		if(!current_paintjob) // if the user clicked cancel on the popup, return
			return

		var/airlock_type = available_paint_jobs["[current_paintjob]"] // get the airlock type path associated with the airlock name the user just chose
		var/obj/machinery/door/airlock/airlock = airlock_type // we need to create a new instance of the airlock and assembly to read vars from them
		var/obj/structure/door_assembly/assembly = initial(airlock.assemblytype)

		// applies the user-chosen airlock's icon, overlays and assemblytype to the src airlock
		use_paint(user)
		target.icon = initial(airlock.icon)
		target.icon_state = "closed"
		//target.overlays_file = initial(airlock.overlays_file)
		//target.assemblytype = initial(airlock.assemblytype)
		target.update_appearance()
		// register COMSIG_ATOM_BUMPED signal 
		RegisterSignal(target, COMSIG_ATOM_BUMPED, .proc/procstun)

// I hate this too
/obj/item/airlock_painter/fakelock_painter/proc/procstun(datum/source, atom/movable/AM)
	if(!ishuman(AM))
		return
	var/mob/living/carbon/human/L = AM
	L.Knockdown(stun_time)
