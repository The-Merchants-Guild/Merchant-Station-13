/datum/deathmatch_loadout
	var/name = "Loadout"
	var/desc = ":KILL:"
	var/datum/outfit/outfit
	var/obj/item/weapon

/datum/deathmatch_loadout/proc/special_equip(mob/living/carbon/player)
	return

/datum/deathmatch_loadout/assistant
	name = "Assistant loadout"
	desc = "A simple assistant loadout: greyshirt and a toolbox"
	outfit = /datum/outfit/job/assistant
	weapon = /obj/item/storage/toolbox/mechanical/old/heirloom // Uses heirloom subtype as it is empty and called "toolbox" by default.
