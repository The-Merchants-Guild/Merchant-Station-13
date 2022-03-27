/obj/item/assembly/bang
	name = "BANG"
	desc = "A small electronic device able to emit a loud sound."
	icon_state = "bang"
	custom_materials = list(/datum/material/iron=500, /datum/material/glass=50)
	drop_sound = 'sound/items/handling/component_drop.ogg'
	pickup_sound =  'sound/items/handling/component_pickup.ogg'
	activation_delay = 40
	var/bang_range = 2

/obj/item/assembly/bang/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>[user] is trying to BANG [user.p_them()]self with \the [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	playsound(get_turf(src), 'sound/weapons/flashbang.ogg', 100, TRUE, 8, 0.9)
	return BRUTELOSS

/obj/item/assembly/bang/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return
	to_chat(user, "<span class='warning'>You short out the decibel restriction circuit.</span>")
	bang_range = 5 // This is a big mistake.
	obj_flags |= EMAGGED

/obj/item/assembly/bang/activate()
	if(!..())
		return FALSE

	if (obj_flags & EMAGGED)
		playsound(get_turf(src), "explosion", 200, TRUE, 12, 0.9) // when I say loud it means LOUD (normal explosion volume is 100, this is 200)
	else
		playsound(get_turf(src), 'sound/weapons/effects/bang.ogg', 100, TRUE, 8, 0.9)

	for(var/mob/living/M in get_hearers_in_view(bang_range, get_turf(src)))
		bang(get_turf(M), M)

	return TRUE

/obj/item/assembly/bang/proc/bang(turf/T, mob/living/M)
	if(M.stat == DEAD)
		return
	M.show_message("<span class='warning'>BANG</span>", MSG_AUDIBLE)
	var/distance = max(0, get_dist(get_turf(src), T))
	// A lot weaker than a real flashbang.
	if(!distance || loc == M || loc == M.loc)
		M.Paralyze(10)
		M.Knockdown(100)
		M.soundbang_act(1, 100, 10, 15)
	else
		if(distance <= 1)
			M.Paralyze(3)
			M.Knockdown(20)
		M.soundbang_act(1, max(100 / max(1,distance), 30), rand(0, 5))

/obj/item/assembly/bang/attack_self(mob/user)
	activate()
	add_fingerprint(user)
