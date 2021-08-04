/datum/deathmatch_lobby
	var/datum/deathmatch_controller/game

	var/host
	var/list/players = list()
	var/list/observers = list()
	var/datum/deathmatch_map/map
	var/datum/deathmatch_map_loc/location
	var/playing = FALSE
	var/ready_count
	var/list/loadouts
	var/datum/deathmatch_loadout/default_loadout

/datum/deathmatch_lobby/New(mob/player)
	. = ..()
	if (!player)
		return qdel(src)
	host = player.ckey
	game = GLOB.deathmatch_game
	map = game.maps[pick(game.maps)]
	if (map.allowed_loadouts)
		loadouts = map.allowed_loadouts
	else
		loadouts = game.loadouts
	default_loadout = loadouts[1]
	add_player(player, default_loadout, TRUE)
	ui_interact(player)

/datum/deathmatch_lobby/Destroy(force, ...)
	. = ..()
	for (var/K in players)
		remove_player(K)
	players = null
	for (var/K in observers)
		var/list/L = observers[K]
		L.Cut()
		observers.Remove(K)
	observers = null
	map = null
	location = null
	loadouts = null
	default_loadout = null

/datum/deathmatch_lobby/proc/start_game()
	location = game.reserve_location(map)
	if (!location)
		return FALSE
	var/list/spawns = game.load_location(location)
	if (!spawns)
		game.clear_location(location)
		location = null
		return FALSE
	for (var/K in players)
		var/mob/dead/observer/O = players[K]["mob"]
		if (!O || !O.client)
			remove_player(K)
			continue
		var/S = pick_n_take(spawns)
		O.forceMove(get_turf(S))
		qdel(S)
		var/datum/deathmatch_loadout/L = players[K]["loadout"]
		L = new L // agony
		var/mob/living/carbon/human/H = O.change_mob_type(/mob/living/carbon/human, delete_old_mob = TRUE)
		L.equip(H)
		map.map_equip(H)
		RegisterSignal(H, COMSIG_LIVING_DEATH, .proc/player_died)
		to_chat(H.client, span_reallybig("GO!"))
		players[K]["mob"] = H
	for (var/S in spawns)
		qdel(S)
	for (var/K in observers)
		var/mob/M = observers[K]["mob"]
		M.forceMove(location.location)
	playing = TRUE
	return TRUE

/datum/deathmatch_lobby/proc/end_game()
	if (!location)
		return
	var/winner
	for (var/K in players)
		if (!winner) // While there should only be a single player remaining, someone might proccall this so.
			winner = K
		var/mob/living/L = players[K]["mob"]
		to_chat(L.client, span_reallybig("THE GAME HAS ENDED.<BR>THE WINNER IS: [winner ? winner : "no one"]."))
		players[K]["mob"] = null
		UnregisterSignal(L, COMSIG_LIVING_DEATH)
		qdel(L)
	for (var/K in observers)
		var/mob/observer = observers[K]["mob"]
		to_chat(observer.client, span_reallybig("THE GAME HAS ENDED.<BR>THE WINNER IS: [winner ? winner : "no one"]."))
	game.clear_location(location)
	game.remove_lobby(host)

/datum/deathmatch_lobby/proc/player_died(mob/living/player)
	for (var/K in players)
		var/mob/P = players[K]["mob"]
		to_chat(P.client, span_reallybig("[player.ckey] HAS DIED.<br>[players.len-1] REMAINING."))
	for (var/K in observers)
		var/mob/P = observers[K]["mob"]
		to_chat(P.client, span_reallybig("[player.ckey] HAS DIED.<br>[players.len-1] REMAINING."))
	players.Remove(player.ckey)
	add_observer(player.ghostize(), (host == player.ckey))
	player.dust(TRUE, TRUE, TRUE)
	if (players.len <= 1)
		end_game()
		return

/datum/deathmatch_lobby/proc/add_observer(mob/_mob, _host = FALSE)
	if (players[_mob.ckey])
		CRASH("Tried to add [_mob.ckey] as an observer while being a player.")
	observers[_mob.ckey] = list(mob = _mob, host = FALSE)

