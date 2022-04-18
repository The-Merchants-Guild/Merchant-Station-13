/datum/emote/living/carbon
	mob_type_allowed_typecache = list(/mob/living/carbon)

/mob/living/carbon //I challenge anyone here to fix this mess because I'm just copy pasting and fixing the bugs rn
	var/list/alternate_farts
	var/lose_butt = 12
	var/super_fart = 76
	var/super_nova_fart = 12
	var/fart_fly = 12
	var/smug_cd = 0
/datum/emote/living/carbon/fart
	key = "fart"
	key_third_person = "farts"

/datum/emote/living/carbon/fart/run_emote(mob/living/carbon/user, params)
	. = ..()
	if (!.)
		return
	var/fartsound = 'sound/effects/fart.ogg'
	var/blowass = prob(user.lose_butt) //Used to determine if the person blows his ass off this time, prevents having to use two forloops for the turf mobs.
	var/bloodkind = /obj/effect/decal/cleanable/blood
	message = null
	if(user.stat != CONSCIOUS)
		return
	var/obj/item/organ/butt/B = user.getorgan(/obj/item/organ/butt)
	if(!B)
		to_chat(user, "<span class='warning'>You don't have a butt!</span>")
		return


	for(var/mob/living/M in get_turf(user))
		if(M == user)
			continue
		if(blowass)
			message = "hits <b>[M]</b> in the face with [B]!"
			M.apply_damage(15,"brute","head")
			log_combat(user, M, "had his ass deal damage to")
		else
			message = pick(
				"farts in <b>[M]</b>'s face!",
				"gives <b>[M]</b> the silent but deadly treatment!",
				"rips mad ass in <b>[M]</b>'s mug!",
				"releases the musical fruits of labor onto <b>[M]</b>!",
				"commits an act of butthole bioterror all over <b>[M]</b>!",
				"poots, singing <b>[M]</b>'s eyebrows!",
				"humiliates <b>[M]</b> like never before!",
				"gets real close to <b>[M]</b>'s face and cuts the cheese!")
	if(!message)
		message = pick(
			"rears up and lets loose a fart of tremendous magnitude!",
			"farts!",
			"toots.",
			"harvests methane from uranus at mach 3!",
			"assists global warming!",
			"farts and waves their hand dismissively.",
			"farts and pretends nothing happened.",
			"is a <b>farting</b> motherfucker!",
			"<B><font color='red'>f</font><font color='blue'>a</font><font color='red'>r</font><font color='blue'>t</font><font color='red'>s</font></B>",
			"unleashes their unholy rectal vapor!",
			"assblasts gently.",
			"lets out a wet sounding one!",
			"exorcises a <b>ferocious</b> colonic demon!",
			"pledges ass-legience to the flag!",
			"cracks open a tin of beans!",
			"tears themselves a new one!",
			"looses some pure assgas!",
			"displays the most sophisticated type of humor.",
			"strains to get the fart out. Is that <font color='red'>blood</font>?",
			"sighs and farts simultaneously.",
			"expunges a gnarly butt queef!",
			"contributes to the erosion of the ozone layer!",
			"just farts. It's natural, everyone does it.",
			"had one too many tacos this week!",
			"has the phantom shits.",
			"flexes their bunghole.",
			"'s ass sings the song that ends the earth!",
			"had to go and ruin the mood!",
			"unflinchingly farts. True confidence.",
			"shows everyone what they had for breakfast!",
			"farts so loud it startles them!",
			"lets loose the farts of justice!",
			"rips a juicy one!",
			"'s ass breathes a sigh of relief.",
			"paints the elevator.",
			"breaks wind and a nearby wine glass!",
			"<b>finally achieves the perfect fart. All downhill from here.</b>")
	LAZYINITLIST(user.alternate_farts)
	if(LAZYLEN(user.alternate_farts))
		fartsound = pick(user.alternate_farts)
	if(istype(user,/mob/living/carbon/alien))
		bloodkind = /obj/effect/decal/cleanable/xenoblood
	var/obj/item/storage/book/bible/Y = locate() in get_turf(user.loc)
	user.newtonian_move(user.dir)
	if(istype(Y))
		user.Stun(20)
		playsound(Y,'sound/effects/thunder.ogg', 90, 1)
		var/turf/T = get_ranged_target_turf(user, NORTH, 8)
		T.Beam(user, icon_state="lightning[rand(1,12)]", time = 5)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.electrocution_animation(10)
		addtimer(CALLBACK(user, /mob/living/proc/gib), 10)
	else
		var/datum/component/storage/STR = B.GetComponent(/datum/component/storage)

		if(STR)
			var/list/STR_contents = STR.contents()
			if(STR_contents.len)
				var/obj/item/O = pick(STR_contents)
				if(istype(O, /obj/item/lighter))
					var/obj/item/lighter/G = O
					if(G.lit && user.loc)
						new/obj/effect/hotspot(user.loc)
						playsound(user, fartsound, 100, 1, 5)
				else if(istype(O, /obj/item/weldingtool))
					var/obj/item/weldingtool/J = O
					if(J.welding && user.loc)
						new/obj/effect/hotspot(user.loc)
						playsound(user, fartsound, 100, 1, 5)
				else if(istype(O, /obj/item/bikehorn))
					for(var/obj/item/bikehorn/Q in STR_contents)
						playsound(Q, 'sound/items/bikehorn.ogg', 100, 1, 5)
					message = "<span class='clown'>farts.</span>"
				else if(istype(O, /obj/item/megaphone))
					message = "<span class='reallybig'>farts.</span>"
					playsound(user, 'sound/effects/fartmassive.ogg', 100, 1, 5)
				else
					playsound(user, fartsound, 100, 1, 5)
				if(prob(33))
					STR.remove_from_storage(O, user.loc)
			else
				playsound(user, fartsound, 100, 1, 5)
		if(blowass)
			B.Remove(user)
			B.forceMove(get_turf(user))
			new bloodkind(user.loc)
			user.nutrition = max(user.nutrition - rand(5, 20), NUTRITION_LEVEL_STARVING)
			user.visible_message("<span class='warning'><b>[user]</b> blows their ass off!</span>", "<span class='warning'>Holy shit, your butt flies off in an arc!</span>")
		else
			user.nutrition = max(user.nutrition - rand(2, 10), NUTRITION_LEVEL_STARVING)
		if(!ishuman(user)) //nonhumans don't have the message appear for some reason
			user.visible_message("<b>[user]</b> [message]")

