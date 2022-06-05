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
	var/datum/ert/selected_ERT_option = null // What have we selected?
	var/client/holder // client of whoever is using this datum

	var/datum/antagonist/ert/leader_antag = null
	var/list/datum/antagonist/ert/grunt_antags = list()

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
	var/spawn_mechs = FALSE // Give the ERT mechs?
	var/mech_amount = 5

	var/list/preview_images = list()
	var/selected_direction = SOUTH
	var/selected_preview_role = null // So we can preview more than just the leader
	var/editing_ERT = FALSE

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

	var/ertDefault = ERT_options[1]

	selected_ERT_option = new ertDefault // So we have SOMETHING selected
	load_settings_from_ERT_datum(selected_ERT_option)
	selected_preview_role = initial(selected_ERT_option.leader_role.role)
	ui_interact(holder.mob)

/datum/ert_maker/proc/load_settings_from_ERT_datum(var/datum/ert/ERT_datum)
	teamsize = ERT_datum.teamsize
	mission = ERT_datum.mission
	polldesc = ERT_datum.polldesc
	rename_team = ERT_datum.rename_team
	enforce_human = CONFIG_GET(flag/enforce_human_authority)
	open_armory = ERT_datum.opendoors
	random_names = ERT_datum.random_names
	spawn_admin = ERT_datum.spawn_admin
	leader_experience = ERT_datum.leader_experience
	spawn_mechs = ERT_datum.spawn_mechs
	leader_antag = ERT_datum.leader_role
	grunt_antags = ERT_datum.roles

/datum/ert_maker/proc/copy_settings_to_ERT_datum(var/datum/ert/ERT_datum)
	ERT_datum.teamsize = teamsize
	ERT_datum.mission = mission
	ERT_datum.polldesc = polldesc
	ERT_datum.rename_team = rename_team
	ERT_datum.enforce_human = enforce_human
	ERT_datum.opendoors = open_armory
	ERT_datum.random_names = random_names
	ERT_datum.spawn_admin = spawn_admin
	ERT_datum.leader_experience = leader_experience
	ERT_datum.spawn_mechs = spawn_mechs
	if(!istype(ERT_datum, /datum/ert/custom))
		ERT_datum.leader_role = leader_antag
		ERT_datum.roles = grunt_antags
	else if(istype(selected_ERT_option, /datum/ert/custom) && istype(ERT_datum, /datum/ert/custom))
		var/datum/ert/custom/ert = ERT_datum
		var/datum/ert/custom/selected = selected_ERT_option
		ert.leader_template = selected.leader_template
		ert.grunt_templates = selected.grunt_templates

/// proc below copy-pasted from old ERT spawner
/datum/ert_maker/proc/equipAntagOnDummy(mob/living/carbon/human/dummy/mannequin, antag)
	var/to_remove = mannequin.get_equipped_items(TRUE)
	for(var/I in to_remove)
		qdel(I)
	if (ispath(antag, /datum/antagonist/ert))
		var/datum/antagonist/ert/ert = antag
		mannequin.equipOutfit(initial(ert.outfit), TRUE)
	else if (istype(antag, /datum/ert_antag_template))
		var/datum/ert_antag_template/ert = antag
		mannequin.equipOutfit(ert.antag_outfit, TRUE)

/datum/ert_maker/proc/generate_ERT_preview_images()
	if(!holder)
		return

	// We will generate the preview icon
	// and then cache it

	if(preview_images[selected_ERT_option.name] && !istype(selected_ERT_option, /datum/ert/custom))
		return // already generated

	preview_images[selected_ERT_option.name] = list()

	var/roles = list()
	if(istype(selected_ERT_option, /datum/ert/custom))
		var/datum/ert/custom/custom = selected_ERT_option
		roles += custom.leader_template
		roles += custom.grunt_templates
	else
		roles += selected_ERT_option.leader_role
		roles += selected_ERT_option.roles

	for(var/role in roles)

		// Set up dummy. Set it up for every role
		// because I had issues with mob/living/carbon/human/get_equipped_items
		// (returned null list for some reason)
		var/mob/living/carbon/human/dummy/mannequin = new /mob/living/carbon/human/dummy
		// Wait for dummy proc does not work above;
		// freezes TGUI window, leaving white screen

		var/template = role

		var/role_name = "placeholder"


		// real yandev coding
		if(istype(template, /datum/antagonist/ert))
			var/datum/antagonist/ert/temp = template
			role_name = temp.role
		else if(ispath(template, /datum/antagonist/ert))
			var/datum/antagonist/ert/temp = template
			role_name = initial(temp.role)
		else if(istype(template, /datum/ert_antag_template))
			var/datum/ert_antag_template/temp = template
			role_name = temp.role

		if(role_name in preview_images[selected_ERT_option.name])
			continue
		equipAntagOnDummy(mannequin, template)

		COMPILE_OVERLAYS(mannequin)

		var/list/cached_icons = list()
		for(var/direction in GLOB.cardinals) // All four directions, in case the admin wants to rotate his preview
			var/icon/preview = getFlatIcon(mannequin, direction)
			cached_icons[dir2text(direction)] = icon2base64(preview)

		preview_images[selected_ERT_option.name][role_name] = cached_icons

		qdel(mannequin)



