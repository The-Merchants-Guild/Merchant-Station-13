/datum/card_access/job
	flags = CARD_ACCESS_ASSIGNABLE
	var/list/minimal_access = list()
	var/list/full_access = list()

/datum/card_access/job/get_access()
	. = ..()
	. |= minimal_access
	if (!CONFIG_GET(flag/jobs_have_minimal_access))
		. |= full_access

/datum/card_access/job/assistant
	assignment = "Assistant"

/datum/card_access/job/assistant/get_access()
	if (CONFIG_GET(flag/assistants_have_maint_access))
		return list(ACCESS_MAINT_TUNNELS)
	. = ..()

/datum/card_access/job/atmospheric_technician
	assignment = "Atmospheric Technician"
	full_access = list(ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_EXTERNAL_AIRLOCKS)
	minimal_access = list(ACCESS_ATMOSPHERICS, ACCESS_MAINT_TUNNELS, ACCESS_AUX_BASE, ACCESS_CONSTRUCTION, ACCESS_MECH_ENGINE,
					ACCESS_MINERAL_STOREROOM)

/datum/card_access/job/bartender
	assignment = "Bartender"
	full_access = list(ACCESS_HYDROPONICS, ACCESS_KITCHEN, ACCESS_MORGUE)
	minimal_access = list(ACCESS_BAR, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
