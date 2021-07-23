/obj/machinery/ore_sorter
	name = "Nice of the princess to invite us for a picnic, eh luigi?"
	icon_state = "sorter"
	icon = 'icons/obj/drilling.dmi'
	var/list/sort_types = list()
	var/list/sorted_materials = list()

/obj/machinery/ore_sorter/Initialize()
	. = ..()
	var/list/E = list()
	E["Input"] = list(object = /obj/machinery/ore_sorter_input, image = image(icon = 'icons/obj/drilling.dmi', icon_state = "input-icon"), amount = 1)
	for (var/T in sort_types)
		E[T] = list(object = /obj/machinery/ore_sorter_output, image = image(icon = 'icons/obj/drilling.dmi', icon_state = "[T]-icon"), amount = 1)
	AddComponent(/datum/component/extensible_machine, E, 3 SECONDS, TOOL_CROWBAR)
	RegisterSignal(src, COMSIG_EXTEND_MACHINE, .proc/handle_extension)
	RegisterSignal(src, COMSIG_EXTENSION_BROKE, .proc/handle_extension_destruction)

/obj/machinery/ore_sorter/proc/handle_extension(datum/source, obj/extension, mob/user)
	SIGNAL_HANDLER

/obj/machinery/ore_sorter/proc/handle_extension_destruction(datum/source, obj/extension)
	SIGNAL_HANDLER

/obj/machinery/ore_sorter_output
	name = "ore sorter output"
	icon = 'icons/obj/drilling.dmi'

/obj/machinery/ore_sorter_input
	name = "ore sorter input"
	icon = 'icons/obj/drilling.dmi'

/obj/machinery/ore_sorter/gravity
	name = "Gravity sorter"
	sort_types = list("Heavy", "Light", "Medium")
	sorted_materials = list("Heavy" = list(/datum/material/uranium, /datum/material/gold, /datum/material/silver), "Light" = list(/datum/material/titanium), "Medium" = null)

/obj/machinery/ore_sorter/radiation
	name = "Radiation sorter"
	sort_types = list("Radioactive", "Unsorted")
	sorted_materials = list("Radioactive" = list(/datum/material/uranium), "Unsorted" = null)

/obj/machinery/ore_sorter/xray
	name = "X-ray sorter"
	sort_types = list("Teleporting", "X-ray", "Unsorted")
	sorted_materials = list("Teleporting" = list(/datum/material/bluespace), "X-ray" = list(/datum/material/bluespace), "Unsorted" = null)
