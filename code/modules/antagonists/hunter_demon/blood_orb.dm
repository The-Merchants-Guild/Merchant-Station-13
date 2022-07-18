/obj/structure/bloody_orb
	name = "bloody orb"
	desc = "A sinister looking red orb."
	icon = 'icons/obj/blood_orb.dmi'
	icon_state = "bloody_orb"
	anchored = TRUE
	density = TRUE
	max_integrity = 200
	var/mob/living/simple_animal/hostile/hunter/demon 
	var/mob/living/carbon/human/target
	var/mob/living/carbon/human/master
	var/blood_pool_summary = 0
	var/sacrificed_blood = 0

/obj/structure/bloody_orb/attackby(obj/item/I, mob/user, params)
	var/mob/living/carbon/human/H = user
	if(!H)
		return
	if(istype(I, /obj/item/kitchen/knife) && H.combat_mode != TRUE)
		if(!demon)
			if(!(NOBLOOD in H.dna.species.species_traits))
				visible_message(span_danger("[H] begins to spill his blood on the [src]!"), \
					span_userdanger("You begin to spill your blood on the [src], trying to summon a demon!"))
			else 
				visible_message(span_danger("[H] begins to stab himself with [I]!"), \
					span_userdanger("You begin to mutilate yourself, trying to lure in demons with your pain!"))
			if(do_after(H, 50, target = src))
				if(!(NOBLOOD in H.dna.species.species_traits))
					to_chat(H, "<span class='warning'>You finish spilling your blood on the [src].</span>")
					H.blood_volume -= ORB_BLOOD_SACAMOUNT / 2   
				else
					to_chat(H, "<span class='warning'>You finish your ritual of pain.</span>")
					H.adjustBruteLoss(20)
				var/list/candidates = pollCandidatesForMob("Do you want to play as a hunter demon?", ROLE_ALIEN, null, ROLE_ALIEN, 150, src)
				if(!candidates.len)
					to_chat(H, "<span class='warning'>No demons have heard your call! Perhaps try again later...</span>")
					return
				var/mob/dead/selected = pick(candidates)
				var/datum/mind/player_mind = new /datum/mind(selected.key)
				var/mob/living/simple_animal/hostile/hunter/hd = new(get_turf(src))
				player_mind.transfer_to(hd)
				player_mind.assigned_role = "Hunter Demon"
				player_mind.special_role = "Hunter Demon"
				playsound(hd, 'sound/magic/ethereal_exit.ogg', 50, 1, -1)
				message_admins("[ADMIN_LOOKUPFLW(hd)] has been summoned as a Hunter Demon by [H].")
				log_game("[key_name(hd)] has been summoned as a Hunter Demon by [H].")
				demon = hd
				master = H
				sacrificed_blood += ORB_BLOOD_SACAMOUNT
				blood_pool_summary += ORB_BLOOD_SACAMOUNT
				demon.orb = src
				handle_bloodchange()
				return
		else
			if(!(NOBLOOD in H.dna.species.species_traits))
				visible_message(span_danger("[H] begins to spill his blood on the [src]!"), \
					span_userdanger("You begin to spill your blood on the [src], performing a binding rite!"))
			else 
				visible_message(span_danger("[H] begins to stab himself with [I]!"), \
					span_userdanger("You begin to mutilate yourself, performing a binding rite!"))
			if(do_after(H, 30, target = src))
				if(!(NOBLOOD in H.dna.species.species_traits))
					to_chat(H, "<span class='warning'>You finish spilling your blood on the [src].</span>")
					H.blood_volume -= ORB_BLOOD_SACAMOUNT / 2                                              ///dying from bloodloss is not cool
				else
					to_chat(H, "<span class='warning'>You finish your ritual of pain.</span>")
					H.adjustBruteLoss(20)
				sacrificed_blood += ORB_BLOOD_SACAMOUNT
				blood_pool_summary += ORB_BLOOD_SACAMOUNT
				handle_bloodchange()
				if(target == H)
					to_chat(H, "<span class='warning'>You feel your blood boiling!</span>")
					to_chat(demon, "<span class='warning'>Your target has tried to perform a binding rite near your orb!</span>")
					H.Paralyze(60)
					return
				if(master != H)
					master = H
					to_chat(demon, "<span class='warning'>[H] is now your new master!</span>")
				return
	. = ..()
	if(demon)
		to_chat(demon,span_warning("Your orb has been attacked!"))


