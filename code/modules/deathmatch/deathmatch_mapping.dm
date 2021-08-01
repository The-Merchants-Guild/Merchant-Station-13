/area/deathmatch
	name = "Deathmatch Arena"
	requires_power = FALSE
	has_gravity = TRUE
	area_flags = UNIQUE_AREA | NO_ALERTS

/area/deathmatch/fullbright
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED

/turf/open/indestructible/deathmatch
	name = "Space"
	icon = 'icons/turf/space.dmi'
	icon_state = "0"
	blocks_air = TRUE

// This just deletes everything that enters it.
/turf/open/indestructible/deathmatch/Enter(atom/movable/mover)
	if (!QDELETED(mover))
		qdel(mover)

/obj/effect/landmark/deathmatch_map_spawn
	name = "Deathmatch Location"
	// Variables used for map size checks.
	var/x_offset
	var/y_offset
	var/width
	var/height

/obj/effect/landmark/deathmatch_player_spawn
	name = "Deathmatch Player Spawner"