/datum/emote/living/carbon/human/superfart
	key = "superfart"
	key_third_person = "superfarts"
	stat_allowed = HARD_CRIT

/datum/emote/living/carbon/human/superfart/run_emote(mob/living/carbon/human/user, params)
	. = ..()
	if (!.)
		return
	if(!ishuman(user))
		to_chat(user, "<span class='warning'>You lack that ability!</span>")
		return
	var/obj/item/organ/butt/B = user.getorgan(/obj/item/organ/butt)
	if(!B)
		to_chat(user, "<span class='danger'>You don't have a butt!</span>")
		return
	if(B.loose)
		to_chat(user, "<span class='danger'>Your butt's too loose to superfart!</span>")
		return
	B.loose = TRUE // to avoid spamsuperfart
	var/fart_type = 1 //Put this outside probability check just in case. There were cases where superfart did a normal fart.
	if(prob(user.super_fart)) // 76% by default    1: ASSBLAST  2:SUPERNOVA  3: FARTFLY
		fart_type = 1
	else if(prob(user.super_nova_fart)) // 2.89% by default
		fart_type = 2
	else if(prob(user.fart_fly)) // 0.35% by default
		fart_type = 3
	var/obj/item/storage/book/bible/Y = locate() in get_turf(user.loc)
	if(istype(Y))
		user.Stun(20)
		playsound(Y,'sound/effects/thunder.ogg', 90, 1)
		var/turf/T = get_ranged_target_turf(user, NORTH, 8)
		T.Beam(user, icon_state="lightning[rand(1,12)]", time = 5)
		user.electrocution_animation(10)
		addtimer(CALLBACK(user, /mob/living/proc/gib), 10)
	else
		for(var/i in 1 to 10)
			playsound(user, 'sound/effects/fart.ogg', 100, 1, 5)
			sleep(1)
		playsound(user, 'sound/effects/fartmassive.ogg', 75, 1, 5)
		var/datum/component/storage/STR = B.GetComponent(/datum/component/storage)

		if(STR)
			var/list/STR_contents = STR.contents()
			if(STR_contents.len)
				for(var/obj/item/O in STR_contents)
					STR.remove_from_storage(O, user.loc)
					O.throw_range = 7//will be reset on hit
					var/turf/target = get_turf(O)
					var/range = 7
					var/turf/new_turf
					var/new_dir = REVERSE_DIR(user.dir)
					for(var/i = 1; i < range; i++)
						new_turf = get_step(target, new_dir)
						target = new_turf
						if(new_turf.density)
							break
					O.throw_at(target,range,O.throw_speed)
		B.Remove(user)
		B.forceMove(get_turf(user))
		if(B.loose)
			B.loose = FALSE
		new /obj/effect/decal/cleanable/blood(user.loc)
		user.nutrition = max(user.nutrition - 500, NUTRITION_LEVEL_STARVING)
		switch(fart_type)
			if(1)
				for(var/mob/living/M in range(0))
					if(M != user)
						user.visible_message("<span class='warning'><b>[user]</b>'s ass blasts <b>[M]</b> in the face!</span>", "<span class='warning'>You ass blast <b>[M]</b>!</span>")
						M.apply_damage(50,"brute","head")
						log_combat(user, M, "superfarted")

				user.visible_message("<span class='warning'><b>[user]</b> blows their ass off!</span>", "<span class='warning'>Holy shit, your butt flies off in an arc!</span>")
				if(!user.has_gravity())
					var/atom/target = get_edge_target_turf(user, user.dir)
					user.throw_at(target, 1000, 20)
					user.visible_message("<span class='warning'>[user] goes flying off into the distance!</span>", "<span class='warning'>You fly off into the distance!</span>")

			if(2)
				user.visible_message("<span class='warning'><b>[user]</b> rips their ass apart in a massive explosion!</span>", "<span class='warning'>Holy shit, your butt goes supernova!</span>")
				playsound(user, 'sound/effects/superfart.ogg', 75, extrarange = 255, pressure_affected = FALSE)
				explosion(user.loc, 0, 1, 3, adminlog = FALSE, flame_range = 3)
				user.gib()

			if(3)
				var/butt_end
				var/butt_x
				var/butt_y
				var/turf/T = get_turf(user.loc)
				//butt_end = spaceDebrisFinishLoc(user.dir, T.z)
				switch(user.dir)
					if(SOUTH)
						butt_y = world.maxy-(TRANSITIONEDGE+1)
						butt_x = user.x
					if(WEST)
						butt_x = world.maxx-(TRANSITIONEDGE+1)
						butt_y = user.y
					if(NORTH)
						butt_y = (TRANSITIONEDGE+1)
						butt_x = user.x
					else
						butt_x = (TRANSITIONEDGE+1)
						butt_y = user.y
				butt_end =locate(butt_x, butt_y, T.z)

				//ASS BLAST USA
				user.visible_message("<span class='warning'><b>[user]</b> blows their ass off with such force, they explode!</span>", "<span class='warning'>Holy shit, your butt flies off into the galaxy!</span>")
				playsound(user, 'sound/effects/superfart.ogg', 75, extrarange = 255, pressure_affected = FALSE)
				new /obj/effect/immovablerod/butt(user.loc, butt_end)
				user.gib() //can you belive I forgot to put this here?? yeah you need to see the message BEFORE you gib
				priority_announce("What the fuck was that?!", "General Alert")
				qdel(B)


