GLOBAL_VAR(deathmatch_game)

/datum/deathmatch_controller
	var/list/map_locations
	var/list/used_locations
	var/list/datum/deathmatch_lobby/lobbies = list()
	var/list/datum/deathmatch_map/maps
	var/list/datum/deathmatch_loadout/loadouts

/datum/deathmatch_controller/New()
	. = ..()
	if (GLOB.deathmatch_game)
		qdel(src)
		return
	GLOB.deathmatch_game = src
	maps = subtypesof(/datum/deathmatch_map)
	loadouts = subtypesof(/datum/deathmatch_loadout)

/datum/deathmatch_controller/proc/create_new_lobby(mob/dead/observer/player)
	lobbies[player.ckey] = new /datum/deathmatch_lobby(player)

/datum/deathmatch_controller/ui_state(mob/user)
	return GLOB.observer_state

/datum/deathmatch_controller/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, null)
	if(!ui)
		ui = new(user, src, "DeathmatchPanel")
		ui.open()

/datum/deathmatch_controller/ui_data(mob/user)
	. = ..()
	.["lobbies"] = list()
	.["hosting"] = FALSE
	for (var/ckey in lobbies)
		var/datum/deathmatch_lobby/L = lobbies[ckey]
		if (user.ckey == ckey)
			.["hosting"] = TRUE
		.["lobbies"] += list(list(
			name = ckey,
			players = L.players.len,
			max_players = initial(L.map.max_players),
			map = initial(L.map.name),
			playing = L.playing
		))

/datum/deathmatch_controller/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(. || !isobserver(usr))
		return
	switch (action)
		if ("host")
			if (lobbies[usr.ckey])
				return
			create_new_lobby(usr)
		if ("join")
			if (lobbies[usr.ckey] || !lobbies[params["id"]])
				return
			lobbies[params["id"]].join()
		if ("spectate")
			if (lobbies[usr.ckey] || !lobbies[params["id"]] || !lobbies[params["id"]].playing)
				return
			lobbies[params["id"]].spectate()
