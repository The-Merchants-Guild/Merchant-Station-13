/obj/machinery/ore_converter
	name = "ore converter"
	desc = "Turns raw ore into usable materials."
	icon_state = "converter"
	icon = 'icons/obj/drilling.dmi'
	density = TRUE
	var/static/list/datum/material/conversion_yield = list(
		/datum/material/iron		= list(0.25, 0.6, 			1),
		/datum/material/silver		= list(0.25, 0.4, 0.3, 0.7, 1),
		/datum/material/gold		= list(0.25, 0.5, 			1),
		/datum/material/titanium	= list(0.25, 0.3, 0.6, 		1),
		/datum/material/uranium		= list(0.25, 0.6, 			1),
		/datum/material/plasma		= list(0.25,				1),
		/datum/material/bluespace	= list(0.25, 0.7, 			1),
		/datum/material/diamond		= list(0.25, 0.4, 			1),
	)
	var/list/datum/material/material_amount = list()

/obj/machinery/ore_converter/ComponentInitialize()
	AddComponent(/datum/component/extensible_machine, list(
		"Ore input" = list(object = /obj/machinery/ore_converter_input, image = image(icon = 'icons/obj/drilling.dmi', icon_state = "input-icon"), amount = 1),
		"Material output" = list(object = /obj/machinery/ore_converter_output, image = image(icon = 'icons/obj/drilling.dmi', icon_state = "output-icon"), amount = 1)
	), 3 SECONDS, TOOL_CROWBAR)

/obj/machinery/ore_converter/proc/handle_input(obj/item/raw_ore/inp)
	if (!inp.ore_material)
		return
	material_amount[inp.ore_material] += inp.mat_amount * conversion_yield[inp.ore_material][inp.process_phase]

/obj/machinery/ore_converter_output
	name = "converter output"
	desc = "A thing"
	icon_state = "refiner-out"
	icon = 'icons/obj/drilling.dmi'
	var/obj/machinery/ore_converter/parent

/obj/machinery/ore_converter_output/Initialize(mapload, _parent, _output_type)
	. = ..()
	if (!_parent)
		return INITIALIZE_HINT_QDEL
	parent = _parent
	RegisterSignal(get_turf(src), list(COMSIG_ATOM_CREATED, COMSIG_ATOM_ENTERED), .proc/handle_output)

/obj/machinery/ore_converter_output/proc/handle_output(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	if (!istype(AM, /obj/structure/material_storage))
		return
	var/obj/structure/material_storage/MS = AM
	for (var/M in parent.material_amount)
		MS.contained_materials[M] += parent.material_amount[M]

/obj/machinery/ore_converter_input
	name = "converter input"
	desc = "A thing"
	icon_state = "refiner-in"
	icon = 'icons/obj/drilling.dmi'
	var/obj/machinery/ore_refiner/parent

/obj/machinery/ore_converter_input/Initialize(mapload, _parent)
	. = ..()
	if (!_parent)
		return INITIALIZE_HINT_QDEL
	parent = _parent
	RegisterSignal(get_turf(src), list(COMSIG_ATOM_CREATED, COMSIG_ATOM_ENTERED), .proc/handle_input)

/obj/machinery/ore_converter_input/proc/handle_input(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	if (!istype(AM, /obj/item/raw_ore))
		return
	parent.handle_input(AM)
