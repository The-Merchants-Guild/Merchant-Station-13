/datum/species/squid
	name = "Squidperson"
	id = "squid"
	say_mod = "spits out"
	default_color = "b8dfda"
	species_traits = list(MUTCOLORS,EYECOLOR,HAS_FLESH,HAS_BONE,LIPS)
	inherent_traits = list(TRAIT_ADVANCEDTOOLUSER,TRAIT_CAN_STRIP,TRAIT_CAN_USE_FLIGHT_POTION)
	payday_modifier = 0.75
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	use_skintones = 0
	mutant_organs = list(/obj/item/organ/butt)
	no_equip = list(ITEM_SLOT_FEET)
	skinned_type = /obj/item/stack/sheet/animalhide/human
	ass_image = 'icons/ass/asssquid.png'
	special_step_sounds = list('sound/effects/footstep/squidwalk1.ogg', 'sound/effects/footstep/squidwalk2.ogg' )
	attack_verb = "slap"
	attack_sound = 'sound/weapons/whip.ogg'
	miss_sound = 'sound/weapons/whipmiss.ogg'
	grab_sound = 'sound/weapons/whipgrab.ogg'
	disliked_food = FRIED

/mob/living/carbon/human/species/squid
	race = /datum/species/squid

/datum/species/squid/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_squid_name(genderToFind = gender)

	var/randname = squid_name(gender)

	if(lastname)
		randname += " [lastname]"

	return randname

/proc/random_unique_squid_name(attempts_to_find_unique_name=10, genderToFind)
	for(var/i in 1 to attempts_to_find_unique_name)
		. = capitalize(squid_name(genderToFind))
		if(!findname(.))
			break