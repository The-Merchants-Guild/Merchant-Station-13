/datum/deathmatch_loadout
	var/name = "Loadout"
	var/desc = ":KILL:"
	var/datum/outfit/outfit
	var/obj/item/weapon
	var/datum/species/default_species
	var/force_default = FALSE
	var/list/datum/species/blacklist

/datum/deathmatch_loadout/proc/equip(mob/living/carbon/player)
	if (default_species && (force_default || (player.dna.species in blacklist))
		player.set_species(default_species)
	player.equipOutfit(outfit, TRUE)

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

/datum/deathmatch_loadout/gunperative
	name = "Gunpeartive"
	desc = "A syndicate operative with a gun and a knife."
	outfit = /datum/outfit/syndicate_empty
	weapon = /obj/item/gun/ballistic/automatic/pistol

/datum/deathmatch_loadout/gunperative/special_equip(mob/living/carbon/player)
	for (var/I in 1 to 5)
		player.equip_to_slot(new /obj/item/ammo_box/magazine/m9mm, ITEM_SLOT_BACKPACK, TRUE)
	player.equip_to_slot(new /obj/item/kitchen/knife/combat, ITEM_SLOT_LPOCKET, TRUE)
