/**
 * Non-processing subsystem that holds various procs and data structures to manage ID cards, trims and access.
 */
SUBSYSTEM_DEF(id_access)
	name = "IDs and Access"
	init_order = INIT_ORDER_IDACCESS
	flags = SS_NO_FIRE

	/// Dictionary of access tiers.
	var/list/tiers_by_access = list()
	/// Dictionary of access lists.
	var/list/accesses_by_tier = list()
	/// Dictionary of access names. Keys are access levels. Values are their associated names.
	var/list/name_by_access = list()
	var/list/accesses_by_region = list()
	var/list/card_access_instances = list()
	// this is slightly awful
	var/list/card_access_assignable = list()

/datum/controller/subsystem/id_access/Initialize(timeofday)
	setup_access_tiers()
	setup_access_names()
	setup_access_regions()
	setup_card_access()

	return ..()

/datum/controller/subsystem/id_access/proc/setup_card_access()
	for (var/p in subtypesof(/datum/card_access))
		var/datum/card_access/A = new p()
		card_access_instances[p] = A
		// this is slightly more awful
		if (A.flags & CARD_ACCESS_ASSIGNABLE && A.assignment)
			card_access_assignable += A

/datum/controller/subsystem/id_access/proc/setup_access_regions()
	accesses_by_region[REGION_GENERAL] = REGION_ACCESS_GENERAL
	accesses_by_region[REGION_SECURITY] = REGION_ACCESS_SECURITY
	accesses_by_region[REGION_MEDBAY] = REGION_ACCESS_MEDBAY
	accesses_by_region[REGION_RESEARCH] = REGION_ACCESS_RESEARCH
	accesses_by_region[REGION_ENGINEERING] = REGION_ACCESS_ENGINEERING
	accesses_by_region[REGION_SUPPLY] = REGION_ACCESS_SUPPLY
	accesses_by_region[REGION_COMMAND] = REGION_ACCESS_COMMAND
	accesses_by_region[REGION_CENTCOM] = REGION_ACCESS_CENTCOM
	accesses_by_region[REGION_SYNDICATE] = REGION_ACCESS_SYNDICATE
	accesses_by_region[REGION_STATION] = REGION_ACCESS_STATION
	accesses_by_region[REGION_GLOBAL] = REGION_ACCESS_GLOBAL

/// Build access flag lists.
/datum/controller/subsystem/id_access/proc/setup_access_tiers()
	accesses_by_tier["[ACCESS_TIER_1]"] = TIER_1_ACCESS
	accesses_by_tier["[ACCESS_TIER_2]"] = TIER_2_ACCESS
	accesses_by_tier["[ACCESS_TIER_3]"] = TIER_3_ACCESS
	accesses_by_tier["[ACCESS_TIER_4]"] = TIER_4_ACCESS
	accesses_by_tier["[ACCESS_TIER_5]"] = TIER_5_ACCESS
	accesses_by_tier["[ACCESS_TIER_6]"] = TIER_6_ACCESS
	for (var/t in accesses_by_tier)
		for (var/a in accesses_by_tier[t])
			tiers_by_access["[a]"] = t

