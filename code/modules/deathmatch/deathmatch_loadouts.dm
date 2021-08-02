/datum/deathmatch_loadout
	var/name = "Loadout"
	var/desc = ":KILL:"
	var/datum/outfit/outfit
	var/obj/item/weapon

// If you want to put the player in a mech or similiar do it here.
/datum/deathmatch_loadout/proc/special_equip(mob/living/carbon/player)
	return

/datum/deathmatch_loadout/assistant
	name = "Assistant loadout"
	desc = "A simple assistant loadout: greyshirt and a toolbox"
	outfit = /datum/outfit/job/assistant
	weapon = /obj/item/storage/toolbox/mechanical/old/empty

/datum/deathmatch_loadout/assistant/weaponless
	name = "Assistant loadout (Weaponless)"
	desc = "What is an assistant without a toolbox? nothing"
	outfit = /datum/outfit/job/assistant
