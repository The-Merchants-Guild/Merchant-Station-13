/datum/deathmatch_lobby
	var/mob/host
	var/list/players = list()
	var/datum/deathmatch_map/map
	var/obj/location
	var/playing = FALSE

	var/list/loadouts
	var/datum/deathmatch_loadout/default_loadout
	var/list/chat = list()

/datum/deathmatch_lobby/New(mob/_host)
	. = ..()
	if (!_host)
		return qdel(src)
	host = _host
	var/datum/deathmatch_controller/game = GLOB.deathmatch_game
	map = pick(game.maps)
	if (initial(map.allowed_loadouts))
		var/list/los = initial(map.allowed_loadouts)
		loadouts = los
	else
		loadouts = game.loadouts
	default_loadout = loadouts[1]
	players[host.ckey] = list(host = TRUE, ready = FALSE, loadout = initial(default_loadout.name))

/datum/deathmatch_lobby/proc/start_game()
	return

/datum/deathmatch_lobby/proc/join(mob/player)
	players += list(host = FALSE, ready = FALSE, loadout = initial(default_loadout.name))

/datum/deathmatch_lobby/proc/spectate(mob/player)
	if (!playing || !location)
		return
	player.forceMove(get_turf(location))

/datum/deathmatch_lobby/ui_state(mob/user)
	return GLOB.observer_state

/datum/deathmatch_lobby/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, null)
	if(!ui)
		ui = new(user, src, "DeathmatchLobby")
		ui.open()

/datum/deathmatch_lobby/ui_data(mob/user)
	. = ..()
	.["chat"] = chat
	.["loadouts"] = list()
	for (var/datum/deathmatch_loadout/L in loadouts)
		.["loadouts"][initial(L.name)] = initial(L.desc)
	.["map"]["name"] = initial(map.name)
	.["map"]["desc"] = initial(map.desc)
	for (var/K in players)
		.["players"][K] = players[K]
