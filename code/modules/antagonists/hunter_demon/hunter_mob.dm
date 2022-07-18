/mob/living/simple_animal/hostile/hunter
	name = "hunter demon"
	real_name = "hunter demon"
	desc = "A large, armored creature emmitting unholy energies."
	speak_emote = list("declares")
	emote_hear = list("wails","screeches")
	response_help_continuous = "thinks better of touching"
	response_help_simple = "think better of touching"
	response_disarm_continuous = "flails at"
	response_disarm_simple = "flail at"
	response_harm_continuous = "punches"
	response_harm_simple = "punch"
	icon = 'icons/mob/mob.dmi'
	icon_state = "horror"
	icon_living = "horror"
	mob_biotypes = list(MOB_ORGANIC, MOB_HUMANOID)
	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)
	speed = -0.15
	combat_mode = TRUE
	stop_automated_movement = 1
	status_flags = CANPUSH
	attack_sound = 'sound/magic/demon_attack1.ogg'
	deathsound = 'sound/magic/demon_dies.ogg'
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = INFINITY
	faction = list("slaughter")
	attack_verb_continuous = "rips apart"
	attack_verb_simple = "rip apart"
	maxHealth = 150
	health = 150
	healable = 0
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	obj_damage = 40
	melee_damage_lower = 25
	melee_damage_upper = 25
	see_in_dark = 4
	var/playstyle_string = "<span class='big bold'>You are a hunter demon,</span><B> a terrible creature from another realm.  \
							You may use the \"Jaunt\" ability to disappear from reality and move to almost any place! \
							You can return to the mortal plane only when near the orb that you were summoned from, or near your hunter target. \
							Your target is chosen through your orb by your master, if a current binding ritual is in place. Otherwise, you can use the orb to pick a target for yourself! \
			 	 			Your orb has two blood counters: one that stands for blood, obtained through the blood ritual that your master uses to bind you and sustain you,\
			  				and a summary blood counter, which is obtained by you attacking humans AND by the blood ritual. This pool is used to heal you.\
			  				While not near the orb or your target you are slower, and will lose health. If you successfully kill 8 targets, you will ascend, unbinding you from the orb forever!</B>"
	del_on_death = 1
	deathmessage = "collapses, as its bond with the mortal plain dissipates!"
	var/obj/structure/bloody_orb/orb
	var/mob/living/carbon/human/prey
	var/mob/living/last_target
	var/attack_streak
	var/cool_demon_name
	var/phased = FALSE

/mob/living/simple_animal/hostile/hunter/Initialize()
	. = ..()
	name = "[pick(GLOB.hunter_demon_first_names)], The [pick(GLOB.hunter_demon_last_names)]"
	var/obj/effect/proc_holder/spell/hunterjaunt/jaunt = new
	AddSpell(jaunt)
	var/obj/effect/proc_holder/spell/hd_seek_prey/seekprey = new
	AddSpell(seekprey)
	var/obj/effect/proc_holder/spell/recall/rec = new
	AddSpell(rec)

/mob/living/simple_animal/hostile/hunter/Life()
	. = ..()
	orb.sacrificed_blood -= BLOODORB_PAS_BLOODUSE
	orb.blood_pool_summary -= BLOODORB_PAS_BLOODUSE
	if(health < maxHealth)
		heal_bodypart_damage(2)
		orb.sacrificed_blood -= DREGEN_BOOST_COST 
		if(phased)
			heal_bodypart_damage(3)
			if(orb.blood_pool_summary)
				heal_bodypart_damage(8)
				orb.blood_pool_summary -= DREGEN_BOOST_COST*2
	orb.handle_bloodchange()

	if(!check_shit(BOUND_DISTANCE, ORB_AND_PREY))
		speed = 1
		adjustFireLoss(10)
		if(prob(25))
			to_chat(src, "<span class='warning'>You are not near your orb, or your target! You will move more slowly and take continuous damage until you are back in range!</span>")
		else
			speed = -0.15


