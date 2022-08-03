/obj/effect/proc_holder/spell/hunterjaunt
	name = "Warp"
	desc = "You can phase out of reality, and phase back near your target or your blood orb."
	charge_max = 0
	clothes_req = FALSE
	//If you couldn't cast this while phased, you'd have a problem
	phase_allowed = TRUE
	selection_type = "range"
	range = 1
	cooldown_min = 0
	overlay = null
	action_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	action_icon_state = "bloodcrawl"
	action_background_icon_state = "bg_demon"
	var/phased = FALSE

/obj/effect/proc_holder/spell/hunterjaunt/choose_targets(mob/user = usr)
	perform(1, user)

/obj/effect/proc_holder/spell/hunterjaunt/perform(recharge = 1, mob/living/user = usr)
	if(istype(user, /mob/living/simple_animal/hostile/hunter))
		var/mob/living/simple_animal/hostile/hunter/hunterd = user
		hunterd.attack_streak = 0
		if(phased)	
			if(!hunterd.check_shit(MAX_WARP_DISTANCE, ORB_AND_PREY))
				to_chat(user, span_warning("You can only warp in while near your target or your blood orb!"))
				revert_cast()
				return
			if(hunterd.phasein())
				phased = FALSE
		else
			var/phaseouttime = 30
			if(hunterd.check_shit(BOUND_DISTANCE, ONLY_PREY)) ///Warping out while near your target takes longer
				phaseouttime = 50 
			if(do_after(hunterd, phaseouttime))	
				if(hunterd.phaseout())
					phased = TRUE
		start_recharge()
		return
	to_chat(user, span_warning("You are not a hunter demon, you can't do this!"))
	revert_cast()

/obj/effect/proc_holder/spell/hd_seek_prey
	name = "Seek prey"
	desc = "Identifies where your target is, or marks the assignment as complete if the target is: dead, no longer a person, or are off the station z-level."
	invocation_type = "none"
	clothes_req = FALSE
	school = "evocation"
	charge_max = 100
	cooldown_min = 10
	action_icon = 'icons/mob/actions/hunter_demon_actions.dmi'
	action_icon_state = "seek_prey"
	phase_allowed = TRUE

/obj/effect/proc_holder/spell/hd_seek_prey/choose_targets(mob/user = usr)
	perform(1, user)

/obj/effect/proc_holder/spell/hd_seek_prey/perform(recharge = 1, mob/living/user = usr)
	if(istype(user,/mob/living/simple_animal/hostile/hunter))
		var/mob/living/simple_animal/hostile/hunter/demon = user
		if(!demon.prey)
			to_chat(user,span_warning("You don't have a target! One should be chosen by your master, or you can choose it yourself if you are not bound by a binding rite."))
			start_recharge()
			return
		if(!istype(demon.prey, /mob/living/carbon/human))
			to_chat(user,span_warning("Your target is no longer a person, so you've lost interest in hunting them. Get a new target."))
			demon.complete_assasination(killed = FALSE)
			start_recharge()
			return
		if(demon.prey.stat == DEAD)
			to_chat(user,span_warning("Your target is dead, so your mission is completed. Get a new target."))
			demon.complete_assasination(killed = TRUE)
			start_recharge()
			return	
		var/turf/userturf = get_turf(demon)
		var/turf/targetturf = get_turf(demon.prey)
		var/dist = get_dist(userturf,targetturf)
		var/dir = get_dir(userturf,targetturf)
		if(!is_station_level(targetturf.z))
			to_chat(user,span_warning("Your target has left the station z-level, so the hunt is over. Get a new target."))
			demon.complete_assasination(killed = FALSE)
			start_recharge()
			return
		if(userturf.z != targetturf.z)
			to_chat(user,span_warning("[demon.prey.real_name] is... vertical to you?"))
			start_recharge()
			return
		switch(dist)         ///Taken from living heart code
			if(0 to 15)
				to_chat(user,span_warning("[demon.prey.real_name] is near you. They are to the [dir2text(dir)] of you!"))
			if(16 to 31)
				to_chat(user,span_warning("[demon.prey.real_name] is somewhere in your vicinty. They are to the [dir2text(dir)] of you!"))
			if(32 to 127)
				to_chat(user,span_warning("[demon.prey.real_name] is far away from you. They are to the [dir2text(dir)] of you!"))
			else
				to_chat(user,span_warning("[demon.prey.real_name] is beyond your reach."))
	start_recharge()		
	return

/obj/effect/proc_holder/spell/recall
	name = "Recall"
	desc = "Returns you to your orb position if you are jaunting."
	invocation_type = "none"
	clothes_req = FALSE
	school = "evocation"
	charge_max = 100
	cooldown_min = 30
	action_icon = 'icons/mob/actions/hunter_demon_actions.dmi'
	action_icon_state = "recall"
	phase_allowed = TRUE

/obj/effect/proc_holder/spell/recall/choose_targets(mob/user = usr)
	perform(1, user)

/obj/effect/proc_holder/spell/recall/perform(recharge = 1, mob/living/user = usr)
	if(istype(user, /mob/living/simple_animal/hostile/hunter))
		var/mob/living/simple_animal/hostile/hunter/demon = user
		if(!demon.phased)
			to_chat(user,span_warning("You can only use this ability while phased!"))
			revert_cast()
			return
		if(demon.orb)
			demon.forceMove(get_turf(demon.orb))
			start_recharge()
	revert_cast()
	return
