// How much time is given to admins to cancel a potential ERT. In seconds.
#define STRIKE_TEAM_ADMIN_INTERVENTION_TIME 10
// Cooldown between strike team calls. In minutes.
#define STRIKE_TEAM_CALL_COOLDOWN 5

SUBSYSTEM_DEF(strike_team)
	name = "Strike Team"
	flags = SS_NO_FIRE
	// How many times an ERT was called. Each call makes the next ERT a bit stronger.
	// I.e. you may get a CC official one call, then you call again and it's
	// not a CC official, it's a code blue ERT.
	var/ert_call_amount = 0
	var/list/datum/ert/ert_options = list()
	var/datum/ert_maker/ert_manager = new
	var/datum/ert/selected_ert = new /datum/ert/janitor
	// did an admin force the ERT?
	// if TRUE, does not pick appropriate from the list
	// during next creation attempt, afterwards sets itself to FALSE
	var/forced_ert = FALSE

	var/announcer_name = "\improper Central Command ERT Dispatch Centre"

	var/next_call_time = 0

	// Are we currently spawning an ERT?
	// Used for admin cancellation.
	var/spawning = FALSE

/datum/controller/subsystem/strike_team/Initialize(start_timeofday)
	ert_options += new /datum/ert/centcom_official
	ert_options += new /datum/ert/blue
	ert_options += new /datum/ert/amber
	ert_options += new /datum/ert/red
	ert_options += new /datum/ert/deathsquad
	var/datum/ert/deathsquad/ohfuck = new
	ohfuck.spawn_mechs = TRUE
	ohfuck.teamsize = 10
	ohfuck.mech_amount = 5
	ert_options += ohfuck
	if(ert_manager)
		ert_manager.set_selected_ERT(ert_options[1])
	return ..()

/datum/controller/subsystem/strike_team/proc/attempt_ert_creation(var/level = 0)
	if(world.time < next_call_time)
		return
	priority_announce("A request for an emergency response team has been received by \the [announcer_name]. Please stand by for further updates. Abuse of this system is cause for employment contract termination.", announcer_name)
	if(!ert_manager)
		priority_announce("\The [announcer_name] has suffered a major technical problem. Please call your nearest deity or equivalent for further support.", announcer_name)
		message_admins("SSstrike_team Error: no ERT manager present. An ERT will have to be spawned manually, unless you can initialize a new manager. Scream at the coders, too.")
		return
	if(!ert_options.len)
		priority_announce("\The [announcer_name] has suffered a major technical problem. Please call your nearest deity or equivalent for further support.", announcer_name)
		message_admins("SSstrike_team Error: no ERT options avaiable. ert_options is of length [ert_options.len]. Manually add options (as new, initialized datums, not typepaths) or create an ERT yourself via the Summon ERT verb. Scream at the coders, too.")
		return
	spawning = TRUE
	if(!forced_ert && istype(selected_ert))
		selected_ert = ert_options[clamp(level + ert_call_amount + 1, 1, ert_options.len)]
	forced_ert = FALSE
	message_admins("Emergency response team ([selected_ert.name]) will be summoned in [STRIKE_TEAM_ADMIN_INTERVENTION_TIME] seconds. (<a href='?src=[REF(src)];cancel=1'>CANCEL</a>)")
	sleep(STRIKE_TEAM_ADMIN_INTERVENTION_TIME SECONDS)
	if(spawning)
		ert_manager.set_selected_ERT(selected_ert)
		if(ert_manager.spawn_ERT_team())
			priority_announce("\The [announcer_name] has dispatched \an [selected_ert.name] to your station. They will arrive shortly. Should this response team fail to handle the situation on-station, you may call another in [STRIKE_TEAM_CALL_COOLDOWN] minutes.", announcer_name)
			next_call_time = world.time + STRIKE_TEAM_CALL_COOLDOWN MINUTES
			ert_call_amount++
			return
	priority_announce("\The [announcer_name] has been unable to find sufficient resources to allocate towards creating a response team to send to your location. ", announcer_name)


/datum/controller/subsystem/strike_team/Topic(href, list/href_list)
	..()
	if(href_list["cancel"])
		if(!spawning)
			to_chat(usr, span_admin("You are too late to cancel that response team."))
			return
		spawning = FALSE
		message_admins("[key_name_admin(usr)] cancelled the ERT \"[selected_ert.name]\".")
		log_admin_private("[key_name(usr)] cancelled the ERT \"[selected_ert.name]\".")
		SSblackbox.record_feedback("tally", "ert_admin_cancelled", 1, selected_ert.type)

