/datum/deathmatch_map
	var/name = "If you see this someone is did a mistake and is going to die."
	var/desc = ""
	var/min_players = 2
	var/max_players = 2
	var/list/allowed_loadouts = list()
	var/map_path = ""

/datum/deathmatch_map/ragecage
	name = "Ragecage"
	desc = "Fun for the whole family, the good old ragecage!"
	allowed_loadouts = list(/datum/deathmatch_loadout/assistant)
	map_path = "_maps/map_files/DM/ragecage.dmm"
