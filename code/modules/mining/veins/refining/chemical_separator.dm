/obj/machinery/ore_refiner/chemical_separator
	name = "chemical separator"
	desc = "A machine used to separate materials chemically."
	valid_phases = list(
		/datum/material/silver = list(3),
		/datum/material/gold = list(3)
	)
	var/power_per_process = 1000
	var/processing_delay = 2 SECONDS
	var/list/solids = list(/datum/material/gold)
	var/turf/liquid_output
	var/turf/solid_output
	var/separation_reagent = /datum/reagent/toxin/acid/nitracid

/obj/machinery/ore_refiner/chemical_separator/Initialize()
	. = ..()
	create_reagents(100)

/obj/machinery/ore_refiner/chemical_separator/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/plumbing/demand/south)

/obj/machinery/ore_refiner/chemical_separator/ComponentInitialize()
	AddComponent(/datum/component/extensible_machine, list(
		"Process input" = list(object = /obj/machinery/ore_refiner_input, image = image(icon = 'icons/obj/drilling.dmi', icon_state = "input-icon"), amount = 1),
		"Process liquid output" = list(object = /obj/machinery/ore_refiner_output, image = image(icon = 'icons/obj/drilling.dmi', icon_state = "output-icon"), amount = 1, arguments = list("liquid")),
		"Process solid output" = list(object = /obj/machinery/ore_refiner_output, image = image(icon = 'icons/obj/drilling.dmi', icon_state = "output-icon"), amount = 1, arguments = list("solid"))
	), 3 SECONDS, TOOL_CROWBAR)
	RegisterSignal(src, COMSIG_EXTEND_MACHINE, .proc/handle_extension)
	RegisterSignal(src, COMSIG_EXTENSION_BROKE, .proc/handle_extension_destruction)

/obj/machinery/ore_refiner/chemical_separator/process(delta_time)
	if (liquid_output && solid_output)
		for (var/obj/item/raw_ore/O in processed)
			O.icon_state = "[initial(O.ore_material.name)][++O.process_phase]"
			O.update_appearance()
			if (O.ore_material in solids)
				O.forceMove(solid_output)
			else
				O.forceMove(liquid_output)
			processed -= O
	if (machine_stat & (BROKEN|NOPOWER))
		return
	if (!COOLDOWN_FINISHED(src, processing_cooldown))
		return
	for (var/obj/item/raw_ore/O in processing)
		if (!reagents.has_reagent(separation_reagent, 1))
			continue
		COOLDOWN_START(src, processing_cooldown, processing_delay)
		reagents.remove_reagent(separation_reagent, 1)
		use_power(power_per_process)
		processing -= O
		processed += O
		break

/obj/machinery/ore_refiner/chemical_separator(datum/source, obj/extension, mob/user)
	SIGNAL_HANDLER
	if (istype(extension, /obj/machinery/ore_refiner_output))
		if (extension.output_type == "liquid")
			liquid_output = get_turf(extension)
		else if (extension.output_type == "solid")
			solid_output = get_turf(extension)
		else
			qdel(extension) // wha
