/obj/effect/eldritch
	name = "Generic rune"
	desc = "A flowing circle of shapes and runes is etched into the floor, filled with a thick black tar-like fluid."
	anchored = TRUE
	icon_state = ""
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	layer = SIGIL_LAYER
	///Used mainly for summoning ritual to prevent spamming the rune to create millions of monsters.
	var/is_in_use = FALSE

/obj/effect/eldritch/Initialize()
	. = ..()
	var/image/I = image(icon = 'icons/effects/eldritch.dmi', icon_state = null, loc = src)
	I.override = TRUE
	add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/silicons, "heretic_rune", I)

/obj/effect/eldritch/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	try_activate(user)

/obj/effect/eldritch/proc/try_activate(mob/living/user)
	if(!IS_HERETIC(user))
		return
	if(!is_in_use)
		INVOKE_ASYNC(src, .proc/activate , user)

/obj/effect/eldritch/attackby(obj/item/I, mob/living/user)
	. = ..()
	if(istype(I,/obj/item/nullrod))
		user.say("BEGONE FOUL MAGIKS!!", forced = "nullrod")
		to_chat(user, span_danger("You disrupt the magic of [src] with [I]."))
		qdel(src)

/obj/effect/eldritch/proc/activate(mob/living/user)
	is_in_use = TRUE
	// Have fun trying to read this proc.
	var/datum/antagonist/heretic/cultie = user.mind.has_antag_datum(/datum/antagonist/heretic)
	var/list/knowledge = cultie.get_all_knowledge()
	var/list/atoms_in_range = list()

	for(var/A in range(1, src))
		var/atom/atom_in_range = A
		if(istype(atom_in_range,/area))
			continue
		if(istype(atom_in_range,/turf)) // we dont want turfs
			continue
		if(istype(atom_in_range,/mob/living))
			var/mob/living/living_in_range = atom_in_range
			if(living_in_range.stat != DEAD || living_in_range == user) // we only accept corpses, no living beings allowed.
				continue
		atoms_in_range += atom_in_range
	for(var/X in knowledge)
		var/datum/eldritch_knowledge/current_eldritch_knowledge = knowledge[X]

		//has to be done so that we can freely edit the local_required_atoms without fucking up the eldritch knowledge
		var/list/local_required_atoms = list()

		if(!current_eldritch_knowledge.required_atoms || current_eldritch_knowledge.required_atoms.len == 0)
			continue

		local_required_atoms += current_eldritch_knowledge.required_atoms

		var/list/selected_atoms = list()

		if(!current_eldritch_knowledge.recipe_snowflake_check(atoms_in_range,drop_location(),selected_atoms))
			continue

		for(var/LR in local_required_atoms)
			var/list/local_required_atom_list = LR

			for(var/LAIR in atoms_in_range)
				var/atom/local_atom_in_range = LAIR
				if(is_type_in_list(local_atom_in_range,local_required_atom_list))
					selected_atoms |= local_atom_in_range
					local_required_atoms -= list(local_required_atom_list)
					break

		if(length(local_required_atoms) > 0)
			continue

		flick("[icon_state]_active",src)
		playsound(user, 'sound/magic/castsummon.ogg', 75, TRUE, extrarange = SILENCED_SOUND_EXTRARANGE, falloff_exponent = 10)
		//we are doing this since some on_finished_recipe subtract the atoms from selected_atoms making them invisible permanently.
		var/list/atoms_to_disappear = selected_atoms.Copy()
		for(var/to_disappear in atoms_to_disappear)
			var/atom/atom_to_disappear = to_disappear
			//temporary so we dont have to deal with the bs of someone picking those up when they may be deleted
			atom_to_disappear.invisibility = INVISIBILITY_ABSTRACT
		if(current_eldritch_knowledge.on_finished_recipe(user,selected_atoms,loc))
			current_eldritch_knowledge.cleanup_atoms(selected_atoms)

		for(var/to_appear in atoms_to_disappear)
			var/atom/atom_to_appear = to_appear
			//we need to reappear the item just in case the ritual didnt consume everything... or something.
			atom_to_appear.invisibility = initial(atom_to_appear.invisibility)

		is_in_use = FALSE
		return
	is_in_use = FALSE
	to_chat(user,span_warning("Your ritual failed! You either used the wrong components or are missing something important!"))

/obj/effect/eldritch/big
	name = "transmutation rune"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "eldritch_rune1"
	pixel_x = -32 //So the big ol' 96x96 sprite shows up right
	pixel_y = -32
