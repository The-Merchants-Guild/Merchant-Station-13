
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
	return
/**
 * What happens when you loose this
 *
 * This proc is called whenever antagonist looses his antag datum, put cleanup code in here
 */
/datum/eldritch_knowledge/proc/on_lose(mob/user)
	return
/**
 * What happens every tick
 *
 * This proc is called on SSprocess in eldritch cultist antag datum. SSprocess happens roughly every second
 */
/datum/eldritch_knowledge/proc/on_life(mob/user)
	return

/**
 * Special check for recipes
 *
 * If you are adding a more complex summoning or something that requires a special check that parses through all the atoms in an area override this.
 */
/datum/eldritch_knowledge/proc/recipe_snowflake_check(list/atoms, loc)
	return TRUE

/**
 * A proc that handles the code when the mob dies
 *
 * This proc is primarily used to end any soundloops when the heretic dies
 */
/datum/eldritch_knowledge/proc/on_death(mob/user)
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

/**
 * Mansus grasp act
 *
 * Gives addtional effects to mansus grasp spell
 */
/datum/eldritch_knowledge/proc/on_mansus_grasp(atom/target, mob/user, proximity_flag, click_parameters)
	return FALSE


/**
 * Sickly blade act
 *
 * Gives addtional effects to sickly blade weapon
 */
/datum/eldritch_knowledge/proc/on_eldritch_blade(atom/target,mob/user,proximity_flag,click_parameters)
	return

/**
 * Sickly blade distant act
 *
 * Same as [/datum/eldritch_knowledge/proc/on_eldritch_blade] but works on targets that are not in proximity to you.
 */
/datum/eldritch_knowledge/proc/on_ranged_attack_eldritch_blade(atom/target,mob/user,click_parameters)
	return

//////////////
///Subtypes///
//////////////

/datum/eldritch_knowledge/spell
	var/obj/effect/proc_holder/spell/spell_to_add

/datum/eldritch_knowledge/spell/on_gain(mob/user)
	spell_to_add = new spell_to_add
	user.mind.AddSpell(spell_to_add)
	return ..()

/datum/eldritch_knowledge/spell/on_lose(mob/user)
	user.mind.RemoveSpell(spell_to_add)
	return ..()

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

/datum/eldritch_knowledge/summon
	//Mob to summon
	var/mob/living/mob_to_summon

/datum/eldritch_knowledge/summon/on_finished_recipe(mob/living/user, list/atoms, loc)
	//we need to spawn the mob first so that we can use it in pollCandidatesForMob, we will move it from nullspace down the code
	var/mob/living/summoned = new mob_to_summon(loc)
	message_admins("[summoned.name] is being summoned by [user.real_name] in [loc]")
	var/list/mob/dead/observer/candidates = pollCandidatesForMob("Do you want to play as [summoned.real_name]", ROLE_HERETIC, FALSE, 100, summoned)
	if(!LAZYLEN(candidates))
		to_chat(user,span_warning("No ghost could be found..."))
		qdel(summoned)
		return FALSE
	var/mob/dead/observer/picked_candidate = pick(candidates)
	log_game("[key_name_admin(picked_candidate)] has taken control of ([key_name_admin(summoned)]), their master is [user.real_name]")
	summoned.ghostize(FALSE)
	summoned.key = picked_candidate.key
	summoned.mind.add_antag_datum(/datum/antagonist/heretic_monster)
	var/datum/antagonist/heretic_monster/heretic_monster = summoned.mind.has_antag_datum(/datum/antagonist/heretic_monster)
	var/datum/antagonist/heretic/master = user.mind.has_antag_datum(/datum/antagonist/heretic)
	heretic_monster.set_owner(master)
	return TRUE

//Ascension knowledge
/datum/eldritch_knowledge/final

	var/finished = FALSE

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

/datum/eldritch_knowledge/final/cleanup_atoms(list/atoms)
	. = ..()
	for(var/mob/living/carbon/human/sacrifices in atoms)
		atoms -= sacrifices
		sacrifices.gib()