/datum/ert_maker/ui_state(mob/user)
	return GLOB.admin_state // generally admin-only thing

/datum/ert_maker/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ErtMaker")
		ui.open()

/datum/ert_maker/proc/make_antag_data(antag)
	. = list()
	if(ispath(antag, /datum/antagonist/ert))
		var/datum/antagonist/ert/antagonist = antag
		.["role"] = initial(antagonist.role)
		.["path"] = "[antagonist]"
		.["outfit"] = initial(antagonist.outfit)
		.["plasmaOutfit"] = initial(antagonist.plasmaman_outfit)
		.["mech"] = initial(antagonist.mech)
	else if (istype(antag, /datum/ert_antag_template))
		var/datum/ert_antag_template/antagonist = antag
		.["role"] = antagonist.role
		.["ref"] = "[REF(antagonist)]"
		.["outfit"] = antagonist.antag_outfit
		.["plasmaOutfit"] = antagonist.plasmaman_outfit
		.["mech"] = antagonist.mech

/datum/ert_maker/ui_data(mob/user)
	var/list/data = list()

	// Make ERT options.
	var/list/ert_options_text = list()
	for (var/option in ERT_options)
		if (!ispath(option, /datum/ert) || ispath(option, /datum/ert/custom))
			continue
		var/datum/ert/ert = option
		var/list/ert_data = list()
		ert_data["name"] = initial(ert.name)
		ert_data["path"] = "[ert]"

		ert_options_text += list(ert_data)


	data["ERT_options"] = ert_options_text
	var/list/custom_ERT_options = list()
	for(var/option in GLOB.custom_ert_datums)
		if(!istype(option, /datum/ert/custom)) // how?
			continue
		var/datum/ert/custom/ert = option
		var/list/ert_data = list()
		ert_data["name"] = ert.name
		ert_data["path"] = "[ert]"
		ert_data["ref"] = "[REF(ert)]"
		custom_ERT_options += list(ert_data)

	data["custom_ERT_options"] = custom_ERT_options

	var/list/selected_ERT_data = list()

	selected_ERT_data = list()
	selected_ERT_data["name"] = selected_ERT_option.name
	selected_ERT_data["path"] = "[selected_ERT_option.type]"
	if(istype(selected_ERT_option, /datum/ert/custom))
		var/datum/ert/custom/ert = selected_ERT_option
		selected_ERT_data["leaderAntag"] = make_antag_data(ert.leader_template)
		selected_ERT_data["memberAntags"] = list()
		for(var/role in ert.grunt_templates)
			selected_ERT_data["memberAntags"] += list(make_antag_data(role))
	else
		selected_ERT_data["leaderAntag"] = make_antag_data(leader_antag)
		selected_ERT_data["memberAntags"] = list()
		for(var/role in grunt_antags)
			selected_ERT_data["memberAntags"] += list(make_antag_data(role))

	// Check if we generated the images already.
	if(!(selected_ERT_option.name in preview_images) \
	|| !(selected_preview_role in preview_images[selected_ERT_option.name]) \
	|| !(dir2text(selected_direction) in preview_images[selected_ERT_option.name][selected_preview_role]))
		generate_ERT_preview_images() // No, generate them
	selected_ERT_data["previewIcon"] = preview_images[selected_ERT_option.name][selected_preview_role][dir2text(selected_direction)]

	data["selected_ERT_option"] = selected_ERT_data
	data["selected_preview_role"] = selected_preview_role
	data["editing_mode"] = editing_ERT

	data["teamsize"] = teamsize
	data["mission"] = mission
	data["polldesc"] = polldesc
	data["rename_team"] = rename_team
	data["enforce_human"] = enforce_human
	data["open_armory"] = open_armory
	data["spawn_admin"] = spawn_admin
	data["leader_experience"] = leader_experience
	data["give_cyberimps"] = give_cyberimps
	data["spawn_mechs"] = spawn_mechs
	return data

