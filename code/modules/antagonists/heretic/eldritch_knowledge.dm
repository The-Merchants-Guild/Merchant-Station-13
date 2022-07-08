
/**
 * #Eldritch Knwoledge
 *
 * Datum that makes eldritch cultist interesting.
 *
 * Eldritch knowledge aren't instantiated anywhere roundstart, and are initalized and destroyed as the round goes on.
 */
/datum/eldritch_knowledge
	///Name of the knowledge
	var/name = "Basic knowledge"
	///Description of the knowledge
	var/desc = "Basic knowledge of forbidden arts."
	///What shows up
	var/gain_text = ""
	///Cost of knowledge in souls
	var/cost = 0
	///Next knowledge in the research tree
	var/list/next_knowledge = list()
	///What knowledge is incompatible with this. This will simply make it impossible to research knowledges that are in banned_knowledge once this gets researched.
	var/list/banned_knowledge = list()
	///Used with rituals, how many items this needs
	var/list/required_atoms = list()
	///What do we get out of this
	var/list/result_atoms = list()
	///What path is this on defaults to "Side"
	var/route = PATH_SIDE

/datum/eldritch_knowledge/New()
	. = ..()
	var/list/temp_list
	for(var/atom/required_atom as anything in required_atoms)
		temp_list += list(typesof(required_atom))
	required_atoms = temp_list

/**
 * What happens when this is assigned to an antag datum
 *
 * This proc is called whenever a new eldritch knowledge is added to an antag datum
 */
/datum/eldritch_knowledge/proc/on_gain(mob/user)
	to_chat(user, span_warning("[gain_text]"))
	if(route == PATH_BLADE)
		RegisterSignal(user, COMSIG_HERETIC_BLADE_MANIPULATION, .proc/allow_to_sharp)
	return
/**
 * What happens when you loose this
 *
 * This proc is called whenever antagonist looses his antag datum, put cleanup code in here
 */
/datum/eldritch_knowledge/proc/on_lose(mob/user)
	return

/datum/eldritch_knowledge/proc/on_research(mob/user)
	return

//See Register
/datum/eldritch_knowledge/proc/allow_to_sharp(mob/user)
	return COMPONENT_SHARPEN
/**
 * Special check for recipes
 *
 * If you are adding a more complex summoning or something that requires a special check that parses through all the atoms in an area override this.
 */
/datum/eldritch_knowledge/proc/recipe_snowflake_check(list/atoms, loc)
	return TRUE

/datum/eldritch_knowledge/proc/on_dead(mob/user)
	return

/**
 * What happens once the recipe is succesfully finished
 *
 * By default this proc creates atoms from result_atoms list. Override this is you want something else to happen.
 */
/datum/eldritch_knowledge/proc/on_finished_recipe(mob/living/user, list/atoms, loc)
	if(!length(result_atoms))
		return FALSE
	for(var/result in result_atoms)
		new result(loc)
	return TRUE

/**
 * Used atom cleanup
 *
 * Overide this proc if you dont want ALL ATOMS to be destroyed. useful in many situations.
 */
/datum/eldritch_knowledge/proc/cleanup_atoms(list/atoms)
	for(var/atom/sacrificed as anything in atoms)
		if(!isliving(sacrificed))
			atoms -= sacrificed
			qdel(sacrificed)
	return


//////////////
///Subtypes///
//////////////

/datum/eldritch_knowledge/spell
	var/obj/effect/proc_holder/spell/spell_to_add

/datum/eldritch_knowledge/spell/Destroy(force, ...)
	if(istype(spell_to_add))
		QDEL_NULL(spell_to_add)
	return ..()

/datum/eldritch_knowledge/spell/on_gain(mob/user)
	spell_to_add = new spell_to_add()
	user.mind.AddSpell(spell_to_add)
	return ..()

/datum/eldritch_knowledge/spell/on_lose(mob/user)
	user.mind.RemoveSpell(spell_to_add)
	return ..()

/*
 * A knowledge subtype for knowledge that can only
 * have a limited amount of it's resulting atoms
 * created at once.
 */
/datum/eldritch_knowledge/limited_amount
	/// The limit to how many items we can create at once.
	var/limit = 1
	/// A list of weakrefs to all items we've created.
	var/list/datum/weakref/created_items

/datum/eldritch_knowledge/limited_amount/Destroy(force, ...)
	LAZYCLEARLIST(created_items)
	return ..()

/datum/eldritch_knowledge/limited_amount/recipe_snowflake_check(mob/living/user, list/atoms, list/selected_atoms, turf/loc)
	for(var/datum/weakref/ref as anything in created_items)
		var/atom/real_thing = ref.resolve()
		if(QDELETED(real_thing))
			LAZYREMOVE(created_items, ref)

	if(LAZYLEN(created_items) >= limit)
		to_chat(user, span_warning("Ritual failed, at limit!"))
		return FALSE

	return TRUE

