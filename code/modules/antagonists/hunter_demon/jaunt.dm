/mob/living/simple_animal/hostile/hunter/phaseout()
	src.notransform = TRUE
	spawn(0)
		bloodpool_sink()
		src.notransform = FALSE
	phased = TRUE
	return 1

/mob/living/simple_animal/hostile/hunter/bloodpool_sink()
	var/turf/mobloc = get_turf(src.loc)
	src.visible_message(span_warning("[src] warps out of the reality!"))
	playsound(get_turf(src), 'sound/magic/enter_blood.ogg', 50, 1, -1)
	var/obj/effect/dummy/phased_mob/holder = new /obj/effect/dummy/phased_mob(mobloc)
	extinguish_mob()
	holder = holder
	forceMove(holder)
	return 1

/mob/living/simple_animal/hostile/hunter/exit_blood_effect()
	playsound(get_turf(src), 'sound/magic/exit_blood.ogg', 50, 1, -1)

/mob/living/simple_animal/hostile/hunter/phasein()
	if(src.notransform)
		return 0
	var/turf/turfo
	var/atom/location = null
	if(!isturf(loc))
		location = loc
		turfo = get_turf(loc)
	else
		turfo = get_turf(src)
	visible_message(span_warning("Reality begins to twist around you!"))
	if(!do_after(src, 3 SECONDS, target = turfo))
		return
	forceMove(turfo)
	client.eye = src
	if(location && istype(location, obj/effect/dummy/phased_mob))
		qdel(location)
	visible_message(span_warning("<B>[src] warps into reality!</B>"))
	exit_blood_effect()
	phased = FALSE
	return 1

/mob/living/simple_animal/hostile/hunter/proc/instaphasein()
	var/turf/turfo
	var/atom/location = null
	if(!isturf(loc))
		location = loc
		turfo = get_turf(loc)
	else
		turfo = get_turf(src)
	forceMove(turfo)
	client.eye = src
	if(location && istype(location, obj/effect/dummy/phased_mob))
		qdel(location)
	visible_message(span_warning("<B>[src] warps into reality!</B>"))
	exit_blood_effect()
	phased = FALSE
	return 1
