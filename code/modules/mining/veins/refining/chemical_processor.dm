/obj/machinery/ore_refiner/chemical_processor
	name = "chemical processor"
	desc = "A machine for doing various chemical actions to ore."
	valid_phases = list(
		/datum/material/gold 		= list(1),
		/datum/material/silver 		= list(1, 3),
		/datum/material/titanium	= list(1),
		/datum/material/uranium		= list(1),
		/datum/material/bluespace	= list(0))
	var/used_reagents = list(
		/datum/material/gold 		= list("1" = list(/datum/reagent/toxin/cyanide, 0.002)),
		/datum/material/silver 		= list("1" = list(/datum/reagent/toxin/cyanide, 0.002), "3" = list(/datum/reagent/consumable/salt, 0.002)),
		/datum/material/titanium	= list("1" = list(/datum/reagent/chlorine, 0.004)),
		/datum/material/uranium		= list("1" = list(/datum/reagent/toxin/acid, 0.004)),
		/datum/material/bluespace	= list("0" = list(/datum/reagent/drug/space_drugs, 0.004)))
	var/chooming_delay = 4 SECONDS

/obj/machinery/ore_refiner/chemical_processor/Initialize()
	. = ..()
	create_reagents(500)

/obj/machinery/ore_refiner/chemical_processor/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/plumbing/demand/south)

/obj/machinery/ore_refiner/chemical_processor/process(delta_time)
	. = ..()
	if (machine_stat & (BROKEN))
		return
	if (!COOLDOWN_FINISHED(src, processing_cooldown))
		return
	for (var/obj/item/raw_ore/O in processing)
		var/reag = used_reagents[O.ore_material]["[O.process_phase]"]
		if (!reagents.has_reagent(reag[1], O.mat_amount * reag[2]))
			continue
		COOLDOWN_START(src, processing_cooldown, chooming_delay)
		reagents.remove_reagent(reag[0], O.mat_amount * reag[1])
		playsound(src, 'sound/weapons/sear.ogg', 50, TRUE)
		processing -= O
		processed += O
		break
