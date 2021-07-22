/obj/machinery/ore_refiner
	name = "If you see this, please report this."
	desc = "You aren't supposed to be able to read this, please report this."
	icon_state = "refiner"
	icon = 'icons/obj/drilling.dmi'
	density = TRUE
	COOLDOWN_DECLARE(processing_cooldown)
	var/list/processing = list()
	var/list/processed = list()
	var/list/valid_phases = list()
	var/turf/output_turf

/obj/machinery/ore_refiner/ComponentInitialize()
	AddComponent(/datum/component/extensible_machine, list(
		/obj/machinery/ore_refiner_input = list(image(icon = 'icons/obj/drilling.dmi', icon_state = "input-icon"), 1),
		/obj/machinery/ore_refiner_output = list(image(icon = 'icons/obj/drilling.dmi', icon_state = "output-icon"), 1)
	), 3 SECONDS, TOOL_CROWBAR)
	RegisterSignal(src, COMSIG_EXTEND_MACHINE, .proc/handle_extension)
	RegisterSignal(src, COMSIG_EXTENSION_BROKE, .proc/handle_extension_destruction)

/obj/machinery/ore_refiner/process(delta_time)
	if (!output_turf)
		return
	for (var/obj/item/raw_ore/O in processed)
		O.process_phase++
		O.forceMove(output_turf)

/obj/machinery/ore_refiner/proc/handle_extension(datum/source, obj/extension, mob/user)
	SIGNAL_HANDLER
	if (istype(extension, /obj/machinery/ore_refiner_output))
		output_turf = get_turf(extension)

/obj/machinery/ore_refiner/proc/handle_extension_destruction(datum/source, obj/extension)
	SIGNAL_HANDLER
	if (istype(extension, /obj/machinery/ore_refiner_output))
		output_turf = null

/obj/machinery/ore_refiner/proc/handle_input(datum/source, obj/item/raw_ore/inp)
	SIGNAL_HANDLER
	if (!length(valid_phases))
		return
	if (!valid_phases[inp.ore_material] || !(inp.process_phase in valid_phases[inp.ore_material]))
		playsound(src,'sound/machines/terminal_error.ogg', 50, TRUE)
		inp.forceMove(output_turf)
		return
	inp.forceMove(src)
	processing += inp

/obj/machinery/ore_refiner_output
	name = "refiner output"
	desc = "A thing"
	icon_state = "refiner-out"
	icon = 'icons/obj/drilling.dmi'

/obj/machinery/ore_refiner_input
	name = "refiner input"
	desc = "A thing"
	icon_state = "refiner-in"
	icon = 'icons/obj/drilling.dmi'
	var/obj/machinery/ore_refiner/parent

/obj/machinery/ore_refiner_input/Initialize(mapload, _parent)
	. = ..()
	if (!parent)
		return INITIALIZE_HINT_QDEL
	parent = _parent
	RegisterSignal(get_turf(src), COMSIG_ATOM_ENTERED, .proc/handle_input)

/obj/machinery/ore_refiner_input/proc/handle_input(datum/source, obj/inp)
	SIGNAL_HANDLER
	if (!istype(inp, /obj/item/raw_ore))
		return
	parent.handle_input(inp)
