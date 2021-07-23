/obj/machinery/ore_refiner/furnace
	name = "ore heater"
	desc = "A machine used to heat or melt ores."
	use_power = IDLE_POWER_USE
	idle_power_usage = 4000
	valid_phases = list(
		/datum/material/diamond		= list(0),
		/datum/material/bluespace	= list(1),
		/datum/material/titanium 	= list(2))
	var/mat_requirements = list(
		/datum/material/diamond		= list(40000, 2 SECONDS),
		/datum/material/bluespace	= list(100, 10 SECONDS),
		/datum/material/titanium 	= list(1000, 5 SECONDS))
	var/obj/item/raw_ore/processing_ore
	var/power_per_process = 1000
	var/heating_delay = 2 SECONDS

/obj/machinery/ore_refiner/crusher/Initialize()
	. = ..()
	overlays += mutable_appearance('icons/obj/drilling.dmi', "furnace")

/obj/machinery/ore_refiner/furnace/proc/ore_processed()
	processing -= processing_ore
	processed += processing_ore

/obj/machinery/ore_refiner/furnace/process(delta_time)
	. = ..()
	if (machine_stat & (BROKEN|NOPOWER))
		return
	if (processing_ore)
		use_power(mat_requirements[processing_ore.ore_material][1])
		return
	if (!COOLDOWN_FINISHED(src, processing_cooldown))
		return
	for (var/obj/item/raw_ore/O in processing)
		use_power(power_per_process)
		COOLDOWN_START(src, processing_cooldown, heating_delay)
		addtimer(CALLBACK(src, .proc/ore_processed), mat_requirements[processing_ore.ore_material][2])
		processing_ore = O
		break