/obj/structure/bloody_orb/attack_hand(mob/living/carbon/human/M)
	if(!demon)
		return
	if(M == master && (target.stat == DEAD || !target))
		if(pick_target(M))
			message_admins("[key_name(M)] has chosen [target] as a target for a hunter demon.")
			log_game("[key_name(M)] has chosen [target] as a target for a hunter demon.")       

/obj/structure/bloody_orb/proc/pick_target(mob/dude)   ///is_station_level(z)
	var/list/possible_targets = list()
	for(var/mob/living/carbon/human/H in GLOB.alive_mob_list)
		if(!H.mind)
			continue				
		if(!SSjob.GetJob(H.mind.assigned_role) || H == master || H == dude)
			continue 
		var/turf/turfy = get_turf(H)
		if(!is_station_level(turfy.z))
			continue
		possible_targets[H.mind.current.real_name] = H
	target = possible_targets[input(dude,"Choose next target for the demon","Target") in possible_targets]
	if(target)
		demon.prey = target
		to_chat(dude,span_warning("New target for the demon is selected!"))
		to_chat(demon,span_warning("Your new target has been selected, hunt and kill [target.real_name]!"))
		return TRUE
	else
		to_chat(dude,span_warning("A target could not be found for the demon."))
		return FALSE


/obj/structure/bloody_orb/examine(mob/user)
	. = ..()
	if(!demon)
		. += "<span class='notice'>This orb looks empty.</span>"
	else
		. += "<span class='notice'>This orb looks like it contains pure madness inside.</span>"
	if(user == master)
		. += "<span class='notice'>There is [sacrificed_blood]/[BLOODORB_MAXBLOOD] blood supporting the binding rite.</span>"
	if(user == master || user == demon)
		. += "<span class='notice'>You see in it a blurry image of [target].</span>"

/obj/structure/bloody_orb/Destroy()
	. = ..()
	if(!demon)
		return
	to_chat(demon,span_warning("With your orb destroyed, your bond with this mortal plane is broken, and your body dissolves into dust!"))
	if(demon.phased )
		demon.instaphasein()
	demon.dust()

/obj/structure/bloody_orb/proc/handle_bloodchange()
	if(sacrificed_blood > BLOODORB_MAXBLOOD)
		sacrificed_blood = BLOODORB_MAXBLOOD
	if(blood_pool_summary > BLOODORB_MAXBLOOD)
		blood_pool_summary = BLOODORB_MAXBLOOD
	if(sacrificed_blood <= 0)
		if(master)
			master = FALSE
			to_chat(demon,span_warning("There is no blood to sustain the binding rite, you are now free!"))
		if(sacrificed_blood < 0)
			sacrificed_blood = 0
	if(blood_pool_summary < 0)
		blood_pool_summary = 0

/obj/item/sinister_orb
	name = "sinister orb"
	icon = 'icons/obj/blood_orb.dmi'
	icon_state = "sinister"
	desc = "A sinisterly looking red ball."

/obj/item/sinister_orb/attack_self(mob/living/user)
	var/turf/turfo = get_turf(user)
	if(!is_station_level(turfo.z))
		to_chat(user,span_warning("You can only summon the orb on the station z-level!"))
		return
	var/datum/gas_mixture/env = turfo.return_air()
	if(!env)
		to_chat(user,span_warning("You can only summon the orb in a room that has air!"))
		return
	to_chat(user,span_warning("You begin activating the orb!"))
	if(do_after(user, 30, target = turfo))
		to_chat(user,span_warning("You activate the orb!"))
		new /obj/structure/bloody_orb(turfo)
		qdel(src)
