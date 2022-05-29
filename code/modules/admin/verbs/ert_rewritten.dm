//if we want an experienced leader, select top X and pick from them
#define ERT_EXPERIENCED_LEADER_CHOOSE_TOP 3

// CENTCOM RESPONSE TEAM

/client/proc/summon_ert_rewritten()
	set category = "Admin.Fun"
	set name = "Make ERT"
	set desc = "Summons an emergency response team, but better"

	new /datum/ert_maker(src)

/datum/ert_maker
	var/static/list/datum/ert/ERT_options = subtypesof(/datum/ert)
	var/list/custom_ERT_options = list()
	var/datum/ert/selected_ERT_option = null // What have we selected?
	var/client/holder // client of whoever is using this datum
	var/teamsize = 5
	var/mission = "Assist the station." // The ERT's mission.
	var/polldesc = "a code !CODER ERROR! Nanotrasen Emergency Response Team." // Ghost popup text
	var/rename_team = "Emergency Response Team" // Custom team name.
	var/enforce_human = TRUE // Enforce human authority?
	var/open_armory = TRUE
	var/random_names = TRUE // Give ERT random names? [Assignment] [Name] i.e. "Security Officer Enderly"
	var/spawn_admin = FALSE // Spawn the admin as a centcom commander to brief the team?
	var/leader_experience = TRUE // Pick experienced leader? (by playtime, I think)
	var/give_cyberimps = FALSE // Give the ERT their default cybernetic implants?

	var/list/preview_images = list()
	var/selected_direction = SOUTH

/datum/ert_maker/New(user)
	if(user)
		setup(user)

/datum/ert_maker/proc/setup(user) // user can be a mob or client
	if (istype(user, /client))
		var/client/user_client = user
		holder = user_client // it's a client, assign to holder
	else
		var/mob/user_mob = user
		holder = user_mob.client

	selected_ERT_option = new /datum/ert/centcom_official // So we have SOMETHING selected
	update_ERT_info()
	ui_interact(holder.mob)

/datum/ert_maker/proc/update_ERT_info()
	teamsize = selected_ERT_option.teamsize
	mission = selected_ERT_option.mission
	polldesc = selected_ERT_option.polldesc
	rename_team = selected_ERT_option.rename_team
	enforce_human = CONFIG_GET(flag/enforce_human_authority)
	open_armory = selected_ERT_option.opendoors
	random_names = selected_ERT_option.random_names
	spawn_admin = selected_ERT_option.spawn_admin
	leader_experience = selected_ERT_option.leader_experience
	give_cyberimps = selected_ERT_option.give_cyberimps
	SStgui.update_user_uis(holder.mob)

/// proc below copy-pasted from old ERT spawner
/datum/ert_maker/proc/equipAntagOnDummy(mob/living/carbon/human/dummy/mannequin, datum/antagonist/antag)
	for(var/I in mannequin.get_equipped_items(TRUE))
		qdel(I)
	if (ispath(antag, /datum/antagonist/ert))
		var/datum/antagonist/ert/ert = antag
		mannequin.equipOutfit(initial(ert.outfit), TRUE)

/datum/ert_maker/proc/generate_ERT_preview_images()
	if(!holder)
		return
	// Set up dummy.
	var/mob/living/carbon/human/dummy/mannequin = new /mob/living/carbon/human/dummy
	// Wait for dummy proc does not work above;
	// freezes TGUI window, leaving white screen

	// We will generate the preview icon
	// and then cache it

	if(preview_images[selected_ERT_option.name])
		return // already generated

	var/datum/antagonist/ert/template = selected_ERT_option.leader_role

	equipAntagOnDummy(mannequin, template)

	COMPILE_OVERLAYS(mannequin)

	var/list/cached_icons = list()
	for(var/direction in GLOB.cardinals) // All four directions, in case the admin wants to rotate his preview
		var/icon/preview = getFlatIcon(mannequin, direction)
		cached_icons[dir2text(direction)] = icon2base64(preview)

	preview_images[selected_ERT_option.name] = cached_icons



