/datum/deathmatch_loadout
	var/name = "Loadout"
	var/desc = ":KILL:"
	var/datum/outfit/outfit
	var/obj/item/weapon
	var/datum/species/default_species
	var/force_default = FALSE
	var/list/datum/species/blacklist

/datum/deathmatch_loadout/proc/equip(mob/living/carbon/player)
	SHOULD_CALL_PARENT(TRUE)
	if (default_species && (force_default || (player.dna.species in blacklist)))
		player.set_species(default_species)
	player.equipOutfit(outfit, TRUE)
	if (weapon)
		player.equip_to_slot(new weapon, ITEM_SLOT_HANDS, TRUE)

/datum/deathmatch_loadout/assistant
	name = "Assistant loadout"
	desc = "A simple assistant loadout: greyshirt and a toolbox"
	default_species = /datum/species/human
	outfit = /datum/outfit/job/assistant
	weapon = /obj/item/storage/toolbox/mechanical/old/empty

/datum/deathmatch_loadout/assistant/weaponless
	name = "Assistant loadout (Weaponless)"
	desc = "What is an assistant without a toolbox? nothing"
	outfit = /datum/outfit/job/assistant

/datum/deathmatch_loadout/gunperative
	name = "Gunpeartive"
	desc = "A syndicate operative with a gun and a knife."
	default_species = /datum/species/human
	outfit = /datum/outfit/syndicate_empty
	weapon = /obj/item/gun/ballistic/automatic/pistol

/datum/deathmatch_loadout/gunperative/equip(mob/living/carbon/player)
	. = ..()
	for (var/I in 1 to 5)
		player.equip_to_slot(new /obj/item/ammo_box/magazine/m9mm, ITEM_SLOT_BACKPACK, TRUE)
	player.equip_to_slot(new /obj/item/kitchen/knife/combat, ITEM_SLOT_LPOCKET, TRUE)
