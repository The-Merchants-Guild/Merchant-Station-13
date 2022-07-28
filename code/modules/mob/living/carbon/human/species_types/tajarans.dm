/datum/species/human/felinid/tarajan //YOU THINK YOU'RE GOING TO GET TO PLAY AS A CATGIRL? LMAO
	name = "Catbeast"
	id = "tarajan"
	limbs_id = null
	say_mod = "meows"
	sexes = 1
	species_traits = list(MUTCOLORS,EYECOLOR,NOTRANSSTING)
	inherent_biotypes = list(MOB_ORGANIC, MOB_HUMANOID)
	inherent_traits  = list(TRAIT_PACIFISM, TRAIT_CLUMSY)
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	mutant_bodyparts = list("tail_human" = /obj/item/organ/tail/cat/tcat)
	mutantears = /obj/item/organ/ears/cat/tcat
	meat = /obj/item/food/meat/slab/human/mutant/cat
	skinned_type = /obj/item/stack/sheet/animalhide/cat
	exotic_bloodtype = "O-" //universal donor, more reason to drain their blood
	burnmod = 1.25
	brutemod = 1.25

/datum/species/human/felinid/tarajan/on_species_gain(mob/living/carbon/human/C, datum/species/old_species, pref_load)
	C.draw_autistic_parts()
	. = ..()

/datum/species/human/felinid/tarajan/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	C.draw_autistic_parts(TRUE)
	. = ..()
