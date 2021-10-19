/obj/machinery/ore_refiner/laser_cutter
	name = "laser cutter"
	desc = "A machine used to cut material."
	use_power = IDLE_POWER_USE
	idle_power_usage = 1000
	valid_phases = list(
		/datum/material/diamond = list(1)
	)
	var/const/critical_heat = 400 // starts to damage the cutter
	var/const/dangerous_heat = 200 // starts leaking heat to environment
	var/max_cooled = 10
	var/cooling_rate = 0.5
	var/heat_per_process = 5
	var/heat = 0 // magic heat value, doesn't really mean anything.
	var/power_per_process = 10000

/obj/machinery/ore_refiner/laser_cutter/Initialize()
	. = ..()
	create_reagents(100)

/obj/machinery/ore_refiner/laser_cutter/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/plumbing/demand/south)

/obj/machinery/ore_refiner/laser_cutter/process(delta_time)
	. = ..()
	if (reagents.has_reagent(/datum/reagent/water))
		var/heat_cooled = clamp(reagents.get_reagent_amount(/datum/reagent/water) * cooling_rate, heat, max_cooled)
		reagents.remove_reagent(/datum/reagent/water, heat_cooled / cooling_rate)
		heat -= heat_cooled
	if (heat >= dangerous_heat)
		var/turf/T = get_turf(src)
		var/datum/gas_mixture/enviroment = T.return_air()
		var/heat_escape = (heat - dangerous_heat) * cooling_rate
		heat -= heat_escape
		enviroment.temperature += heat_escape / enviroment.heat_capacity()
	if (heat >= critical_heat)
		playsound(src, 'sound/weapons/sear.ogg', 50, TRUE)
		take_damage(heat - critical_heat, BURN)
		return // If heat is critical the machine will not function
	if (machine_stat & (BROKEN|NOPOWER))
		return
	for (var/obj/item/raw_ore/O in processing)
		use_power(power_per_process)
		heat += heat_per_process
		processing -= O
		processed += O
		break
