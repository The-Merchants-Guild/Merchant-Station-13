/datum/deathmatch_map
	var/name = "If you see this someone is did a mistake and is going to die."
	var/desc = ""
	var/min_players = 1
	var/max_players = 2 // TODO: make this automatic.
	var/list/allowed_loadouts = list()
	var/map_path = ""
	var/datum/map_template/template

/datum/deathmatch_map/New()
	. = ..()
	if (!map_path)
		return qdel(src)
	template = new(path = map_path)
/datum/deathmatch_map/ragecage
	name = "Ragecage"
	desc = "Fun for the whole family, the good old ragecage!"
	allowed_loadouts = list(/datum/deathmatch_loadout/assistant)
	map_path = "_maps/map_files/DM/ragecage.dmm"

/datum/deathmatch_map/maintenance
	name = "Maintenance"
	desc = "Maint"
	min_players = 4
	max_players = 8
	allowed_loadouts = list(/datum/deathmatch_loadout/assistant)