/datum/emote/living/carbon/airguitar
	key = "airguitar"
	message = "is strumming the air and headbanging like a safari chimp."
	hands_use_check = TRUE

/datum/emote/living/carbon/blink
	key = "blink"
	key_third_person = "blinks"
	message = "blinks."

/datum/emote/living/carbon/blink_r
	key = "blink_r"
	message = "blinks rapidly."

/datum/emote/living/carbon/clap
	key = "clap"
	key_third_person = "claps"
	message = "claps."
	muzzle_ignore = TRUE
	hands_use_check = TRUE
	emote_type = EMOTE_AUDIBLE
	audio_cooldown = 5 SECONDS
	vary = TRUE

/datum/emote/living/carbon/clap/get_sound(mob/living/user)
	if(ishuman(user))
		if(!user.get_bodypart(BODY_ZONE_L_ARM) || !user.get_bodypart(BODY_ZONE_R_ARM))
			return
		else
			return pick('sound/misc/clap1.ogg',
							'sound/misc/clap2.ogg',
							'sound/misc/clap3.ogg',
							'sound/misc/clap4.ogg')

/datum/emote/living/carbon/crack
	key = "crack"
	key_third_person = "cracks"
	message = "cracks their knuckles."
	sound = 'sound/misc/knuckles.ogg'
	cooldown = 6 SECONDS

