/obj/machinery/ore_refiner/magnetic_sorter
	name = "magnetic sorter"
	desc = "A machine used to separate magnetic materials."
	use_power = IDLE_POWER_USE
	idle_power_usage = 500
	valid_phases = list(
		/datum/material/iron = list(1)
	)
	var/power_per_process = 1000

/obj/machinery/ore_refiner/magnetic_sorter/process(delta_time)
	. = ..()
	if (machine_stat & (BROKEN|NOPOWER))
		return
	for (var/obj/item/raw_ore/O in processing)
		use_power(power_per_process)
		processing -= O
		processed += O
		break
