#define ORE_PER_YIELD_PERCENT 20000

/datum/ore_vein
	var/yield
	var/datum/material/material
	var/active_drill_count = 0

/datum/ore_vein/proc/get_drilling_efficiency()
	return (1 / sqrt(active_drill_count)) * yield

/datum/ore_vein/proc/lower_yield(amount_mined)
	if (yield <= 0.1) // Yield doesn't go lower than 10%
		return
	yield -= amount_mined / ORE_PER_YIELD_PERCENT

#undef ORE_PER_YIELD_PERCENT
