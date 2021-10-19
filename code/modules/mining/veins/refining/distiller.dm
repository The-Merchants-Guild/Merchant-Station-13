/obj/machinery/ore_refiner/distiller
	name = "industrial distiller"
	desc = "A machine used to heat or melt ores."
	use_power = IDLE_POWER_USE
	idle_power_usage = 4000
	valid_phases = list(
		/datum/material/plasma		= list(0),
		/datum/material/titanium 	= list(2))
	var/mat_requirements = list(
		/datum/material/plasma		= 4000,
		/datum/material/titanium 	= 1000)
	var/datum/material/contaminant
	var/power_per_heat = 100
	var/heat = 0

/obj/machinery/ore_refiner/distiller/input_process(obj/item/raw_ore/inp)
	if (inp.ore_material != contaminant)
		playsound(src,'sound/machines/terminal_error.ogg', 50, TRUE)
		return FALSE
	if (!contaminant)
		contaminant = inp.ore_material
	return TRUE

/obj/machinery/ore_refiner/distiller/process(delta_time)
	. = ..()
	if (machine_stat & (BROKEN|NOPOWER))
		return
	if (contaminant && mat_requirements[contaminant] > heat)
		use_power(power_per_heat)
		heat++
		return
	heat--
	for (var/obj/item/raw_ore/O in processing)
		heat -= O.mat_amount / 100
		processing -= O
		processed += O
		break
