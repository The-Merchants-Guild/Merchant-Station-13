/obj/machinery/ore_refiner/grinder
	name = "ore grinder"
	desc = "A machine that uses industrial diamond grinding wheels to break down ore."
	use_power = IDLE_POWER_USE
	idle_power_usage = 2000
	valid_phases = list(
		/datum/material/iron		= list(0),
		/datum/material/gold 		= list(0),
		/datum/material/silver 		= list(0),
		/datum/material/titanium	= list(0, 3))
	var/grinding_delay = 1 SECONDS
	var/power_per_process = 1000

/obj/machinery/ore_refiner/grinder/Initialize()
	. = ..()
	overlays += mutable_appearance('icons/obj/drilling.dmi', "grinder")

/obj/machinery/ore_refiner/grinder/process(delta_time)
	if (machine_stat & (BROKEN|NOPOWER))
		return
	if (!COOLDOWN_FINISHED(src, processing_cooldown))
		return
	for (var/obj/item/raw_ore/O in processing)
		use_power(power_per_process)
		COOLDOWN_START(src, processing_cooldown, grinding_delay)
		processing -= O
		processed += O
		break
	. = ..()
