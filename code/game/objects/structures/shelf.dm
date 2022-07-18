#define SHELF_UNANCHORED 0
#define SHELF_ANCHORED 1

/* Shelves
 *
 * Contains:
 * Guns
 * Ammo
 * Armor
 * Helmet
 */

/*
 * Shelf
 */

/obj/structure/shelf
	name = "Shelf"
	icon = 'icons/obj/shelves.dmi'
	icon_state = "shelf"
	base_icon_state = "shelf"
	desc = "A great place for storing items."
	anchored = FALSE
	density = TRUE
	opacity = FALSE
	resistance_flags = FLAMMABLE
	max_integrity = 200
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 0)
	var/state = SHELF_UNANCHORED
	var/item = "item"
	///Stored items in the shelf
	var/list/obj/item/stored = list()
	///Which item can be stored in the shelf
	var/allowed = /obj/item
	var/max = 12

/obj/structure/shelf/Initialize(mapload)
	. = ..()
	if(!mapload)
		return
	set_anchored(TRUE)
	spawn_item()
	update_appearance()

/obj/structure/shelf/set_anchored(anchorvalue)
	. = ..()
	if(isnull(.))
		return
	state = anchorvalue
	if(!anchorvalue) //in case we were vareditted or uprooted by a hostile mob, ensure we drop all our items instead of having them disappear till we're rebuild.
		var/atom/Tsec = drop_location()
		for(var/obj/item/I in stored)
			I.invisibility = 0
			I.forceMove(Tsec)
		stored = new()
	update_appearance()

/obj/structure/shelf/examine(mob/user)
	. = ..()
	if(!anchored)
		. += span_notice("The <i>bolts</i> on the bottom are unsecured.")
	else
		. += span_notice("It's secured in place with <b>bolts</b>.")
	switch(state)
		if(SHELF_UNANCHORED)
			. += span_notice("There's a <b>small crack</b> visible on the back panel.")
		if(SHELF_ANCHORED)
			. += span_notice("There's space inside for a <i>wooden</i> shelf.")
	if(LAZYLEN(stored))
		. += span_notice("In the [name] you can see.")
		for(var/obj/item/I in stored)
			. += span_notice("[I.name]")

/obj/structure/shelf/attackby(obj/item/I, mob/user, params)
	switch(state)
		if(SHELF_UNANCHORED)
			if(I.tool_behaviour == TOOL_WRENCH)
				if(I.use_tool(src, user, volume=50))
					to_chat(user, span_notice("You wrench the frame into place."))
					set_anchored(TRUE)

			else if(I.tool_behaviour == TOOL_CROWBAR)
				if(I.use_tool(src, user, volume=50))
					to_chat(user, span_notice("You pry the frame apart."))
					deconstruct(TRUE)
			return

		if(SHELF_ANCHORED)
			if(I.tool_behaviour == TOOL_WRENCH)
				I.play_tool_sound(src, 100)
				to_chat(user, span_notice("You unwrench the frame."))
				set_anchored(FALSE)
				return

	if(!check_item(I))
		to_chat(user, span_warning("You can only put [item] in."))
		return

	if(LAZYLEN(stored)>=max)
		to_chat(user, span_warning("You cant store more [item]s."))
		return

	stored += I
	I.forceMove(src)
	I.invisibility = 100
	to_chat(user, span_notice("You put the [I.name] in."))
	update_appearance()

/obj/structure/shelf/attack_hand(mob/living/user, list/modifiers)
	if(!istype(user))
		return
	if(LAZYLEN(stored))
		var/obj/item/choice = input(user, "Which [item] would you like to remove from the shelf?") as null|obj in sortNames(stored.Copy())
		if(choice)
			if(!(user.mobility_flags & MOBILITY_USE) || user.stat != CONSCIOUS || HAS_TRAIT(user, TRAIT_HANDS_BLOCKED) || !in_range(loc, user))
				return
			if(ishuman(user))
				choice.invisibility = 0
				if(!user.get_active_held_item())
					user.put_in_hands(choice)
			else
				choice.forceMove(drop_location())
			to_chat(user, span_notice("You take the [choice.name] out of the shelf."))
			stored -= choice
			update_appearance()

/obj/structure/shelf/proc/spawn_item()

/obj/structure/shelf/proc/check_item(obj/item/I)
	if(!istype(I, allowed))
		return FALSE
	return TRUE

/obj/structure/shelf/deconstruct(disassembled = TRUE)
	var/atom/Tsec = drop_location()
	new /obj/item/stack/sheet/mineral/wood(Tsec, 4)
	for(var/obj/item/I in stored)
		I.invisibility = 0
		I.forceMove(Tsec)
	stored = null
	return ..()

/obj/structure/shelf/update_icon_state()
	icon_state = LAZYLEN(stored) ? "[base_icon_state]-[item]" : "[base_icon_state]"
	return ..()

/obj/structure/shelf/gun
	name = "Gun Shelf"
	desc = "A great place for storing guns"
	item = "gun"
	allowed = /obj/item/gun

/obj/structure/shelf/gun/spawn_item()
	stored += list(
		new /obj/item/gun/ballistic/rifle/boltaction,
		new /obj/item/gun/ballistic/rifle/boltaction/brand_new,
		new /obj/item/gun/ballistic/rifle/boltaction/harpoon,
		new /obj/item/gun/ballistic/rifle/boltaction/pipegun,
		new /obj/item/gun/ballistic/rifle/boltaction/pipegun/prime,
	)

/obj/structure/shelf/ammo
	name = "Ammo Shelf"
	desc = "A great place for storing ammo"
	item = "ammo"
	max = 30
	allowed = /obj/item/ammo_box

/obj/structure/shelf/ammo/spawn_item()
	stored += list(
		new /obj/item/ammo_box/a762,
		new /obj/item/ammo_box/a762,
		new /obj/item/ammo_box/a762,
		new /obj/item/ammo_box/a762,
		new /obj/item/ammo_box/a762,
		new /obj/item/ammo_box/a762,
		new /obj/item/ammo_box/a762,
		new /obj/item/ammo_box/a762,
		new /obj/item/ammo_box/a762,
		new /obj/item/ammo_box/a762,
	)

/obj/structure/shelf/armor
	name = "Armor Shelf"
	desc = "A great place for storing armors"
	item = "armor"
	allowed = /obj/item/clothing/suit/armor

/obj/structure/shelf/armor/spawn_item()
	stored += list(
		new /obj/item/clothing/suit/armor/bulletproof,
		new /obj/item/clothing/suit/armor/riot,
		new /obj/item/clothing/suit/armor/vest,
		new /obj/item/clothing/suit/armor/vest/russian_coat,
		new /obj/item/clothing/suit/armor/vest/durathread,
	)

/obj/structure/shelf/helmet
	name = "Helmet Shelf"
	desc = "A great place for storing helmets"
	item = "helmet"
	allowed = /obj/item/clothing/head/helmet

/obj/structure/shelf/helmet/spawn_item()
	stored += list(
		new /obj/item/clothing/head/helmet,
		new /obj/item/clothing/head/helmet/alt,
		new /obj/item/clothing/head/helmet/riot,
		new /obj/item/clothing/head/helmet/rus_ushanka,
		new /obj/item/clothing/head/helmet/durathread,
	)

#undef SHELF_UNANCHORED
#undef SHELF_ANCHORED
