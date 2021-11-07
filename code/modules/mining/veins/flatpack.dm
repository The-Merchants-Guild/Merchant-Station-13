/obj/structure/flatpack
	name = "flatpack"
	icon = 'icons/obj/drilling.dmi'
	icon_state = "flatpack"
	var/contained_object

/obj/structure/flatpack/crowbar_act(mob/living/user, obj/item/tool)
	. = ..()
	user.visible_message(span_notice("[user] starts unpacking the [src]."), span_notice("You start unpacking the [src]."))
	if (!do_after(user, 2 SECONDS, src))
		return FALSE
	tool.play_tool_sound(src)
	if (ispath(contained_object))
		var/O = new contained_object(get_turf(src))
		user.visible_message(span_notice("[user] unpacks the [O]."), span_notice("You unpack the [O]."))
		qdel(src)
		return FALSE
	else if (istype(contained_object, /atom/movable))
		var/atom/movable/AM = contained_object
		AM.forceMove(get_turf(src))
		user.visible_message(span_notice("[user] unpacks the [AM]."), span_notice("You unpack the [AM]."))
		qdel(src)
		return FALSE
	else
		to_chat(user, span_warning("There was nothing inside."))
		qdel(src)
		return FALSE

/obj/structure/flatpack_dispenser
	name = "flatpack dispenser"
	desc = "dispenses flatpacks for different refining machines"
	icon = 'icons/obj/drilling.dmi'
	icon_state = "flatpack"
	density = TRUE
	anchored = TRUE
	var/available_flatpacks = list(
		/obj/machinery/ore_refiner/crusher				= 4,
		/obj/machinery/ore_refiner/furnace				= 4,
		/obj/machinery/ore_refiner/laser_cutter			= 2,
		/obj/machinery/ore_refiner/chemical_processor	= 3,
		/obj/machinery/ore_refiner/magnetic_sorter		= 2,
		/obj/machinery/ore_refiner/chemical_separator	= 3,
		/obj/machinery/ore_refiner/distiller			= 3,
		/obj/machinery/ore_sorter/gravity				= 2,
		/obj/machinery/ore_sorter/radiation				= 2,
		/obj/machinery/ore_sorter/xray					= 2
	)

/obj/structure/flatpack_dispenser/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	var/list/names = list()
	for (var/M in available_flatpacks)
		if (!available_flatpacks[M])
			continue
		var/obj/O = M
		names += initial(O.name)
	var/C = input(user, "Which machine do you want?", "[src]") in names|null
	if (!in_range(src, user) && C)
		return

	for (var/M in available_flatpacks)
		var/obj/O = M
		if (initial(O.name) != C || !available_flatpacks[M])
			continue
		var/obj/structure/flatpack/F = new(get_turf(src))
		F.contained_object = M
		available_flatpacks[M]--
		return

