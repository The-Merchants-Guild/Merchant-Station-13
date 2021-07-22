/obj/machinery/ore_refiner/chemical_processor
	name = "chemical processor"
	desc = "A machine for doing various chemical actions to ore."
	valid_phases = list(
		/datum/material/gold 		= list(1),
		/datum/material/silver 		= list(1),
		/datum/material/titanium	= list(1),
		/datum/material/bluespace	= list(0))
	var/used_reagents = list(
		/datum/material/gold 		= list(/datum/reagent/toxin/cyanide),
		/datum/material/silver 		= list(/datum/reagent/toxin/cyanide),
		/datum/material/titanium	= list(/datum/reagent/chlorine),
		/datum/material/bluespace	= list(/datum/reagent/drug/space_drugs))
	var/chooming_delay = 4 SECONDS

/obj/machinery/ore_refiner/chemical_processor/Initialize()
	. = ..()
	overlays += mutable_appearance('icons/obj/drilling.dmi', "chem")

/obj/machinery/ore_refiner/chemical_processor/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/plumbing/)

/obj/machinery/ore_refiner/chemical_processor/process(delta_time)
	if (machine_stat & (BROKEN))
		return
	if (!COOLDOWN_FINISHED(src, processing_cooldown))
		return
	for (var/obj/item/raw_ore/O in processing)
		if (reagents.has_reagent(used_reagents[]))
		COOLDOWN_START(src, processing_cooldown, chooming_delay)
		processing -= O
		processed += O
		break
	. = ..()
