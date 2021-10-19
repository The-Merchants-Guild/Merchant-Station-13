/obj/machinery/ore_refiner/distiller
	name = "industrial distiller"
	desc = "A machine used to heat or melt ores."
	use_power = IDLE_POWER_USE
	idle_power_usage = 4000
	valid_phases = list(
		/datum/material/plasma		= list(0),
		/datum/material/titanium 	= list(2))
	var/mat_requirements = list(
		/datum/material/plasma		= list(4000, 2 SECONDS),
		/datum/material/titanium 	= list(1000, 5 SECONDS))
	var/datum/material/contaminant
	var/power_per_heat = 100
	var/heat = 0

/obj/machinery/ore_refiner/distiller/input_process(obj/item/raw_ore/inp)
	return inp.ore_material == contaminant

/obj/machinery/ore_refiner/distiller/process(delta_time)
	. = ..()
	if (machine_stat & (BROKEN|NOPOWER))
		return
	if (contaminant && mat_requirements[contaminant][1] > heat)
		use_power(power_per_heat)
		heat++
		return
	heat--
	for (var/obj/item/raw_ore/O in processing)
		heat -= O.mat_amount / 100
		processing -= O
		processed += O
		break
