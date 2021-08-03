/datum/deathmatch_map
	var/name = "If you see this someone is did a mistake and is going to die."
	var/desc = ""
	var/min_players = 2
	var/max_players = 2 // TODO: make this automatic.
	var/list/allowed_loadouts = list()
	var/map_path = ""
	var/datum/map_template/template

/datum/deathmatch_map/New()
	. = ..()
	if (!map_path)
		stack_trace("MISSING MAP PATH!")
		return qdel(src)
	template = new(path = map_path)
/datum/deathmatch_map/ragecage
	name = "Ragecage"
	desc = "Fun for the whole family, the classic ragecage."
	allowed_loadouts = list(/datum/deathmatch_loadout/assistant)
	map_path = "_maps/map_files/DM/ragecage.dmm"

/datum/deathmatch_map/maintenance
	name = "Maintenance"
	desc = "WRITE ME"
	min_players = 4
	max_players = 8
	allowed_loadouts = list(/datum/deathmatch_loadout/assistant)
	map_path = "_maps/map_files/DM/maint.dmm"

/datum/deathmatch_map/osha_violator
	name = "OSHA Violator"
	desc = "WRITE ME"
	min_players = 2
	max_players = 8
	allowed_loadouts = list(/datum/deathmatch_loadout/assistant)
	map_path = "_maps/map_files/DM/OSHA_Violator.dmm"
