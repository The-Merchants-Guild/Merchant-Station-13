/obj/machinery/ore_refiner/crusher
	name = "ore crusher"
	desc = "A machine used to break ore to smaller pieces."
	use_power = IDLE_POWER_USE
	idle_power_usage = 2000
	valid_phases = list(
		/datum/material/iron		= list(0),
		/datum/material/gold 		= list(0),
		/datum/material/silver 		= list(0),
		/datum/material/uranium		= list(0),
		/datum/material/titanium	= list(0, 3))
	var/grinding_delay = 1 SECONDS
	var/power_per_process = 1000

/obj/machinery/ore_refiner/crusher/Initialize()
	. = ..()
	overlays += mutable_appearance('icons/obj/drilling.dmi', "crusher")

/obj/machinery/ore_refiner/crusher/process(delta_time)
	. = ..()
	if (machine_stat & (BROKEN|NOPOWER))
		return
	if (!COOLDOWN_FINISHED(src, processing_cooldown))
		return
	for (var/obj/item/raw_ore/O in processing)
		use_power(power_per_process)
		COOLDOWN_START(src, processing_cooldown, grinding_delay)
		playsound(src, 'sound/items/welder.ogg', 50, TRUE)
		processing -= O
		processed += O
		break

/obj/machinery/ore_refiner/crusher/input_process(obj/item/raw_ore/O)
	var/mat = O.ore_material
	if (mat == /datum/material/diamond)
		qdel(O)
		playsound(src, 'sound/weapons/smash.ogg', 100, TRUE) // ouch
		take_damage(round(O.mat_amount * 0.01))
		return FALSE
	else if (mat == /datum/material/bluespace)
		qdel(O)
		playsound(src, "sparks", 100, TRUE)
		return FALSE
	return TRUE
