/obj/item/airlock_painter/fakelock_painter
	name = "fakelock painter"
	desc = "An advanced autopainter preprogrammed with several paintjobs for airlocks. It has a holographic field applicator, allowing it to work on walls and windows."
	icon = 'icons/obj/objects.dmi'
	icon_state = "fake paint sprayer"
	inhand_icon_state = "fake paint sprayer"
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
	//var/atom/tgt = target
	//var/turf/closed/wall/F = target
	if(!proximity)
		to_chat(user, span_notice("You need to get closer!"))
		return
	if(use_paint(user) && (istype(target, /turf/closed/wall) || istype(target, /obj/structure/window/)))
		// reads from the airlock painter's `available paintjob` list. lets the player choose a paint option, or cancel painting
		var/current_paintjob = input(user, "Please select a paintjob for this wall.") as null|anything in sortList(available_paint_jobs)
		if(!current_paintjob) // if the user clicked cancel on the popup, return
			return

		var/airlock_type = available_paint_jobs["[current_paintjob]"] // get the airlock type path associated with the airlock name the user just chose
		var/obj/machinery/door/airlock/airlock = airlock_type // we need to create a new instance of the airlock and assembly to read vars from them
		//var/obj/structure/door_assembly/assembly = initial(airlock.assemblytype)

		// applies the user-chosen airlock's icon, overlays and assemblytype to the src airlock
		use_paint(user)
		target.icon = initial(airlock.icon)
		target.icon_state = "closed"
		target.name = "airlock"
		target.desc = "Hold on... this isn't a real airlock, it's just painted on!"

		if(istype(target, /turf/closed/wall))
			target.add_overlay(list("fill_closed"))
		else
			target.add_overlay(list("closed"))
			if(current_paintjob == "Public")
				//target.overlays_file = 'icons/obj/doors/airlocks/station2/overlays.dmi'
				target.add_overlay(list(get_airlock_overlay("glass_closed", 'icons/obj/doors/airlocks/station2/overlays.dmi', em_block = TRUE)))
		//RegisterSignal(target, COMSIG_ATOM_UPDATE_OVERLAYS, .proc/procoverlays)
		//target.overlays_file = initial(airlock.overlays_file)
		//target.assemblytype = initial(airlock.assemblytype)
		target.update_appearance()
		target.icon_state = "closed"
		// JUST FUCKIGN DISPLAY IT REEEEEEEEEEE I'M S OFUCKING DONE
		target.base_icon_state = "closed"
		// register COMSIG_ATOM_BUMPED signal 
		RegisterSignal(target, COMSIG_ATOM_BUMPED, .proc/procstun)

// I hate this too
/obj/item/airlock_painter/fakelock_painter/proc/procstun(datum/source, atom/movable/AM)
	if(!ishuman(AM))
		return
	var/mob/living/carbon/human/L = AM
	L.Knockdown(stun_time)
	L.Stun(stun_time)
	playsound(src, pick('sound/vehicles/clowncar_crash1.ogg', 'sound/vehicles/clowncar_crash2.ogg'), 75)
	to_chat(L, span_warning("You crash head first into the [source]. It's a faaaaaaaake!"))
	visible_message(span_notice("[L] crashes into [source]. It was a fake!"))

/*
/obj/item/airlock_painter/fakelock_painter/proc/procoverlays(datum/source, list/L)
	var/atom/F = source
	L += mutable_appearance(F.icon, "fill_closed", plane = EMISSIVE_PLANE)*/
