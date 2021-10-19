/obj/machinery/ore_sorter
	name = "Nice of the princess to invite us for a picnic, eh luigi?"
	icon_state = "sorter"
	icon = 'icons/obj/drilling.dmi'
	density = TRUE
	var/power_per_sort = 1337
	var/turf/default_output
	var/list/turf/outputs = list()
	var/list/sort_types = list()
	var/list/sorted_materials = list()

/obj/machinery/ore_sorter/Initialize()
	. = ..()
	var/list/E = list()
	E["Input"] = list(object = /obj/machinery/ore_sorter_input, image = image(icon = 'icons/obj/drilling.dmi', icon_state = "input-icon"), amount = 1)
	for (var/T in sort_types)
		E[T] = list(object = /obj/machinery/ore_sorter_output, image = image(icon = 'icons/obj/drilling.dmi', icon_state = "[T]-icon"), amount = 1, arguments = list(T))
	AddComponent(/datum/component/extensible_machine, E, 3 SECONDS, TOOL_CROWBAR)
	RegisterSignal(src, COMSIG_EXTEND_MACHINE, .proc/handle_extension)
	RegisterSignal(src, COMSIG_EXTENSION_BROKE, .proc/handle_extension_destruction)

/obj/machinery/ore_sorter/proc/handle_input(obj/item/raw_ore/O)
	if (machine_stat & (BROKEN|NOPOWER))
		return
	for (var/T in sort_types)
		if (!(O.ore_material in sorted_materials[T]))
			continue
		if (!outputs[T]) // ... really? how could you forget to add outputs, smh.
			playsound(src,'sound/machines/terminal_error.ogg', 25, TRUE)
			return
		O.forceMove(outputs[T])
		use_power(power_per_sort)
		return
	if (default_output)
		use_power(power_per_sort)
		O.forceMove(default_output)

/obj/machinery/ore_sorter/proc/handle_extension(datum/source, obj/extension, mob/user)
	SIGNAL_HANDLER
	if (istype(extension, /obj/machinery/ore_sorter_output))
		var/obj/machinery/ore_sorter_output/O = extension
		if (!isnull(sorted_materials[O.sort_type]))
			default_output = get_turf(O)
		outputs[O.sort_type] = get_turf(O)

/obj/machinery/ore_sorter/proc/handle_extension_destruction(datum/source, obj/extension)
	SIGNAL_HANDLER
	if (istype(extension, /obj/machinery/ore_sorter_output))
		var/obj/machinery/ore_sorter_output/O = extension
		if (!isnull(sorted_materials[O.sort_type]))
			default_output = null
		outputs[O.sort_type] = null

/obj/machinery/ore_sorter_output
	name = "ore sorter output"
	icon = 'icons/obj/drilling.dmi'
	var/sort_type = ""

/obj/machinery/ore_sorter_output/Initialize(mapload, _parent, _sort_type)
	. = ..()
	if (!_parent)
		return INITIALIZE_HINT_QDEL
	sort_type = _sort_type

/obj/machinery/ore_sorter_input
	name = "ore sorter input"
	icon = 'icons/obj/drilling.dmi'
	var/obj/machinery/ore_sorter/parent

/obj/machinery/ore_sorter_input/Initialize(mapload, _parent)
	. = ..()
	if (!_parent)
		return INITIALIZE_HINT_QDEL
	parent = _parent
	RegisterSignal(get_turf(src), list(COMSIG_ATOM_CREATED, COMSIG_ATOM_ENTERED), .proc/handle_input)

/obj/machinery/ore_sorter_input/proc/handle_input(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	if (!istype(AM, /obj/item/raw_ore))
		return
	parent.handle_input(AM)

/obj/machinery/ore_sorter/magnetic
	name = "Magnetic sorter"
	power_per_sort = 1000
	sort_types = list("Ferromagnetic", "Nonmagnetic")
	sorted_materials = list("Ferromagnetic" = list(/datum/material/iron), "Nonmagnetic" = null)

/obj/machinery/ore_sorter/gravity
	name = "Gravity sorter"
	power_per_sort = 1000
	sort_types = list("Heavy", "Light", "Medium")
	sorted_materials = list("Heavy" = list(/datum/material/uranium, /datum/material/gold, /datum/material/silver), "Light" = list(/datum/material/titanium), "Medium" = null)

/obj/machinery/ore_sorter/radiation
	name = "Radiation sorter"
	power_per_sort = 5000
	sort_types = list("Radioactive", "Unsorted")
	sorted_materials = list("Radioactive" = list(/datum/material/uranium), "Unsorted" = null)

/obj/machinery/ore_sorter/xray
	name = "X-ray sorter"
	power_per_sort = 10000
	sort_types = list("Teleporting", "X-ray", "Unsorted")
	sorted_materials = list("Teleporting" = list(/datum/material/bluespace), "X-ray" = list(/datum/material/bluespace), "Unsorted" = null)
