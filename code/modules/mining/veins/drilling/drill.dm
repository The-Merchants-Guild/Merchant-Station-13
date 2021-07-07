#define PURITY_DEVIATION 0.1
#define AMOUNT_MEAN 1000
#define AMOUNT_STD 200

/obj/machinery/ore_drill
	name = "Ore Drill"
	desc = "A large device designed for mining ore veins in lavaland."
	processing_flags = START_PROCESSING_ON_INIT

	var/mining_delay = 15
	COOLDOWN_DECLARE(mining_cooldown)
	var/turf/open/floor/plating/asteroid/basalt/lava_land_surface/ore/ore

/obj/machinery/ore_drill/Initialize()
	. = ..()
	if (!istype(loc, /turf/open/floor/plating/asteroid/basalt/lava_land_surface/ore))
		return
	ore = loc

/obj/machinery/ore_drill/process(delta_time)
	if (!ore)
		return PROCESS_KILL
	if (!COOLDOWN_FINISHED(src, mining_cooldown))
		return
	COOLDOWN_START(src, mining_cooldown, mining_delay)
	var/obj/item/ore_rock/O = new /obj/item/ore_rock(loc)
	O.mat_purity = ore.mat_purity + rand(-PURITY_DEVIATION, PURITY_DEVIATION)
	O.mat_amount = gaussian(AMOUNT_MEAN, AMOUNT_STD)
	return

/obj/machinery/ore_drill_box
	name = "Ore Drill"

#undef PURITY_DEVIATION
#undef AMOUNT_MEAN
#undef AMOUNT_STD
