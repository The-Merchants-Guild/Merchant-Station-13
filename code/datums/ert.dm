/datum/ert
	var/name // has to be unique
	var/mobtype = /mob/living/carbon/human
	var/team = /datum/team/ert
	var/opendoors = TRUE
	var/datum/antagonist/ert/leader_role = /datum/antagonist/ert/commander
	var/enforce_human = TRUE
	var/list/datum/antagonist/ert/roles = list(/datum/antagonist/ert/security, /datum/antagonist/ert/medic, /datum/antagonist/ert/engineer) //List of possible roles to be assigned to ERT members.
	var/rename_team
	var/code
	var/mission = "Assist the station."
	var/teamsize = 5
	var/polldesc
	/// If TRUE, gives the team members "[role] [random last name]" style names
	var/random_names = TRUE
	/// If TRUE, the admin who created the response team will be spawned in the briefing room in their preferred briefing outfit (assuming they're a ghost)
	var/spawn_admin = FALSE
	/// If TRUE, we try and pick one of the most experienced players who volunteered to fill the leader slot
	var/leader_experience = TRUE
	/// if TRUE, the ERT spawns with their pre-defined mechs.
	var/spawn_mechs = FALSE
	var/mech_amount = 5

/datum/ert/proc/copy_vars_to_custom_ERT_datum()
	var/datum/ert/custom/copied_datum = new
	copied_datum.name = "[name] (Copy)"
	copied_datum.mobtype = mobtype
	copied_datum.team = team
	copied_datum.opendoors = opendoors

	var/datum/ert_antag_template/lead_template = new
	lead_template.role = initial(leader_role.role)
	lead_template.mech = initial(leader_role.mech)
	lead_template.antag_outfit = initial(leader_role.outfit)
	lead_template.plasmaman_outfit = initial(leader_role.plasmaman_outfit)

	copied_datum.leader_template = lead_template

	for(var/rolepath in roles)
		if(ispath(rolepath, /datum/antagonist/ert))
			var/datum/antagonist/ert/antag = rolepath
			var/datum/ert_antag_template/role_template = new
			role_template.role = initial(antag.role)
			role_template.mech = initial(antag.mech)
			role_template.antag_outfit = initial(antag.outfit)
			role_template.plasmaman_outfit = initial(antag.plasmaman_outfit)
			copied_datum.grunt_templates += role_template

	copied_datum.enforce_human = enforce_human
	copied_datum.rename_team = rename_team
	copied_datum.code = code
	copied_datum.mission = mission
	copied_datum.teamsize = teamsize
	copied_datum.polldesc = polldesc
	copied_datum.random_names = random_names
	copied_datum.spawn_admin = spawn_admin
	copied_datum.leader_experience = leader_experience
	copied_datum.spawn_mechs = spawn_mechs
	copied_datum.mech_amount = mech_amount
	return copied_datum

/datum/ert/New()
	if (!polldesc)
		polldesc = "a Code [code] Nanotrasen Emergency Response Team"

/datum/ert/blue
	name = "Code Blue ERT"
	opendoors = FALSE
	code = "Blue"

/datum/ert/amber
	name = "Code Amber ERT"
	code = "Amber"

/datum/ert/red
	name = "Code Red ERT"
	leader_role = /datum/antagonist/ert/commander/red
	roles = list(/datum/antagonist/ert/security/red, /datum/antagonist/ert/medic/red, /datum/antagonist/ert/engineer/red)
	code = "Red"

/datum/ert/deathsquad
	name = "Deathsquad"
	roles = list(/datum/antagonist/ert/deathsquad)
	leader_role = /datum/antagonist/ert/deathsquad/leader
	rename_team = "Deathsquad"
	code = "Delta"
	mission = "Leave no witnesses."
	polldesc = "an elite Nanotrasen Strike Team"

/datum/ert/marine
	name = "Marine Squad"
	leader_role = /datum/antagonist/ert/marine
	roles = list(/datum/antagonist/ert/marine/security, /datum/antagonist/ert/marine/engineer, /datum/antagonist/ert/marine/medic)
	rename_team = "Marine Squad"
	polldesc = "an 'elite' Nanotrasen Strike Team"
	opendoors = FALSE

/datum/ert/centcom_official
	name = "Centcom Official"
	code = "Green"
	teamsize = 1
	opendoors = FALSE
	leader_role = /datum/antagonist/ert/official
	roles = list(/datum/antagonist/ert/official)
	rename_team = "CentCom Officials"
	polldesc = "a CentCom Official"
	random_names = FALSE
	leader_experience = FALSE

/datum/ert/centcom_official/New()
	mission = "Conduct a routine performance review of [station_name()] and its Captain."

/datum/ert/inquisition
	name = "His Most Holy Inquisition"
	roles = list(/datum/antagonist/ert/chaplain/inquisitor, /datum/antagonist/ert/security/inquisitor, /datum/antagonist/ert/medic/inquisitor)
	leader_role = /datum/antagonist/ert/commander/inquisitor
	rename_team = "Inquisition"
	mission = "Destroy any traces of paranormal activity aboard the station."
	polldesc = "a Nanotrasen paranormal response team"

/datum/ert/janitor
	name = "Powered-Up Janitors"
	roles = list(/datum/antagonist/ert/janitor, /datum/antagonist/ert/janitor/heavy)
	leader_role = /datum/antagonist/ert/janitor/heavy
	teamsize = 4
	opendoors = FALSE
	rename_team = "Janitor"
	mission = "Clean up EVERYTHING."
	polldesc = "a Nanotrasen Janitorial Response Team"