/datum/ert_maker/proc/set_selected_ERT(responseTeam)
	if(!istype(responseTeam, /datum/ert))
		return
	selected_ERT_option = responseTeam

	load_settings_from_ERT_datum(selected_ERT_option)
	// Set our selected preview role to the leader of the selected datum
	selected_preview_role = initial(selected_ERT_option.leader_role.role)

	if(istype(responseTeam, /datum/ert/custom))
		var/datum/ert/custom/ert = responseTeam
		selected_preview_role = ert.leader_template.role

	if(!(selected_ERT_option.name in preview_images)\
	|| !(selected_preview_role in preview_images[selected_ERT_option.name])\
	|| !(dir2text(selected_direction) in preview_images[selected_ERT_option.name][selected_preview_role]))
		generate_ERT_preview_images()

	SStgui.update_user_uis(holder.mob)

/datum/ert_maker/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		/// Base ERT stuff ///
		if("pickERT")
			if(params["selectedERT"]) // Selected by path.
				var/selected_path = text2path(params["selectedERT"])
				if(!istype(selected_ERT_option, /datum/ert/custom))
					//qdel(selected_ERT_option) // Avoid loose ERT datums.

				set_selected_ERT(new selected_path)

			if(params["selectedREF"]) // Selected custom ERT.
				var/datum/ert/custom/ert = locate(params["selectedREF"])
				if(ert)
					set_selected_ERT(ert)
				else
					to_chat(holder, span_warning("Unable to locate that ERT. Notify a coder."))

			. = TRUE
		if("rotatePreview")
			selected_direction = turn(selected_direction, 90*params["direction"])
			SStgui.update_user_uis(holder.mob)
			. = TRUE
		if("pickPreviewRole")
			selected_preview_role = params["newPreviewRole"]
			SStgui.update_user_uis(holder.mob)
			. = TRUE
		if("spawnERT")
			var/ERToption
			if(istype(selected_ERT_option, /datum/ert/custom))
				ERToption = new /datum/ert/custom(TRUE)
			else
				ERToption = new selected_ERT_option
			copy_settings_to_ERT_datum(ERToption)
			spawn_ERT_team(ERToption)
			. = TRUE

		/// Editing ///
		if("editSelectedERT")
			//Do not allow editing of the base ERTs. Instead,
			//We will clone them.
			var/datum/ert/custom/custom_to_edit
			if(!istype(selected_ERT_option, /datum/ert/custom))
				var/prompt = tgui_alert(holder.mob, "Unable to edit [selected_ERT_option]. Would you like to duplicate it and work on the duplicate?", "Editing",list("Ok", "Cancel"))
				if(prompt == "Ok")
					custom_to_edit = selected_ERT_option.copy_vars_to_custom_ERT_datum()
					selected_ERT_option = custom_to_edit
					editing_ERT = TRUE
			else
				editing_ERT = !editing_ERT

			SStgui.update_user_uis(holder.mob)
			. = TRUE

		if("setSelectedName")
			var/datum/ert/custom/ert = selected_ERT_option
			if(!editing_ERT || !istype(ert))
				return TRUE
			if(params["newName"])
				var/dupe = FALSE
				for(var/datum/ert/custom/custom_ert in GLOB.custom_ert_datums)
					if(custom_ert.name == params["newName"])
						dupe = TRUE
				for(var/datum/ert/custom/base_ert in GLOB.custom_ert_datums)
					if(base_ert.name == params["newName"])
						dupe = TRUE

				if(dupe)
					to_chat(holder, span_warning("Duplicate ERT names are not allowed. Please select a unique name."))
					return TRUE
				if(preview_images[ert.name]) // clean old preview images
					preview_images[ert.name] = list()
				ert.name = params["newName"]

			SStgui.update_user_uis(holder.mob)
			. = TRUE

		if("setAntagOutfit")
			var/datum/ert/custom/ert = selected_ERT_option
			if(!editing_ERT || !istype(ert))
				return TRUE
			var/datum/outfit/new_outfit
			var/alertresult = tgui_alert(holder.mob, "Do you want a custom outfit, or a preset?", "Outfit Select", list("Preset", "Custom", "Cancel"))
			if(alertresult == "Preset")
				new_outfit = tgui_input_list(holder.mob, "Select an outfit.", "Outfit Select", subtypesof(/datum/outfit))
			else if (alertresult == "Custom")
				if(GLOB.custom_outfits.len > 0)
					new_outfit = tgui_input_list(holder.mob, "Select an outfit.", "Outfit Select", GLOB.custom_outfits)
				else
					to_chat(holder, span_warning("No custom outfits detected. Create one with the outfit manager."))
			else
				return TRUE
			if(istype(new_outfit) || ispath(new_outfit))
				var/num = params["antagNum"]
				if(num == 0)
					if(params["plasmaman_outfit"])
						ert.leader_template.plasmaman_outfit = new_outfit
					else
						ert.leader_template.antag_outfit = new_outfit
					preview_images[selected_ERT_option.name][ert.leader_template.role] = null
				else if(ert.grunt_templates[num])
					if(params["plasmaman_outfit"])
						ert.grunt_templates[num].plasmaman_outfit = new_outfit
					else
						ert.grunt_templates[num].antag_outfit = new_outfit
					preview_images[selected_ERT_option.name][ert.grunt_templates[num].role] = null

			SStgui.update_user_uis(holder.mob)
			. = TRUE

		if("setAntagMech")
			var/datum/ert/custom/ert = selected_ERT_option
			if(!editing_ERT || !istype(ert))
				return TRUE
			var/obj/vehicle/sealed/mecha/new_mech = tgui_input_list(holder.mob, "Select a mech.", "Mech Select", subtypesof(/obj/vehicle/sealed/mecha))
			if(ispath(new_mech))
				var/num = params["antagNum"]
				if(num == 0)
					ert.leader_template.mech = new_mech
				else if(ert.grunt_templates[num])
					ert.grunt_templates[num].mech = new_mech

			SStgui.update_user_uis(holder.mob)
			. = TRUE

		if("setAntagRole")
			var/datum/ert/custom/ert = selected_ERT_option
			if(!editing_ERT || !istype(ert))
				return TRUE
			if(params["newRole"])
				var/num = params["antagNum"]
				if(num == 0)
					if(selected_preview_role == ert.leader_template.role)
						selected_preview_role = params["newRole"]
					ert.leader_template.role = params["newRole"]
				else if(ert.grunt_templates[num])
					if(selected_preview_role == ert.grunt_templates[num].role)
						selected_preview_role = params["newRole"]
					ert.grunt_templates[num].role = params["newRole"]

			SStgui.update_user_uis(holder.mob)
			. = TRUE

		if("addAntagonist")
			var/datum/ert/custom/ert = selected_ERT_option
			if(!editing_ERT || !istype(ert))
				return TRUE

			ert.grunt_templates.Add(new /datum/ert_antag_template)

			SStgui.update_user_uis(holder.mob)
			. = TRUE

		if("removeAntagonist")
			var/datum/ert/custom/ert = selected_ERT_option
			if(!editing_ERT || !istype(ert))
				return TRUE

			var/num = params["antagNum"]
			if(num && (num > 1))
				if(ert.grunt_templates[num])
					ert.grunt_templates.Cut(num, num+1)

			SStgui.update_user_uis(holder.mob)
			. = TRUE

		/// Customization ///
		if("setTeamName")
			if(editing_ERT && istype(selected_ERT_option, /datum/ert/custom))
				selected_ERT_option.rename_team = params["new_value"]
			rename_team = params["new_value"]
			SStgui.update_user_uis(holder.mob)
			. = TRUE
		if("setMission")
			if(editing_ERT && istype(selected_ERT_option, /datum/ert/custom))
				selected_ERT_option.mission = params["new_value"]
			mission = params["new_value"]
			SStgui.update_user_uis(holder.mob)
			. = TRUE
		if("setPollDesc")
			if(editing_ERT && istype(selected_ERT_option, /datum/ert/custom))
				selected_ERT_option.polldesc = params["new_value"]
			polldesc = params["new_value"]
			SStgui.update_user_uis(holder.mob)
			. = TRUE
		if("setTeamSize")
			if(editing_ERT && istype(selected_ERT_option, /datum/ert/custom))
				selected_ERT_option.teamsize = min(text2num(params["new_value"]), 1)
			teamsize = params["new_value"]
			SStgui.update_user_uis(holder.mob)
			. = TRUE
		if("setMechAmount")
			if(editing_ERT && istype(selected_ERT_option, /datum/ert/custom))
				selected_ERT_option.mech_amount = min(text2num(params["new_value"]), 0)
			mech_amount = params["new_value"]
			SStgui.update_user_uis(holder.mob)
			. = TRUE

		/// Toggles ///
		if("enforceHuman")
			if(editing_ERT && istype(selected_ERT_option, /datum/ert/custom))
				selected_ERT_option.enforce_human = !enforce_human // Edit the ERT
				enforce_human = !enforce_human // Edit us
			SStgui.update_user_uis(holder.mob)
			. = TRUE
		if("openArmory")
			if(editing_ERT && istype(selected_ERT_option, /datum/ert/custom))
				selected_ERT_option.opendoors = !open_armory
			open_armory = !open_armory
			SStgui.update_user_uis(holder.mob)
			. = TRUE
		if("randomNames")
			if(editing_ERT && istype(selected_ERT_option, /datum/ert/custom))
				selected_ERT_option.random_names = !random_names
			random_names = !random_names
			SStgui.update_user_uis(holder.mob)
			. = TRUE
		if("spawnAdmin")
			if(editing_ERT && istype(selected_ERT_option, /datum/ert/custom))
				selected_ERT_option.spawn_admin = !spawn_admin
			spawn_admin = !spawn_admin
			SStgui.update_user_uis(holder.mob)
			. = TRUE
		if("leaderExperience")
			if(editing_ERT && istype(selected_ERT_option, /datum/ert/custom))
				selected_ERT_option.leader_experience = !leader_experience
			leader_experience = !leader_experience
			SStgui.update_user_uis(holder.mob)
			. = TRUE
		if("spawnMechs")
			if(editing_ERT && istype(selected_ERT_option, /datum/ert/custom))
				selected_ERT_option.spawn_mechs = !spawn_mechs
			spawn_mechs = !spawn_mechs
			SStgui.update_user_uis(holder.mob)
			. = TRUE

		/// Debug ///
		if("vv")
			holder.debug_variables(src)
			. = TRUE