/datum/ert_maker/ui_state(mob/user)
	return GLOB.admin_state // generally admin-only thing

/datum/ert_maker/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ErtMaker")
		ui.open()

/datum/ert_maker/ui_static_data(mob/user)
	var/list/data = list()
	data["ERT_options"] = list()

	var/list/ert_options_text = list()
	for (var/option in ERT_options)
		var/datum/ert/ERToption = new option
		if (!istype(ERToption))
			continue
		var/list/ert_data = list()
		ert_data["name"] = ERToption.name
		ert_data["path"] = "[ERToption.type]"
		ert_data["leaderAntag"] = "[ERToption.leader_role]"
		ert_data["memberAntags"] = list()
		for(var/role in ERToption.roles)
			ert_data["memberAntags"] += "[role]"
		ert_options_text += list(ert_data)


	data["ERT_options"] = ert_options_text

	var/datum/ert/custom/customERTdatum = new

	data["custom_datum"] = "[customERTdatum.type]" //path2text
	return data

/datum/ert_maker/ui_data(mob/user)
	var/list/data = list()

	var/list/selected_ERT_data = list()

	selected_ERT_data = list()
	selected_ERT_data["name"] = selected_ERT_option.name
	selected_ERT_data["path"] = "[selected_ERT_option.type]"
	selected_ERT_data["leaderAntag"] = "[selected_ERT_option.leader_role]"
	selected_ERT_data["memberAntags"] = list()
	for(var/role in selected_ERT_option.roles)
		selected_ERT_data["memberAntags"] += "[role]"

	if(!(selected_ERT_option.name in preview_images) || !(dir2text(selected_direction) in preview_images[selected_ERT_option.name]))
		generate_ERT_preview_images()
	selected_ERT_data["previewIcon"] = preview_images[selected_ERT_option.name][selected_direction]

	data["selected_ERT_option"] = selected_ERT_data

	//data["custom_ERT_options"] = // todo: figure out how to do this
	data["teamsize"] = teamsize
	data["mission"] = mission
	data["polldesc"] = polldesc
	data["rename_team"] = rename_team
	data["enforce_human"] = enforce_human
	data["open_armory"] = open_armory
	data["spawn_admin"] = spawn_admin
	data["leader_experience"] = leader_experience
	data["give_cyberimps"] = give_cyberimps
	return data