/mob/living/simple_animal/hostile/hunter/AttackingTarget()
	if(target == orb)
		var/obj/structure/bloody_orb/susso = target
		susso.pick_target(src)
		return
	if(target == orb.master)
		to_chat(src,span_warning("[target] is protected by a binding rite! You can't attack them!"))
		return
	if(istype(target, /obj/machinery/door/airlock))
		pry_door(target)
		return
	if(isliving(target))
		if(last_target != target)
			attack_streak = 0
	if(prey==target)
		var/mob/living/carbon/human/dude = target
		if(dude.stat != UNCONSCIOUS && dude.stat != DEAD)
			if(HAS_TRAIT(dude, TRAIT_NODISMEMBER))
				return ..()
			if(prob(DEMON_SPECIAL_CHANCE + attack_streak*10))
				var/list/parts = list()
				var/undismembermerable_limbs = 0
				for(var/X in dude.bodyparts)
					var/obj/item/bodypart/BP = X
					if(BP.body_part != HEAD && BP.body_part != CHEST)
						if(BP.dismemberable)
							parts += BP
						else
							undismembermerable_limbs++

				if(!LAZYLEN(parts))
					if(undismembermerable_limbs)
						return ..()
					dude.Paralyze(100)
					visible_message(span_danger("[src] knocks [dude] down!"))
					return FALSE
				do_attack_animation(dude)
				var/obj/item/bodypart/BP = pick(parts)
				BP.dismember()
				if(attack_streak > 0)
					attack_streak--
				return FALSE
			else
				dude.adjustBruteLoss(10)
				attack_streak++
				playsound(loc, "punch", 25, 1, -1)
				visible_message(span_danger("[src] has punched [dude]!"), \
					span_userdanger("[src] has punched [dude]!"), null, COMBAT_MESSAGE_RANGE)
				return FALSE
		else
			///jaunt out related shit here. I didn't do that ability yet, so yeah...
			dude.forceMove(src)
			visible_message(span_danger("[src] grabs [dude], and prepares to jaunt out!"), \
				span_userdanger("[src] grabs [dude], preparing to jaunt out!"), null, COMBAT_MESSAGE_RANGE)
			if(do_after(src, 30, target = dude))
				playsound(src, 'sound/magic/demon_attack1.ogg', 100, TRUE)
				dude.forceMove(src) ///demon "eats" him
				for(var/obj/item/organ/O in dude.internal_organs) 
					qdel(O)
				var/turf/turfo = get_turf(src)
				src.phaseout()
				complete_assasination(TRUE)
				sleep(1200) //When i was trying to use a timer github was showing me unexisting errors, so fuck it
				OutOfBrazil(dude, turfo)
			return FALSE


	. = ..()

	if(. && isliving(target))
		heal_bodypart_damage(DEMON_LIFESTEAL)
		orb.blood_pool_summary += 6
		if(prob(DEMON_SPECIAL_CHANCE + (src.attack_streak*5)))
			var/mob/living/guy = target
			guy.adjustBruteLoss(10)
			var/atom/throw_target = get_edge_target_turf(guy, dir)
			guy.throw_at(throw_target, rand(1,2), 7, src)
			if(attack_streak)
				attack_streak--
		else
			attack_streak++

/proc/OutOfBrazil(mob/living/carbon/human/guy, turf/turfo)
	if(!turfo)
		return
	if(!guy)
		return
	guy.forceMove(turfo)
	guy.visible_message(span_danger("[guy]'s body suddenly appears out of nowhere!"), \
		span_userdanger("[guy]'s body suddenly appears out of nowhere!"), null, COMBAT_MESSAGE_RANGE)

/mob/living/simple_animal/hostile/hunter/proc/check_shit(range, wdwc = ORB_AND_PREY) ///wdwc - What Do We Check
	var/sex = FALSE
	if((get_dist(get_turf(src), get_turf(orb)) <= range) && wdwc != ONLY_PREY)
		sex = TRUE
	if((get_dist(get_turf(src), get_turf(prey)) <= range) && wdwc != ONLY_ORB)
		sex = TRUE
	return sex

/mob/living/simple_animal/hostile/hunter/proc/pry_door(target)
	var/obj/machinery/door/airlock/prying_door = target
	visible_message(span_warning("[src] begins prying open the airlock..."),
		span_notice("You begin digging your claws into the airlock..."),
		span_warning("You hear groaning metal..."),)
	playsound(src, 'sound/machines/airlock_alien_prying.ogg', 100, vary = TRUE)
	if(!prying_door.density || prying_door.locked || prying_door.welded)
		prying_door.open()
	else
		if(do_after(src, 2 SECONDS, prying_door))
			prying_door.take_damage(666, BRUTE, MELEE, 1) ///Die!!!
			visible_message(span_danger("[src] destroys [prying_door]!"), \
			span_userdanger("[src] destroys [prying_door]!"), null, COMBAT_MESSAGE_RANGE)

/mob/living/simple_animal/hostile/hunter/Destroy()
	. = ..()
	if(orb)
		orb.Destroy()

/mob/living/simple_animal/hostile/hunter/proc/complete_assasination(killed = TRUE)
	if(orb.master)
		if(killed)
			to_chat(orb.master, "<span class='warning'>The demon has killed its target. Go and choose a new one!</span>")
		else
			to_chat(orb.master, "<span class='warning'>The demon is unable to reach the set target. Go and choose a new one!</span>")
	target = null
	orb.target = null
	return

/mob/living/simple_animal/hostile/hunter/get_status_tab_items() 
	. = ..()
	. += "Bounding blood amount: [orb.sacrificed_blood]"
	. += "Summary blood amount: [orb.blood_pool_summary]"
	. += "Attack streak: [attack_streak]"
	if(prey)
		. += "Your target name: [prey.real_name]"
