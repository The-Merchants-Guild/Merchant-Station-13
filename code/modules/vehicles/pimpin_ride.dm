//PIMP-CART
/obj/vehicle/ridden/janicart
	name = "janicart (pimpin' ride)"
	desc = "A brave janitor cyborg gave its life to produce such an amazing combination of speed and utility."
	icon_state = "pussywagon"
	key_type = /obj/item/key/janitor
	var/obj/item/storage/bag/trash/mybag = null
	var/floorbuffer = FALSE
	movedelay = 1

/obj/vehicle/ridden/janicart/Initialize(mapload)
	. = ..()
	update_appearance()
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/janicart)

	if(floorbuffer)
		AddElement(/datum/element/cleaning)

/obj/vehicle/ridden/janicart/Destroy()
	if(mybag)
		QDEL_NULL(mybag)
	return ..()

/obj/item/janiupgrade
	name = "floor buffer upgrade"
	desc = "An upgrade for mobile janicarts."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "upgrade"

/obj/vehicle/ridden/janicart/examine(mob/user)
	. = ..()
	if(floorbuffer)
		. += "It has been upgraded with a floor buffer."

/obj/vehicle/ridden/janicart/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/storage/bag/trash))
		if(mybag)
			to_chat(user, "<span class='warning'>[src] already has a trashbag hooked!</span>")
			return
		if(!user.transferItemToLoc(I, src))
			return
		to_chat(user, "<span class='notice'>You hook the trashbag onto [src].</span>")
		mybag = I
		update_appearance()
	else if(istype(I, /obj/item/janiupgrade))
		if(floorbuffer)
			to_chat(user, "<span class='warning'>[src] already has a floor buffer!</span>")
			return
		floorbuffer = TRUE
		qdel(I)
		to_chat(user, "<span class='notice'>You upgrade [src] with the floor buffer.</span>")
		AddElement(/datum/element/cleaning)
		update_appearance()
	else if(mybag)
		mybag.attackby(I, user)
	else
		return ..()

/obj/vehicle/ridden/janicart/update_overlays()
	. = ..()
	if(mybag)
		. += "cart_garbage"
	if(floorbuffer)
		. += "cart_buffer"

/obj/vehicle/ridden/janicart/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(. || !mybag)
		return
	mybag.forceMove(get_turf(user))
	user.put_in_hands(mybag)
	mybag = null
	update_appearance()

/obj/vehicle/ridden/janicart/upgraded
	floorbuffer = TRUE

/obj/vehicle/ridden/lawnmower
	name = "lawn mower"
	desc = "Equipped with reliable safeties to prevent <i>accidents</i> in the workplace."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "lawnmower"
	var/emagged = FALSE
	var/list/drive_sounds = list('sound/effects/mowermove1.ogg', 'sound/effects/mowermove2.ogg')
	var/list/gib_sounds = list('sound/effects/mowermovesquish.ogg')

/obj/vehicle/ridden/lawnmower/Initialize()
	.= ..()
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/lawnmower)

/obj/vehicle/ridden/lawnmower/emagged
	emagged = TRUE

/obj/vehicle/ridden/lawnmower/emag_act(mob/user)
	if(emagged)
		to_chat(user, "<span class='warning'>The safety mechanisms on \the [src] are already disabled!</span>")
		return
	to_chat(user, "<span class='warning'>You disable the safety mechanisms on \the [src].</span>")
	emagged = TRUE

/obj/vehicle/ridden/lawnmower/Bump(atom/A)
	if(!emagged || !isliving(A))
		return
	var/mob/living/M = A
	M.adjustBruteLoss(25)
	var/atom/newLoc = get_edge_target_turf(M, get_dir(src, get_step_away(M, src)))
	M.throw_at(newLoc, 4, 1)

/obj/vehicle/ridden/lawnmower/Move()
	..()
	var/gibbed = FALSE
	var/gib_scream = FALSE
	var/mob/living/carbon/H

	if(has_buckled_mobs())
		H = buckled_mobs[1]

	if(emagged)
		for(var/mob/living/carbon/human/M in loc)
			if(M == H)
				continue
			if(M.body_position == LYING_DOWN)
				visible_message("<span class='danger'>\the [src] grinds [M.name] into a fine paste!</span>")
				if (M.stat != DEAD)
					gib_scream = TRUE
				M.gib()
				shake_camera(M, 20, 1)
				gibbed = TRUE

	if(gibbed)
		shake_camera(H, 10, 1)
		if (gib_scream)
			playsound(loc, 'sound/voice/gib_scream.ogg', 100, 1, frequency = rand(11025*0.75, 11025*1.25))
		else
			playsound(loc, pick(gib_sounds), 75, 1)
	else
		playsound(loc, pick(drive_sounds), 75, 1)