/datum/ert/intern
	name = "Armed Interns"
	roles = list(/datum/antagonist/ert/intern)
	leader_role = /datum/antagonist/ert/intern/leader
	teamsize = 7
	opendoors = FALSE
	rename_team = "Horde of Interns"
	mission = "Assist in conflict resolution."
	polldesc = "an unpaid internship opportunity with Nanotrasen"
	random_names = FALSE

/datum/ert/intern/unarmed
	name = "Disarmed Interns"
	roles = list(/datum/antagonist/ert/intern/unarmed)
	leader_role = /datum/antagonist/ert/intern/leader/unarmed
	rename_team = "Unarmed Horde of Interns"

/datum/ert/erp
	name = "Code Rainbow ERP"
	roles = list(/datum/antagonist/ert/security/party, /datum/antagonist/ert/clown/party, /datum/antagonist/ert/engineer/party, /datum/antagonist/ert/janitor/party)
	leader_role = /datum/antagonist/ert/commander/party
	opendoors = FALSE
	rename_team = "Emergency Response Party"
	mission = "Create entertainment for the crew."
	polldesc = "a Code Rainbow Nanotrasen Emergency Response Party"
	code = "Rainbow"

GLOBAL_LIST_EMPTY(custom_ert_datums)
/datum/ert/custom
	name = "ert_custom"
	code = "Purple"

	leader_role = /datum/antagonist/ert/custom/leader
	roles = list(/datum/antagonist/ert/custom)

	var/weak

	var/datum/ert_antag_template/leader_template = new
	var/list/datum/ert_antag_template/grunt_templates = list()


/datum/ert/custom/New(weak = FALSE)
	..()
	src.weak = weak
	if(!weak)
		GLOB.custom_ert_datums += src
	grunt_templates += new /datum/ert_antag_template

/datum/ert/custom/Destroy()
	if(!weak)
		GLOB.custom_ert_datums -= src
	..()

/datum/ert_antag_template
	var/role = "Centcom Official"
	var/datum/outfit/antag_outfit = /datum/outfit/centcom/centcom_official
	var/datum/outfit/plasmaman_outfit = /datum/outfit/plasmaman/centcom_official
	var/obj/vehicle/sealed/mecha/mech = /obj/vehicle/sealed/mecha/working/ripley/cargo

/datum/ert_antag_template/proc/get_json_data()
	. = list()
	.["role"] = role
	.["mech"] = "[mech]"
	if(istype(antag_outfit))
		.["antag_outfit"] = antag_outfit.get_json_data()
	else if (ispath(antag_outfit))
		.["antag_outfit"] = "[antag_outfit]"

	if(istype(plasmaman_outfit))
		.["plasmaman_outfit"] = plasmaman_outfit.get_json_data()
	else if (ispath(plasmaman_outfit))
		.["plasmaman_outfit"] = "[plasmaman_outfit]"


/datum/ert_antag_template/proc/load_from(list/template_data)
	role = template_data["role"]

	if(ispath(template_data["antag_outfit"]))
		antag_outfit = text2path(template_data["antag_outfit"])
	else if (islist(template_data["antag_outfit"]))
		var/datum/outfit/outfit = new
		outfit.load_from(template_data["antag_outfit"])
		antag_outfit = outfit

	if(ispath(template_data["plasmaman_outfit"]))
		plasmaman_outfit = text2path(template_data["plasmaman_outfit"])
	else if (islist(template_data["plasmaman_outfit"]))
		var/datum/outfit/outfit = new
		outfit.load_from(template_data["plasmaman_outfit"])
		plasmaman_outfit = outfit

	mech = text2path(template_data["mech"])


/// Return a json list of this ERT thingy.
/datum/ert/custom/proc/get_json_data()
	. = list()
	.["name"] = name
	.["rename_team"] = rename_team
	.["mission"] = mission
	.["polldesc"] = polldesc

	.["opendoors"] = opendoors
	.["enforce_human"] = enforce_human
	.["random_names"] = random_names
	.["spawn_admin"] = spawn_admin
	.["leader_experience"] = leader_experience
	.["spawn_mechs"] = spawn_mechs

	.["teamsize"] = teamsize
	.["mech_amount"] = mech_amount

	.["leader_template"] = leader_template.get_json_data()
	.["grunt_templates"] = list()
	for(var/datum/ert_antag_template/template in grunt_templates)
		.["grunt_templates"] += list(template.get_json_data())


/datum/ert/custom/proc/load_from(list/ert_data)
	name = ert_data["name"]
	rename_team = ert_data["rename_team"]
	mission = ert_data["mission"]
	mission = ert_data["mission"]
	polldesc = ert_data["polldesc"]

	opendoors = ert_data["opendoors"]
	enforce_human = ert_data["enforce_human"]
	random_names = ert_data["random_names"]
	spawn_admin = ert_data["spawn_admin"]
	leader_experience = ert_data["leader_experience"]
	spawn_mechs = ert_data["spawn_mechs"]

	teamsize = ert_data["teamsize"]
	mech_amount = ert_data["mech_amount"]
	var/datum/ert_antag_template/leadertemp = new
	leadertemp.load_from(ert_data["leader_template"])
	leader_template = leadertemp

	for(var/temp in ert_data["grunt_templates"])
		var/datum/ert_antag_template/grunttemp = new
		grunttemp.load_from(temp)
		grunt_templates += grunttemp

	return TRUE

// copied from outfit save_to_file proc
/datum/ert/custom/proc/save_to_file(mob/badmin)
	var/stored_data = get_json_data()
	var/json = json_encode(stored_data)
	var/f = file("data/TempERTUpload")
	fdel(f)
	WRITE_FILE(f, json)
	badmin << ftp(f, "[name].json")