/datum/ert_maker/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		/// Base ERT stuff ///
		if("pickERT")
			var/selected_path = text2path(params["selectedERT"])

			selected_ERT_option = new selected_path
			update_ERT_info()
			if(!(selected_ERT_option.name in preview_images) || !(dir2text(selected_direction) in preview_images[selected_ERT_option.name]))
				generate_ERT_preview_images()
			. = TRUE
		if("spawnERT") // Mostly copy pasted from the pre-rewrite ERT verb

			var/datum/ert/ERToption = selected_ERT_option // for future custom support


			var/list/spawnpoints = GLOB.emergencyresponseteamspawn
			var/index = 0
			if(spawn_admin)
				if(isobserver(holder.mob))
					var/mob/living/carbon/human/admin_officer = new (spawnpoints[1])
					var/outfit = holder?.prefs?.brief_outfit
					usr.client.prefs.safe_transfer_prefs_to(admin_officer, is_antag = TRUE)
					admin_officer.equipOutfit(outfit)
					admin_officer.key = holder.key
				else
					to_chat(holder, span_warning("Could not spawn you in as briefing officer as you are not a ghost!"))

			var/list/mob/dead/observer/candidates = pollGhostCandidates("Do you wish to be considered for [polldesc]?", "deathsquad")
			var/teamSpawned = FALSE
			if(candidates.len == 0)
				return

			var/numagents = min(teamsize,candidates.len)

			var/datum/team/ert/ert_team = new ERToption.team()
			if(rename_team)
				ert_team.name = rename_team

			var/datum/objective/missionobj = new()
			missionobj.team = ert_team
			missionobj.explanation_text = mission
			missionobj.completed = TRUE
			ert_team.objectives += missionobj
			ert_team.mission = missionobj

			var/mob/dead/observer/earmarked_leader
			var/leader_spawned = FALSE // just in case the earmarked leader disconnects or becomes unavailable, we can try giving leader to the last guy to get chosen

			if(leader_experience)
				var/list/candidate_living_exps = list()
				for(var/i in candidates)
					var/mob/dead/observer/potential_leader = i
					candidate_living_exps[potential_leader] = potential_leader.client?.get_exp_living(TRUE)

				candidate_living_exps = sortList(candidate_living_exps, cmp=/proc/cmp_numeric_dsc)
				if(candidate_living_exps.len > ERT_EXPERIENCED_LEADER_CHOOSE_TOP)
					candidate_living_exps = candidate_living_exps.Cut(ERT_EXPERIENCED_LEADER_CHOOSE_TOP+1) // pick from the top ERT_EXPERIENCED_LEADER_CHOOSE_TOP contenders in playtime
				earmarked_leader = pick(candidate_living_exps)
			else
				earmarked_leader = pick(candidates)

			while(numagents && candidates.len)
				var/spawnloc = spawnpoints[index+1]
				//loop through spawnpoints one at a time
				index = (index + 1) % spawnpoints.len
				var/mob/dead/observer/chosen_candidate = earmarked_leader || pick(candidates) // this way we make sure that our leader gets chosen
				candidates -= chosen_candidate
				if(!chosen_candidate?.key)
					continue

				//Spawn the body
				var/mob/living/carbon/human/ert_operative = new ERToption.mobtype(spawnloc)
				chosen_candidate.client.prefs.safe_transfer_prefs_to(ert_operative, is_antag = TRUE)
				ert_operative.key = chosen_candidate.key

				if(enforce_human || !(ert_operative.dna.species.changesource_flags & ERT_SPAWN)) // Don't want any exploding plasmemes
					ert_operative.set_species(/datum/species/human)

				//Give antag datum
				var/datum/antagonist/ert/ert_antag

				if((chosen_candidate == earmarked_leader) || (numagents == 1 && !leader_spawned))
					ert_antag = new ERToption.leader_role ()
					earmarked_leader = null
					leader_spawned = TRUE
				else
					ert_antag = ERToption.roles[WRAP(numagents,1,length(ERToption.roles) + 1)]
					ert_antag = new ert_antag ()
				ert_antag.random_names = random_names

				ert_operative.mind.add_antag_datum(ert_antag,ert_team)
				ert_operative.mind.set_assigned_role(SSjob.GetJobType(ert_antag.ert_job_path))

				//Logging and cleanup
				log_game("[key_name(ert_operative)] has been selected as an [ert_antag.name]")
				numagents--
				teamSpawned++

			if (teamSpawned)
				message_admins("[polldesc] has spawned with the mission: [mission]")

			//Open the Armory doors
			if(open_armory)
				for(var/obj/machinery/door/poddoor/ert/door in GLOB.airlocks)
					door.open()
					CHECK_TICK
			. = TRUE
		/// Toggles ///
		if("enforceHuman")
			enforce_human = !enforce_human
			SStgui.update_user_uis(holder.mob)
			. = TRUE
		if("openArmory")
			open_armory = !open_armory
			SStgui.update_user_uis(holder.mob)
			. = TRUE
		if("randomNames")
			random_names = !random_names
			SStgui.update_user_uis(holder.mob)
			. = TRUE
		if("spawnAdmin")
			spawn_admin = !spawn_admin
			SStgui.update_user_uis(holder.mob)
			. = TRUE
		if("leaderExperience")
			leader_experience = !leader_experience
			SStgui.update_user_uis(holder.mob)
			. = TRUE
		if("giveCyberimps")
			give_cyberimps = !give_cyberimps
			SStgui.update_user_uis(holder.mob)
			. = TRUE

/datum/ert_maker/ui_close(mob/user)
	qdel(src)


#undef ERT_EXPERIENCED_LEADER_CHOOSE_TOP