/// Setup dictionary that converts access levels to text names.
/datum/controller/subsystem/id_access/proc/setup_access_names()
	name_by_access["[ACCESS_CARGO]"] = "Cargo Bay"
	name_by_access["[ACCESS_SECURITY]"] = "Security"
	name_by_access["[ACCESS_BRIG]"] = "Holding Cells"
	name_by_access["[ACCESS_COURT]"] = "Courtroom"
	name_by_access["[ACCESS_FORENSICS_LOCKERS]"] = "Forensics"
	name_by_access["[ACCESS_MEDICAL]"] = "Medical"
	name_by_access["[ACCESS_GENETICS]"] = "Genetics Lab"
	name_by_access["[ACCESS_MORGUE]"] = "Morgue"
	name_by_access["[ACCESS_RND]"] = "R&D Lab"
	name_by_access["[ACCESS_TOXINS]"] = "Toxins Lab"
	name_by_access["[ACCESS_TOXINS_STORAGE]"] = "Toxins Storage"
	name_by_access["[ACCESS_CHEMISTRY]"] = "Chemistry Lab"
	name_by_access["[ACCESS_RD]"] = "RD Office"
	name_by_access["[ACCESS_BAR]"] = "Bar"
	name_by_access["[ACCESS_JANITOR]"] = "Custodial Closet"
	name_by_access["[ACCESS_ENGINE]"] = "Engineering"
	name_by_access["[ACCESS_ENGINE_EQUIP]"] = "Power and Engineering Equipment"
	name_by_access["[ACCESS_MAINT_TUNNELS]"] = "Maintenance"
	name_by_access["[ACCESS_EXTERNAL_AIRLOCKS]"] = "External Airlocks"
	name_by_access["[ACCESS_CHANGE_IDS]"] = "ID Console"
	name_by_access["[ACCESS_AI_UPLOAD]"] = "AI Chambers"
	name_by_access["[ACCESS_TELEPORTER]"] = "Teleporter"
	name_by_access["[ACCESS_EVA]"] = "EVA"
	name_by_access["[ACCESS_HEADS]"] = "Bridge"
	name_by_access["[ACCESS_CAPTAIN]"] = "Captain"
	name_by_access["[ACCESS_ALL_PERSONAL_LOCKERS]"] = "Personal Lockers"
	name_by_access["[ACCESS_CHAPEL_OFFICE]"] = "Chapel Office"
	name_by_access["[ACCESS_TECH_STORAGE]"] = "Technical Storage"
	name_by_access["[ACCESS_ATMOSPHERICS]"] = "Atmospherics"
	name_by_access["[ACCESS_CREMATORIUM]"] = "Crematorium"
	name_by_access["[ACCESS_ARMORY]"] = "Armory"
	name_by_access["[ACCESS_CONSTRUCTION]"] = "Construction"
	name_by_access["[ACCESS_KITCHEN]"] = "Kitchen"
	name_by_access["[ACCESS_HYDROPONICS]"] = "Hydroponics"
	name_by_access["[ACCESS_LIBRARY]"] = "Library"
	name_by_access["[ACCESS_LAWYER]"] = "Law Office"
	name_by_access["[ACCESS_ROBOTICS]"] = "Robotics"
	name_by_access["[ACCESS_VIROLOGY]"] = "Virology"
	name_by_access["[ACCESS_PSYCHOLOGY]"] = "Psychology"
	name_by_access["[ACCESS_CMO]"] = "CMO Office"
	name_by_access["[ACCESS_QM]"] = "Quartermaster"
	name_by_access["[ACCESS_SURGERY]"] = "Surgery"
	name_by_access["[ACCESS_THEATRE]"] = "Theatre"
	name_by_access["[ACCESS_RESEARCH]"] = "Science"
	name_by_access["[ACCESS_MINING]"] = "Mining"
	name_by_access["[ACCESS_MAILSORTING]"] = "Cargo Office"
	name_by_access["[ACCESS_VAULT]"] = "Main Vault"
	name_by_access["[ACCESS_MINING_STATION]"] = "Mining EVA"
	name_by_access["[ACCESS_XENOBIOLOGY]"] = "Xenobiology Lab"
	name_by_access["[ACCESS_HOP]"] = "HoP Office"
	name_by_access["[ACCESS_HOS]"] = "HoS Office"
	name_by_access["[ACCESS_CE]"] = "CE Office"
	name_by_access["[ACCESS_PHARMACY]"] = "Pharmacy"
	name_by_access["[ACCESS_RC_ANNOUNCE]"] = "RC Announcements"
	name_by_access["[ACCESS_KEYCARD_AUTH]"] = "Keycode Auth."
	name_by_access["[ACCESS_TCOMSAT]"] = "Telecommunications"
	name_by_access["[ACCESS_GATEWAY]"] = "Gateway"
	name_by_access["[ACCESS_SEC_DOORS]"] = "Brig"
	name_by_access["[ACCESS_MINERAL_STOREROOM]"] = "Mineral Storage"
	name_by_access["[ACCESS_MINISAT]"] = "AI Satellite"
	name_by_access["[ACCESS_WEAPONS]"] = "Weapon Permit"
	name_by_access["[ACCESS_NETWORK]"] = "Network Access"
	name_by_access["[ACCESS_MECH_MINING]"] = "Mining Mech Access"
	name_by_access["[ACCESS_MECH_MEDICAL]"] = "Medical Mech Access"
	name_by_access["[ACCESS_MECH_SECURITY]"] = "Security Mech Access"
	name_by_access["[ACCESS_MECH_SCIENCE]"] = "Science Mech Access"
	name_by_access["[ACCESS_MECH_ENGINE]"] = "Engineering Mech Access"
	name_by_access["[ACCESS_AUX_BASE]"] = "Auxiliary Base"
	name_by_access["[ACCESS_CENT_GENERAL]"] = "Code Grey"
	name_by_access["[ACCESS_CENT_THUNDER]"] = "Code Yellow"
	name_by_access["[ACCESS_CENT_STORAGE]"] = "Code Orange"
	name_by_access["[ACCESS_CENT_LIVING]"] = "Code Green"
	name_by_access["[ACCESS_CENT_MEDICAL]"] = "Code White"
	name_by_access["[ACCESS_CENT_TELEPORTER]"] = "Code Blue"
	name_by_access["[ACCESS_CENT_SPECOPS]"] = "Code Black"
	name_by_access["[ACCESS_CENT_CAPTAIN]"] = "Code Gold"
	name_by_access["[ACCESS_CENT_BAR]"] = "Code Scotch"

