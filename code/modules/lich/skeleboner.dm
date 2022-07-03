//Originally coded for Hippiestation by ghost, a deleted github account. Rip Bozo, will not be missed.

//I'm uh not sure if defining a species as a subtype of another species fucks something up, so I'm just gonna define the lich species alone.
/datum/species/lich
	name = "Lich"
	id = SPECIES_LICH
	species_traits = list(NOTRANSSTING, NOZOMBIE, NO_DNA_COPY, NOEYESPRITES, AGENDER, NO_UNDERWEAR, TRAIT_NOFLASH, MUTCOLORS)
	inherent_traits = list(TRAIT_NOBREATH, TRAIT_NOHUNGER, TRAIT_RESISTCOLD, TRAIT_RESISTHEAT, TRAIT_NOLIMBDISABLE, TRAIT_NODISMEMBER, TRAIT_RESISTHIGHPRESSURE,
		TRAIT_RESISTLOWPRESSURE, TRAIT_STABLEHEART, TRAIT_VIRUSIMMUNE, TRAIT_STUNIMMUNE, TRAIT_SLEEPIMMUNE, TRAIT_PUSHIMMUNE, TRAIT_NOGUNS, TRAIT_PIERCEIMMUNE,
		TRAIT_SHOCKIMMUNE, TRAIT_RADIMMUNE)
	inherent_biotypes = MOB_UNDEAD|MOB_HUMANOID
	mutanttongue = /obj/item/organ/tongue/bone
	mutantstomach = /obj/item/organ/stomach/bone
	changesource_flags = MIRROR_BADMIN
	say_mod = "rattles"
	limbs_id = "skeleton"
	damage_overlay_type = ""
	species_language_holder = /datum/language_holder/skeleton
	mutanteyes = /obj/item/organ/eyes/night_vision/alien/lich
	sexes = FALSE

/datum/species/lich/on_species_gain(mob/living/carbon/human/C, datum/species/old_species, pref_load)
	. = ..()
	C.set_safe_hunger_level()

/datum/species/lich/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()

/datum/species/lich/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H, delta_time, times_fired)
	. = ..()
	if(chem.type == /datum/reagent/toxin/bonehurtingjuice)
		H.adjustStaminaLoss(7.5 * REAGENTS_EFFECT_MULTIPLIER * delta_time, 0)
		H.adjustBruteLoss(0.5 * REAGENTS_EFFECT_MULTIPLIER * delta_time, 0)
		if(DT_PROB(10, delta_time))
			switch(rand(1, 3))
				if(1)
					H.say(pick("oof.", "ouch.", "my bones.", "oof ouch.", "oof ouch my bones."), forced = /datum/reagent/toxin/bonehurtingjuice)
				if(2)
					H.manual_emote(pick("oofs silently.", "looks like [H.p_their()] bones hurt.", "grimaces, as though [H.p_their()] bones hurt."))
				if(3)
					to_chat(H, span_warning("Your bones hurt!"))
		if(chem.overdosed)
			if(DT_PROB(2, delta_time) && iscarbon(H)) //big oof
				var/selected_part = pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG) //God help you if the same limb gets picked twice quickly.
				var/obj/item/bodypart/bp = H.get_bodypart(selected_part)
				if(bp)
					playsound(H, get_sfx("desecration"), 50, TRUE, -1) //You just want to socialize
					H.visible_message(span_warning("[H] rattles loudly and flails around!!"), span_danger("Your bones hurt so much that your missing muscles spasm!!"))
					H.say("OOF!!", forced=/datum/reagent/toxin/bonehurtingjuice)
					bp.receive_damage(200, 0, 0)
				else
					to_chat(H, span_warning("Your missing arm aches from wherever you left it."))
					H.emote("sigh")
		H.reagents.remove_reagent(chem.type, chem.metabolization_rate * delta_time)
		return TRUE


/obj/item/clothing/head/lich
	name = "Crown of Bones"
	desc = "An unholy crown fashioned out of sinful bones. It currently has ."
	worn_icon = 'icons/mob/large-worn-icons/64x64/head.dmi'
	icon_state = "lich"
	worn_icon_state = "lich"
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL | LARGE_WORN_ICON
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_HELM_MAX_TEMP_PROTECT
	armor = list("melee" = 50, "bullet" = 65, "laser" = 65, "energy" = 45, "bomb" = 100, "bio" = 30, "rad" = 30, "fire" = 70, "acid" = 30)

/obj/item/clothing/head/lich/equipped(mob/user, slot)
	if(slot == ITEM_SLOT_HEAD)
		ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)
		item_flags |= DROPDEL
	return ..()

/obj/item/clothing/suit/lich
	name = "Soul-forged Armor"
	desc = "Robust-looking armor forged from steel mixed with souls. Screams of the tormented spontaneously manifest around it."
	icon_state = "lich"
	worn_icon_state = "lich"
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	armor = list("melee" = 50, "bullet" = 65, "laser" = 65, "energy" = 45, "bomb" = 100, "bio" = 30, "rad" = 30, "fire" = 70, "acid" = 30)

/obj/item/clothing/under/lich
	name = "doublet"
	desc = "A comfortable-looking doublet, made out of the finest wool."
	icon = 'icons/obj/clothing/under/costume.dmi'
	worn_icon =  'icons/mob/clothing/under/costume.dmi'
	icon_state = "doublet"
	worn_icon_state = "doublet"
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL
	has_sensor = NO_SENSORS
	can_adjust = 0

/obj/item/clothing/shoes/lich
	name = "fur boots"
	desc = "Hey, since when is fur purple?"
	icon_state = "lich"
	worn_icon_state = "lich"
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL


/mob/living/carbon/human/ex_act(severity, target, origin)
	if(super_leaping)
		return
	return ..()
