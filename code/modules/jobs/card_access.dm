#define CARD_ACCESS_ASSIGNABLE (1 << 0)

/datum/card_access
	var/assignment = "Unassigned"
	var/flags = NONE
	var/list/access

/datum/card_access/New()
	access = list(
		"[ACCESS_TIER_1]" = list(),
		"[ACCESS_TIER_2]" = list(),
		"[ACCESS_TIER_3]" = list(),
		"[ACCESS_TIER_4]" = list(),
		"[ACCESS_TIER_5]" = list(),
		"[ACCESS_TIER_6]" = list()
	)
	for (var/a in get_access())
		access[SSid_access.get_access_tier(a)] += a

/datum/card_access/proc/get_access()
	return list()