/datum/eldritch_knowledge/limited_amount/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	for(var/result in result_atoms)
		var/atom/created_thing = new result(loc)
		LAZYADD(created_items, WEAKREF(created_thing))
	return TRUE

/datum/eldritch_knowledge/starting
	cost = 1

/datum/eldritch_knowledge/mark
	cost = 2
	/// The status effect typepath we apply on people on mansus grasp.
	var/datum/status_effect/eldritch/mark_type

/datum/eldritch_knowledge/mark/on_gain(mob/user)
	RegisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK, .proc/on_mansus_grasp)
	RegisterSignal(user, COMSIG_HERETIC_BLADE_ATTACK, .proc/on_eldritch_blade)

/datum/eldritch_knowledge/mark/on_lose(mob/user)
	UnregisterSignal(user, list(COMSIG_HERETIC_MANSUS_GRASP_ATTACK, COMSIG_HERETIC_BLADE_ATTACK))

/**
 * Signal proc for [COMSIG_HERETIC_MANSUS_GRASP_ATTACK].
 *
 * Whenever we cast mansus grasp on someone, apply our mark.
 */
/datum/eldritch_knowledge/mark/proc/on_mansus_grasp(mob/living/source, mob/living/target)
	SIGNAL_HANDLER

	create_mark(source, target)

/**
 * Signal proc for [COMSIG_HERETIC_BLADE_ATTACK].
 *
 * Whenever we attack someone with our blade, attempt to trigger any marks on them.
 */
/datum/eldritch_knowledge/mark/proc/on_eldritch_blade(mob/living/source, mob/living/target, obj/item/melee/sickly_blade/blade)
	SIGNAL_HANDLER

	trigger_mark(source, target)

/**
 * Creates the mark status effect on our target.
 * This proc handles the instatiate and the application of the station effect,
 * and returns the /datum/status_effect instance that was made.
 *
 * Can be overriden to set or pass in additional vars of the status effect.
 */
/datum/eldritch_knowledge/mark/proc/create_mark(mob/living/source, mob/living/target)
	return target.apply_status_effect(mark_type)

/**
 * Handles triggering the mark on the target.
 *
 * If there is no mark, returns FALSE. Returns TRUE if a mark was triggered.
 */
/datum/eldritch_knowledge/mark/proc/trigger_mark(mob/living/source, mob/living/target)
	var/datum/status_effect/eldritch/mark = target.has_status_effect(/datum/status_effect/eldritch)
	if(!istype(mark))
		return FALSE

	mark.on_effect()
	return TRUE

/*
 * A knowledge subtype for heretic knowledge that
 * upgrades their sickly blade, either on melee or range.
 *
 * A heretic can only learn one /blade_upgrade type knowledge.
 */
/datum/eldritch_knowledge/blade_upgrade
	cost = 2

/datum/eldritch_knowledge/blade_upgrade/on_gain(mob/user)
	RegisterSignal(user, COMSIG_HERETIC_BLADE_ATTACK, .proc/on_eldritch_blade)
	RegisterSignal(user, COMSIG_HERETIC_RANGED_BLADE_ATTACK, .proc/on_ranged_eldritch_blade)

/datum/eldritch_knowledge/blade_upgrade/on_lose(mob/user)
	UnregisterSignal(user, list(COMSIG_HERETIC_BLADE_ATTACK, COMSIG_HERETIC_RANGED_BLADE_ATTACK))


/**
 * Signal proc for [COMSIG_HERETIC_BLADE_ATTACK].
 *
 * Apply any melee effects from hitting someone with our blade.
 */
/datum/eldritch_knowledge/blade_upgrade/proc/on_eldritch_blade(mob/living/source, mob/living/target, obj/item/melee/sickly_blade/blade)
	SIGNAL_HANDLER

	do_melee_effects(source, target, blade)

/**
 * Signal proc for [COMSIG_HERETIC_RANGED_BLADE_ATTACK].
 *
 * Apply any ranged effects from hitting someone with our blade.
 */
/datum/eldritch_knowledge/blade_upgrade/proc/on_ranged_eldritch_blade(mob/living/source, mob/living/target, obj/item/melee/sickly_blade/blade)
	SIGNAL_HANDLER

	do_ranged_effects(source, target, blade)

/**
 * Overridable proc that invokes special effects
 * whenever the heretic attacks someone in melee with their heretic blade.
 */
/datum/eldritch_knowledge/blade_upgrade/proc/do_melee_effects(mob/living/source, mob/living/target, obj/item/melee/sickly_blade/blade)
	return

/**
 * Overridable proc that invokes special effects
 * whenever the heretic clicks on someone at range with their heretic blade.
 */
/datum/eldritch_knowledge/blade_upgrade/proc/do_ranged_effects(mob/living/source, mob/living/target, obj/item/melee/sickly_blade/blade)
	return

