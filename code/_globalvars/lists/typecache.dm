//please store common type caches here.
//type caches should only be stored here if used in mutiple places or likely to be used in mutiple places.

//Note: typecache can only replace istype if you know for sure the thing is at least a datum.

GLOBAL_LIST_INIT(typecache_mob, typecacheof(/mob))

GLOBAL_LIST_INIT(typecache_living, typecacheof(/mob/living))

GLOBAL_LIST_INIT(typecache_stack, typecacheof(/obj/item/stack))

GLOBAL_LIST_INIT(typecache_machine_or_structure, typecacheof(list(/obj/machinery, /obj/structure)))

/// A typecache listing structures that are considered to have surfaces that you can place items on that are higher than the floor. This, of course, should be restricted to /atom/movables. This is primarily used for food decomposition code.
GLOBAL_LIST_INIT(typecache_elevated_structures, typecacheof(list(/obj/structure/table,/obj/structure/rack,/obj/machinery/conveyor,/obj/structure/closet)))

// Not really related but why would you write these like the abomination above? It's harder to read for no reason.

GLOBAL_LIST_INIT(no_reagent_message_typecache, typecacheof(list(
	/obj/effect/particle_effect,
	/obj/effect/decal/cleanable,
	/mob,
	/obj/item/reagent_containers/food,
	/obj/item/toy,
	/obj/item/grown,
	/obj/machinery/duct,
	/obj/machinery/plumbing)
))

// Don't do state change in these atoms
GLOBAL_LIST_INIT(no_reagent_statechange_typecache, typecacheof(list(
	/obj/effect/particle_effect/water,
	/obj/effect/decal/cleanable,
	/obj/effect/particle_effect/smoke/chem/smoke_machine,
	/mob)
))

GLOBAL_LIST_INIT(statechange_reagent_blacklist, typecacheof(list(
	/datum/reagent/oxygen,
	/datum/reagent/nitrogen,
	/datum/reagent/nitrous_oxide,
	/datum/reagent/toxin/plasma,
	/datum/reagent/smoke_powder,
	/datum/reagent/carbondioxide)
))

GLOBAL_LIST_INIT(vaporchange_reagent_blacklist, typecacheof(list(
	/datum/reagent/lube,
	/datum/reagent/clf3,
	/datum/reagent/mutationtoxin)
))

GLOBAL_LIST_INIT(solidchange_reagent_blacklist, typecacheof(list())) //for future use

GLOBAL_LIST_INIT(statechange_turf_blacklist, typecacheof(list(
	/turf/open/space,
	/turf/open/chasm,
	/turf/open/lava)
))