/datum/emote/living/carbon/crack/can_run_emote(mob/living/carbon/user, status_check = TRUE , intentional)
	if(!iscarbon(user) || user.usable_hands < 2)
		return FALSE
	return ..()
/datum/emote/living/carbon/moan
	key = "moan"
	key_third_person = "moans"
	message = "moans!"
	message_mime = "appears to moan!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/roll
	key = "roll"
	key_third_person = "rolls"
	message = "rolls."
	mob_type_allowed_typecache = list(/mob/living/carbon/alien)
	hands_use_check = TRUE

/datum/emote/living/carbon/scratch
	key = "scratch"
	key_third_person = "scratches"
	message = "scratches."
	mob_type_allowed_typecache = list(/mob/living/carbon/alien)
	hands_use_check = TRUE
/datum/emote/living/carbon/sign
	key = "sign"
	key_third_person = "signs"
	message_param = "signs the number %t."
	mob_type_allowed_typecache = list(/mob/living/carbon/alien)
	hands_use_check = TRUE

/datum/emote/living/carbon/sign/select_param(mob/user, params)
	. = ..()
	if(!isnum(text2num(params)))
		return message

/datum/emote/living/carbon/sign/signal
	key = "signal"
	key_third_person = "signals"
	message_param = "raises %t fingers."
	mob_type_allowed_typecache = list(/mob/living/carbon/human)
	hands_use_check = TRUE

/datum/emote/living/carbon/tail
	key = "tail"
	message = "waves their tail."
	mob_type_allowed_typecache = list(/mob/living/carbon/alien)

/datum/emote/living/carbon/wink
	key = "wink"
	key_third_person = "winks"
	message = "winks."

/datum/emote/living/carbon/circle
	key = "circle"
	key_third_person = "circles"
	hands_use_check = TRUE

/datum/emote/living/carbon/circle/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!length(user.get_empty_held_indexes()))
		to_chat(user, span_warning("You don't have any free hands to make a circle with."))
		return
	var/obj/item/circlegame/N = new(user)
	if(user.put_in_hands(N))
		to_chat(user, span_notice("You make a circle with your hand."))

/datum/emote/living/carbon/slap
	key = "slap"
	key_third_person = "slaps"
	hands_use_check = TRUE
	cooldown = 3 SECONDS // to prevent endless table slamming

/datum/emote/living/carbon/slap/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return
	var/obj/item/slapper/N = new(user)
	if(user.put_in_hands(N))
		to_chat(user, span_notice("You ready your slapping hand."))
	else
		qdel(N)
		to_chat(user, span_warning("You're incapable of slapping in your current state."))

/datum/emote/living/carbon/noogie
	key = "noogie"
	key_third_person = "noogies"
	hands_use_check = TRUE

/datum/emote/living/carbon/noogie/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return
	var/obj/item/noogie/noogie = new(user)
	if(user.put_in_hands(noogie))
		to_chat(user, span_notice("You ready your noogie'ing hand."))
	else
		qdel(noogie)
		to_chat(user, span_warning("You're incapable of noogie'ing in your current state."))