/**
 * Returns the access tier associated with any given access level.
 *
 * Arguments:
 * * access - Access as either pure number or as a string representation of the number.
 */
/datum/controller/subsystem/id_access/proc/get_access_tier(access)
	return tiers_by_access["[access]"]

/**
 * Returns the access description associated with any given access level.
 *
 * In proc form due to accesses being stored in the list as text instead of numbers.
 * Arguments:
 * * access - Access as either pure number or as a string representation of the number.
 */
/datum/controller/subsystem/id_access/proc/get_access_name(access)
	return name_by_access["[access]"]

/**
 * Returns the list of all accesses associated with any given access tier.
 *
 * In proc form due to accesses being stored in the list as text instead of numbers.
 * Arguments:
 * * tier - The tier to get access for as either a pure number of string representation of the tier.
 */
/datum/controller/subsystem/id_access/proc/get_tier_access_list(tier)
	return accesses_by_tier["[tier]"]

/**
 * Tallies up all accesses the card has that have flags greater than or equal to the tier supplied.
 *
 * Returns the number of accesses that have flags matching tier or a higher tier access.
 * Arguments:
 * * id_card - The ID card to tally up access for.
 * * tier - The minimum access tier required for an access to be tallied up.
 */
/datum/controller/subsystem/id_access/proc/tally_access(obj/item/card/id/id_card, tier = NONE)
	var/tally = 0

	var/list/id_card_access = id_card.access
	for(var/access in id_card_access)
		if (tiers_by_access["[access]"] >= tier)
			tally++

	return tally

/datum/controller/subsystem/id_access/proc/apply_card_access(obj/item/card/id/id, card_access, chip = FALSE, force = FALSE)
	var/datum/card_access/C = card_access_instances[card_access]
	var/list/chip_access = list()
	id.assignment = C.assignment
	for (var/tier in C.access)
		if (!force && id.access_tier < text2num(tier))
			if (chip)
				chip_access.Add(C.access[tier])
			continue
		id.access.Add(C.access[tier])

	if (chip_access.len)
		var/obj/item/card_access_chip/roundstart/AA = new(id, C.assignment)
		AA.access = chip_access
		id.apply_access_chip(AA)
