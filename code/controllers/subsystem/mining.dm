// Yield is the percentage of a constant amount that a drill outputs.
#define YIELD_AVERAGE 1
#define YIELD_DEVIATION 2

// This is hardcoded until there is a need for it to not be hardcoded.
#define STARTING_POINT_X 4
#define STARTING_POINT_Y 4
#define STARTING_MATERIAL /datum/material/iron

SUBSYSTEM_DEF(mining)
	name = "Mining"

	var/const/grid_size = 15
	var/vein_grids = list()
	var/gwm_x
	var/gwm_y

	var/const/repeats = 2
	var/list/datum/material/types = list(
		/datum/material/iron = list(0.7, 0.4),
		/datum/material/plasma = list(0.8, 0.4),
		/datum/material/silver = list(0.6, 0.3),
		/datum/material/gold = list(0.5, 0.3),
		/datum/material/titanium = list(0.4, 0.3),
		/datum/material/uranium = list(0.4, 0.3),
		/datum/material/diamond = list(0.3, 0.2),
		/datum/material/bluespace = list(0.2, 0.1)
	)
	var/datum/ore_vein/veins = list()

	var/list/drills = list()

/datum/controller/subsystem/mining/Initialize(timeofday)
	if (initialized)
		return
	// Lets fucking GOOOOOOOO!!!
	gwm_x = grid_size / world.maxx
	gwm_y = grid_size / world.maxx
	InitializeVeinGrid()
	..()

/datum/controller/subsystem/mining/proc/InitializeVeinGrid()
	var/list/datum/space_level/mining_levels = SSmapping.levels_by_trait(ZTRAIT_MINING)
	var/datum/ore_vein/current_vein
	var/list/vein_types = list()

	for (var/M in types)
		vein_types += M

	for (var/z in mining_levels)
		var/curr_grid = new/list(grid_size, grid_size)
		vein_grids["[z]"] = curr_grid // I really hate BYOND assoc lists.

		var/curr_loop = 1
		var/list/edges = list()
		var/list/processing = list(list(STARTING_POINT_X, STARTING_POINT_Y))
		var/list/missing_types = vein_types.Copy() - STARTING_MATERIAL
		current_vein = CreateVein(STARTING_MATERIAL)
		curr_grid[STARTING_POINT_X][STARTING_POINT_Y] = current_vein
		while (TRUE)
			if (!processing.len)
				break

			for (var/list/loc in processing.Copy())
				for (var/x in -1 to 1)
					for (var/y in -1 to 1)
						if (x == 0 && y == 0)
							continue
						var/dx = loc[1] + x
						var/dy = loc[2] + y
						// damn this is ugly.
						if (dx < 1 || dx > grid_size || dy < 1 || dy > grid_size)
							continue
						if (curr_grid[dx][dy])
							continue
						curr_grid[dx][dy] = current_vein
						// no duplication checking as it would likely be slower than just dealing with duplicates.
						processing += list(list(dx, dy))
				processing -= list(loc)

			if (curr_loop < repeats)
				curr_loop++
				continue
			curr_loop = 1

			for (var/list/loc in processing)
				for (var/x in -1 to 1)
					for (var/y in -1 to 1)
						if (x == 0 && y == 0)
							continue
						var/dx = loc[1] + x
						var/dy = loc[2] + y
						if (dx < 1 || dx > grid_size || dy < 1 || dy > grid_size)
							continue
						if (curr_grid[dx][dy])
							continue
						// see comment above.
						edges += list(list(dx, dy))
				processing -= list(loc)

			for (var/list/loc in edges)
				if (!curr_grid[loc[1]][loc[2]])
					continue
				edges -= list(loc)

			processing += list(pick_n_take(edges))
			if (!edges.len || !processing.len)
				break
			current_vein = CreateVein(missing_types.len ? pick_n_take(missing_types) : pick(vein_types))

/datum/controller/subsystem/mining/proc/CreateVein(datum/material/type)
	if (!types[type])
		CRASH("Tried to create an ore vein with unsupported material type [type.name].")
	var/datum/ore_vein/vein = new
	vein.material = type
	vein.yield = gaussian(types[type][YIELD_AVERAGE], types[type][YIELD_DEVIATION])
	veins += vein
	return vein

#undef YIELD_AVERAGE
#undef YIELD_DEVIATION