/datum/deathmatch_lobby/proc/add_player(mob/_mob, _loadout, _host = FALSE)
	players[_mob.ckey] = list(mob = _mob, host = _host, ready = FALSE, loadout = _loadout)

/datum/deathmatch_lobby/proc/remove_player(ckey)
	var/list/L = players[ckey]
	ready_count -= L["ready"]
	L.Cut()
	players[ckey] = null
	players.Remove(ckey)

/datum/deathmatch_lobby/proc/join(mob/player)
	if (playing || !player)
		return
	if (players.len >= map.max_players)
		add_observer(player)
	else
		add_player(player, default_loadout)
	ui_interact(player)

/datum/deathmatch_lobby/proc/spectate(mob/player)
	if (!playing || !location || !player)
		return
	if (!observers[player.ckey])
		add_observer(player)
	player.forceMove(location.location)

/datum/deathmatch_lobby/proc/change_map(path)
	if (!path || !game.maps[path])
		return
	map = game.maps[path]
	// TODO: move extra players to observer when switching map.
	if (map.allowed_loadouts)
		var/list/los = map.allowed_loadouts
		loadouts = los
	else
		loadouts = game.loadouts
	for (var/K in players)
		if (!(players[K]["loadout"] in loadouts))
			players[K]["loadout"] = loadouts[1]

/datum/deathmatch_lobby/ui_state(mob/user)
	return GLOB.observer_state

/datum/deathmatch_lobby/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, null)
	if(!ui)
		ui = new(user, src, "DeathmatchLobby")
		ui.open()

/datum/deathmatch_lobby/ui_static_data(mob/user)
	. = ..()
	.["maps"] = list()
	for (var/P in game.maps)
		var/datum/deathmatch_map/M = game.maps[P]
		.["maps"][M.name] = list(desc = M.desc, min_players = M.min_players, max_players = M.max_players)

/datum/deathmatch_lobby/ui_data(mob/user)
	. = ..()
	.["loadouts"] = list()
	for (var/L in loadouts)
		var/datum/deathmatch_loadout/DML = L
		.["loadouts"][L] = list(name = initial(DML.name), desc = initial(DML.desc))
	.["map"] = list()
	.["map"]["name"] = map.name
	.["map"]["desc"] = map.desc
	.["map"]["min_players"] = map.min_players
	.["map"]["max_players"] = map.max_players
	.["players"] = list()
	for (var/K in players)
		.["players"][K] = players[K]
		var/datum/deathmatch_loadout/L = players[K]["loadout"]
		.["players"][K]["loadout"] = "[L]"
		.["players"][K]["self"] = (user.ckey == K)
	.["observers"] = list()
	for (var/K in observers)
		.["observers"][K] = observers[K]

/datum/deathmatch_lobby/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(. || !isobserver(usr))
		return
	switch(action)
		if ("start_game")
			if (usr.ckey != host)
				return
			if (map.min_players > players.len)
				to_chat(usr, span_warning("Not enough players to start yet."))
				return
			start_game()
		if ("leave_game")
			if (playing)
				return
			if (host == usr.ckey)
				var/total_count = players.len + observers.len
				if (total_count <= 1) // <= just in case.
					game.remove_lobby(host)
					ui.close()
					game.ui_interact(usr)
					return
				else
					if (players[usr.ckey] && players.len <= 1)
						for (var/K in observers)
							if (host == K)
								continue
							host = K
							observers[K]["host"] = TRUE
							break
					else
						for (var/K in players)
							if (host == K)
								continue
							host = K
							players[K]["host"] = TRUE
							break
					game.passoff_lobby(usr.ckey, host)
			remove_player(usr.ckey)
			ui.close()
			game.ui_interact(usr)
		if ("ready")
			players[usr.ckey]["ready"] ^= 1 // Toggle.
			ready_count += (players[usr.ckey]["ready"] * 2) - 1 // scared?
			if (ready_count >= players.len && players.len >= map.min_players)
				start_game()