/datum/eldritch_knowledge/curse
	var/timer = 5 MINUTES
	var/list/fingerprints = list()
	var/list/dna = list()

/datum/eldritch_knowledge/curse/recipe_snowflake_check(list/atoms, loc)
	fingerprints = list()
	for(var/atom/requirements as anything in atoms)
		fingerprints |= requirements.return_fingerprints()
	listclearnulls(fingerprints)
	if(fingerprints.len == 0)
		return FALSE
	return TRUE

/datum/eldritch_knowledge/curse/on_finished_recipe(mob/living/user,list/atoms,loc)

	var/list/compiled_list = list()

	for(var/mob/living/carbon/human/human_to_check as anything in GLOB.human_list)
		if(fingerprints[md5(human_to_check.dna.unique_identity)])
			compiled_list |= human_to_check.real_name
			compiled_list[human_to_check.real_name] = human_to_check

	if(compiled_list.len == 0)
		to_chat(user, span_warning("These items don't possess the required fingerprints or DNA."))
		return FALSE

	var/chosen_mob = input("Select the person you wish to curse","Your target") as null|anything in sortList(compiled_list, /proc/cmp_mob_realname_dsc)
	if(!chosen_mob)
		return FALSE
	curse(compiled_list[chosen_mob])
	addtimer(CALLBACK(src, .proc/uncurse, compiled_list[chosen_mob]),timer)
	return TRUE

/datum/eldritch_knowledge/curse/proc/curse(mob/living/chosen_mob)
	return

/datum/eldritch_knowledge/curse/proc/uncurse(mob/living/chosen_mob)
	return

/*
 * A knowledge subtype lets the heretic summon a monster with the ritual.
 */
/datum/eldritch_knowledge/summon
	/// Typepath of a mob to summon when we finish the recipe.
	var/mob/living/mob_to_summon

/datum/eldritch_knowledge/summon/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	var/mob/living/summoned = new mob_to_summon(loc)
	// Fade in the summon while the ghost poll is ongoing.
	// Also don't let them mess with the summon while waiting
	summoned.alpha = 0
	summoned.notransform = TRUE
	summoned.move_resist = MOVE_FORCE_OVERPOWERING
	animate(summoned, 10 SECONDS, alpha = 155)

	message_admins("A [summoned.name] is being summoned by [ADMIN_LOOKUPFLW(user)] in [ADMIN_COORDJMP(summoned)].")
	var/list/mob/dead/observer/candidates = pollCandidatesForMob("Do you want to play as a [summoned.real_name]?", ROLE_HERETIC, FALSE, 10 SECONDS, summoned)
	if(!LAZYLEN(candidates))
		to_chat(user, span_warning("Ritual failed, no ghosts!"))
		animate(summoned, 0.5 SECONDS, alpha = 0)
		QDEL_IN(summoned, 0.6 SECONDS)
		return FALSE

	var/mob/dead/observer/picked_candidate = pick(candidates)
	// Ok let's make them an interactable mob now, since we got a ghost
	summoned.alpha = 255
	summoned.notransform = FALSE
	summoned.move_resist = initial(summoned.move_resist)

	summoned.ghostize(FALSE)
	summoned.key = picked_candidate.key

	log_game("[key_name(user)] created a [summoned.name], controlled by [key_name(picked_candidate)].")
	message_admins("[ADMIN_LOOKUPFLW(user)] created a [summoned.name], [ADMIN_LOOKUPFLW(summoned)].")

	var/datum/antagonist/heretic_monster/heretic_monster = summoned.mind.add_antag_datum(/datum/antagonist/heretic_monster)
	heretic_monster.set_owner(user.mind)

	var/datum/objective/heretic_summon/summon_objective = locate() in user.mind.get_all_objectives()
	summon_objective?.num_summoned++

	return TRUE

//Ascension knowledge
/datum/eldritch_knowledge/final
	var/finished = FALSE
	required_atoms = list(/mob/living/carbon/human = 3)
	cost = 3

/datum/eldritch_knowledge/final/recipe_snowflake_check(list/atoms, loc, selected_atoms)
	if(finished)
		return FALSE
	var/counter = 0
	for(var/mob/living/carbon/human/sacrifices in atoms)
		selected_atoms |= sacrifices
		counter++
		if(counter == 3)
			return TRUE
	return FALSE

/datum/eldritch_knowledge/final/on_finished_recipe(mob/living/user, list/atoms, loc)
	finished = TRUE
	var/datum/antagonist/heretic/ascension = user.mind.has_antag_datum(/datum/antagonist/heretic)
	ascension.ascended = TRUE
	return TRUE

/datum/eldritch_knowledge/final/cleanup_atoms(list/selected_atoms)
	. = ..()
	for(var/mob/living/carbon/human/sacrifices in selected_atoms)
		selected_atoms -= sacrifices
		sacrifices.gib()
