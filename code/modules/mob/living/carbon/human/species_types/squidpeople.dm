/datum/species/squid
	name = "Squidperson"
	id = "squid"
	say_mod = "spits out"
	default_color = "b8dfda"
	species_traits = list(MUTCOLORS,EYECOLOR,HAS_FLESH,HAS_BONE,LIPS)
	inherent_traits = list(TRAIT_ADVANCEDTOOLUSER,TRAIT_CAN_STRIP,TRAIT_CAN_USE_FLIGHT_POTION)
	payday_modifier = 0.75
//	default_features = list("mcolor" = "FFF") // bald
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
//	nojumpsuit = TRUE

/mob/living/carbon/human/species/squid
	race = /datum/species/squid

//	/datum/species/squid/qualifies_for_rank(rank, list/features)
//		return TRUE

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

/datum/mood_event/squid //april 1st only
	description = "<span class='nicegreen'>Spongebob isn't on this station with me.</span>\n" //Used for syndies, nukeops etc so they can focus on their goals
	mood_change = 0
	hidden = FALSE
