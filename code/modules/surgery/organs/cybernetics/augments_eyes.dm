/obj/item/organ/cyberimp/eyes
	name = "cybernetic eye implant"
	desc = "Implants for your eyes."
	icon_state = "eye_implant"
	implant_overlay = "eye_implant_overlay"
	encode_info = AUGMENT_NT_LOWLEVEL
	slot = ORGAN_SLOT_EYES
	zone = BODY_ZONE_PRECISE_EYES
	w_class = WEIGHT_CLASS_TINY

// HUD implants
/obj/item/organ/cyberimp/eyes/hud
	name = "HUD implant"
	desc = "These cybernetic eyes will display a HUD over everything you see. Maybe."
	slot = ORGAN_SLOT_HUD
	var/HUD_type = 0
	var/HUD_trait = null

/obj/item/organ/cyberimp/eyes/hud/update_implants()
	. = ..()
	if(!check_compatibility())
		if(HUD_type)
			var/datum/atom_hud/H = GLOB.huds[HUD_type]
			H.remove_hud_from(owner)
		if(HUD_trait)
			REMOVE_TRAIT(owner, HUD_trait, ORGAN_TRAIT)
		return
	if(HUD_type)
		var/datum/atom_hud/H = GLOB.huds[HUD_type]
		H.add_hud_to(owner)
	if(HUD_trait)
		ADD_TRAIT(owner, HUD_trait, ORGAN_TRAIT)

/obj/item/organ/cyberimp/eyes/hud/Insert(mob/living/carbon/M, special = 0, drop_if_replaced = FALSE)
	..()
	if(!check_compatibility())
		to_chat(owner, "<span class='warning'>The Neuralink beeps: ERR01 INCOMPATIBLE IMPLANT</span>")
		return
	if(HUD_type)
		var/datum/atom_hud/H = GLOB.huds[HUD_type]
		H.add_hud_to(M)
	if(HUD_trait)
		ADD_TRAIT(M, HUD_trait, ORGAN_TRAIT)

/obj/item/organ/cyberimp/eyes/hud/Remove(mob/living/carbon/M, special = 0)
	if(HUD_type)
		var/datum/atom_hud/H = GLOB.huds[HUD_type]
		H.remove_hud_from(M)
	if(HUD_trait)
		REMOVE_TRAIT(M, HUD_trait, ORGAN_TRAIT)
	..()

/obj/item/organ/cyberimp/eyes/hud/medical
	name = "Medical HUD implant"
	desc = "These cybernetic eye implants will display a medical HUD over everything you see."
	HUD_type = DATA_HUD_MEDICAL_ADVANCED
	HUD_trait = TRAIT_MEDICAL_HUD

/obj/item/organ/cyberimp/eyes/hud/security
	name = "Security HUD implant"
	desc = "These cybernetic eye implants will display a security HUD over everything you see."
	HUD_type = DATA_HUD_SECURITY_ADVANCED
	HUD_trait = TRAIT_SECURITY_HUD

/obj/item/organ/cyberimp/eyes/hud/diagnostic
	name = "Diagnostic HUD implant"
	desc = "These cybernetic eye implants will display a diagnostic HUD over everything you see."
	HUD_type = DATA_HUD_DIAGNOSTIC_ADVANCED

/obj/item/organ/cyberimp/eyes/hud/security/syndicate
	name = "Contraband Security HUD Implant"
	desc = "A Cybersun Industries brand Security HUD Implant. These illicit cybernetic eye implants will display a security HUD over everything you see."
	syndicate_implant = TRUE
	encode_info = AUGMENT_SYNDICATE_LEVEL

/obj/item/organ/cyberimp/eyes/hud/sensor
	name = "Interdyne Sensor Field Visualizer"
	desc = "This medical implant will allow you to see sensor signals of dead people that are nearby, very useful for paramedics."
	HUD_type = DATA_HUD_SENSORS
	HUD_trait = TRAIT_SENSOR_HUD
	encode_info = AUGMENT_TG_LEVEL


