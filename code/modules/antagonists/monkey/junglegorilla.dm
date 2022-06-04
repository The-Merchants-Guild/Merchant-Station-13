
/mob/living/carbon/proc/rabidgorillize()
	if(notransform)
		return
	notransform = TRUE
	Paralyze(1, ignore_canstun = TRUE)

	SSblackbox.record_feedback("amount", "gorillas_created", 1)

	var/Itemlist = get_equipped_items(TRUE)
	Itemlist += held_items
	for(var/obj/item/W in Itemlist)
		dropItemToGround(W, TRUE)

	regenerate_icons()
	icon = null
	invisibility = INVISIBILITY_MAXIMUM
	var/mob/living/simple_animal/hostile/gorilla/rabid/new_gorilla = new (get_turf(src))
	new_gorilla.set_combat_mode(TRUE)
	if(mind)
		mind.transfer_to(new_gorilla)
	else
		new_gorilla.key = key
	to_chat(new_gorilla, "<B>You are now a gorilla. Ooga ooga!</B>")
	. = new_gorilla
	qdel(src)

/mob/living/simple_animal/hostile/gorilla/rabid
	name = "Rabid Gorilla"
	desc = "A mangy looking gorilla."
	icon_state = "crawling"
	icon_state = "crawling"
	icon_living = "crawling"
	icon_dead = "dead"
	mob_biotypes = list(MOB_ORGANIC, MOB_HUMANOID)
	speak_chance = 80
	maxHealth = 220
	health = 220
	loot = list(/obj/effect/gibspawner/generic/animal)
	damage_coeff = list(BRUTE = 0.8, BURN = 1, TOX = 1, CLONE = 0, STAMINA = 0, OXY = 1)
	obj_damage = 50
	environment_smash = ENVIRONMENT_SMASH_RWALLS
	diseased = TRUE