/datum/ert_maker/ui_close(mob/user)
	qdel(src)

// Mostly copy pasted from the pre-rewrite ERT verb
/datum/ert_maker/proc/spawn_ERT_team(datum/ert/ERToption)
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

	var/list/mob/dead/observer/candidates = pollGhostCandidates("Do you wish to be considered for [ERToption.polldesc]?", "deathsquad")
	var/teamSpawned = FALSE
	if(candidates.len == 0)
		return

	var/numagents = min(teamsize,candidates.len)
	var/nummechs = min(mech_amount, numagents)

	var/datum/team/ert/ert_team = new ERToption.team()
	if(rename_team)
		ert_team.name = rename_team

	var/datum/objective/missionobj = new()
	missionobj.team = ert_team
	missionobj.explanation_text = ERToption.mission
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
			ert_antag = new ERToption.leader_role()
			earmarked_leader = null
			leader_spawned = TRUE
			if(istype(ERToption, /datum/ert/custom))
				var/datum/ert/custom/c = ERToption
				ert_antag.role = c.leader_template.role
				ert_antag.outfit = c.leader_template.antag_outfit
				ert_antag.plasmaman_outfit = c.leader_template.plasmaman_outfit
				ert_antag.mech = c.leader_template.mech
		else
			ert_antag = ERToption.roles[WRAP(numagents,1,length(ERToption.roles) + 1)]
			ert_antag = new ert_antag ()
			if(istype(ERToption, /datum/ert/custom))
				var/datum/ert/custom/c = ERToption
				var/gruntnum = WRAP(numagents,1,length(c.grunt_templates) + 1)
				ert_antag.role = c.grunt_templates[gruntnum].role
				ert_antag.outfit = c.grunt_templates[gruntnum].antag_outfit
				ert_antag.plasmaman_outfit = c.grunt_templates[gruntnum].plasmaman_outfit
				ert_antag.mech = c.grunt_templates[gruntnum].mech
		ert_antag.random_names = ERToption.random_names


		ert_operative.mind.add_antag_datum(ert_antag,ert_team)
		ert_operative.mind.set_assigned_role(SSjob.GetJobType(ert_antag.ert_job_path))

		//Logging and cleanup
		log_game("[key_name(ert_operative)] has been selected as an [ert_antag.name]")
		numagents--
		teamSpawned++

		if(spawn_mechs && (nummechs > 0)) // abomination
			var/mech_to_spawn = null
			if(ert_antag.mech)
				mech_to_spawn = ert_antag.mech

			if(mech_to_spawn)
				var/obj/vehicle/sealed/mecha/spawned_mech = new mech_to_spawn(spawnloc)
				var/obj/item/storage/backpack/bag = locate() in ert_operative.contents
				if(bag)
					for(var/obj/item/item in ert_operative.held_items)
						// Move held items to bag
						// otherwise it'd be dropped on the floor (cooln't)
						item.forceMove(bag)

				spawned_mech.moved_inside(ert_operative)

			nummechs--

	if (teamSpawned)
		message_admins("[ERToption.polldesc] has spawned with the mission: [ERToption.mission]")

	//Open the Armory doors
	if(ERToption.opendoors)
		for(var/obj/machinery/door/poddoor/ert/door in GLOB.airlocks)
			door.open()
			CHECK_TICK

#undef ERT_EXPERIENCED_LEADER_CHOOSE_TOP
