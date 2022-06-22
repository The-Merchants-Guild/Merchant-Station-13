/obj/item/forged
	icon = 'icons/obj/forged_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	var/datum/reagent/reagent_type
	var/weapon_type
	var/identifier = FORGED_MELEE_SINGLEHANDED
	var/stabby = 0
	var/speed = CLICK_CD_MELEE
	var/list/special_traits
	var/radioactive = FALSE
	var/fire = FALSE


/obj/item/forged/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()


/obj/item/forged/process()
	if(prob(50) && radioactive)
		radiation_pulse(src, 200, 0.5)
	if(fire)
		open_flame()


/obj/item/forged/proc/assign_properties()
	if(reagent_type && weapon_type)
		special_traits = list()
		name = name += " ([reagent_type.name])"
		color = reagent_type.color
		force = max(0.1, (reagent_type.density * weapon_type))
		throwforce = force
		speed = max(CLICK_CD_RAPID, (reagent_type.density * weapon_type))
		for(var/I in reagent_type.special_traits)
			var/datum/special_trait/S = new I
			LAZYADD(special_traits, S)
			S.on_apply(src, identifier)
		armour_penetration += force * 0.2

/obj/item/forged/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	user.changeNext_move(speed)
	if(iscarbon(target) && reagent_type && proximity_flag)
		var/mob/living/carbon/C = target
		var/obj/item/bodypart/affecting = C.get_bodypart(check_zone(user.zone_selected))
		var/armour_block = C.getarmor(affecting, "melee") * 0.01
		if(!armour_block)
			armour_block = 1
		C.reagents.add_reagent(reagent_type.type, max(0, (0.2 * stabby) * max(1, armour_block - armour_penetration)))
		if(stabby < 1 && stabby > 0)
			reagent_type.expose_mob(C, TOUCH, max(0, 1 / stabby))
	if(proximity_flag && reagent_type)
		for(var/I in special_traits)
			var/datum/special_trait/A = I
			if(prob(A.effectiveness))
				A.on_hit(target, user, src, FORGED_MELEE_SINGLEHANDED)
	..()

/obj/item/forged/melee/dagger
	name = "forged dagger"
	desc = "A custom dagger forged from solid ingots"
	icon_state = "forged_knife"
	inhand_icon_state = "forged_dagger"
	hitsound = 'sound/weapons/knife.ogg'
	weapon_type = MELEE_TYPE_DAGGER
	stabby = TRANSFER_SHARP
	w_class = WEIGHT_CLASS_SMALL
	sharpness = SHARP_POINTY
	attack_verb_simple = list("poked", "prodded", "stabbed", "pierced", "gashed", "punctured")
	attack_verb_continuous = list("poked", "prodded", "stabbed", "pierced", "gashed", "punctured")
	embedding = list("embed_chance" = 30, "embedded_pain_multiplier" = 0.25, "embedded_fall_pain_multiplier" = 1, "embedded_impact_pain_multiplier" = 0.75, "embedded_unsafe_removal_pain_multiplier" = 1.25)

/obj/item/forged/melee/sword
	name = "forged sword"
	desc = "A custom sword forged from solid ingots"
	icon_state = "forged_sword"
	inhand_icon_state = "forged_sword"
	worn_icon_state = "forged_sword"
	slot_flags = ITEM_SLOT_BELT
	hitsound = 'sound/weapons/rapierhit.ogg'
	weapon_type = MELEE_TYPE_SWORD
	stabby = TRANSFER_SHARPER
	w_class = WEIGHT_CLASS_BULKY
	sharpness = SHARP_EDGED
	attack_verb_simple = list("slashed", "sliced", "stabbed", "pierced", "diced", "run-through")
	attack_verb_continuous = list("slashed", "sliced", "stabbed", "pierced", "diced", "run-through")
	embedding = list("embed_chance" = 10, "embedded_pain_multiplier" = 1.25, "embedded_fall_pain_multiplier" = 1.5, "embedded_impact_pain_multiplier" = 1.2, "embedded_unsafe_removal_pain_multiplier" = 1.5)

/obj/item/forged/melee/mace
	name = "forged mace"
	desc = "A custom mace forged from solid ingots"
	icon_state = "forged_mace"
	inhand_icon_state = "forged_mace"
	worn_icon_state = "forged_mace"
	slot_flags = ITEM_SLOT_BELT
	hitsound = 'sound/misc/crunch.ogg'
	weapon_type = MELEE_TYPE_MACE
	stabby = TRANSFER_PARTIALLY_BLUNT
	w_class = WEIGHT_CLASS_BULKY
	attack_verb_simple = list("beat", "bludgeon")
	attack_verb_continuous = list("beat", "bludgeon")
	embedding = list("embed_chance" = 1, "embedded_pain_multiplier" = 2, "embedded_fall_pain_multiplier" = 2.5, "embedded_impact_pain_multiplier" = 3, "embedded_unsafe_removal_pain_multiplier" = 2.5)
	armour_penetration = 5


/obj/item/twohanded/forged
	icon = 'icons/obj/forged_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	var/datum/reagent/reagent_type
	var/weapon_type = MELEE_TYPE_GREATSWORD
	var/identifier = FORGED_MELEE_TWOHANDED
	var/stabby = 0
	var/speed = CLICK_CD_MELEE
	var/list/special_traits
	var/radioactive = FALSE
	var/fire = FALSE
	var/two_hand_force
	var/force_unwielded = 0
	var/force_wielded = 0
	var/wielded = FALSE

/obj/item/twohanded/forged/warhammer/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=force_unwielded, force_wielded=force_wielded, icon_wielded="forged_hammer1")

/obj/item/twohanded/forged/greatsword/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=force_unwielded, force_wielded=force_wielded)

/obj/item/twohanded/forged/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()


/obj/item/twohanded/forged/process()
	if(prob(50) && radioactive)
		radiation_pulse(src, 200, 0.5)
	if(fire)
		open_flame()


/obj/item/twohanded/forged/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, .proc/on_wield)
	RegisterSignal(src, COMSIG_TWOHANDED_UNWIELD, .proc/on_unwield)

/obj/item/twohanded/forged/proc/on_wield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = TRUE
	force = force_wielded

/obj/item/twohanded/forged/proc/on_unwield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = FALSE
	force = force_unwielded

/obj/item/twohanded/forged/proc/assign_properties()
	if(reagent_type && weapon_type)
		special_traits = list()
		name = name += " ([reagent_type.name])"
		color = reagent_type.color
		force_wielded = max(0.1, (reagent_type.density * weapon_type))
		force_unwielded = max(0.1, force_wielded / 3)
		throwforce = force_unwielded
		speed = max(CLICK_CD_RAPID, (reagent_type.density * weapon_type))
		for(var/I in reagent_type.special_traits)
			var/datum/special_trait/S = new I
			LAZYADD(special_traits, S)
			S.on_apply(src, identifier)
		armour_penetration += force_wielded * 0.2


/obj/item/twohanded/forged/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	user.changeNext_move(speed)
	if(iscarbon(target) && reagent_type && proximity_flag)
		var/mob/living/carbon/C = target
		var/obj/item/bodypart/affecting = C.get_bodypart(check_zone(user.zone_selected))
		var/armour_block = C.getarmor(affecting, "melee") * 0.01
		if(!armour_block)
			armour_block = 1
		C.reagents.add_reagent(reagent_type.type, max(0, (0.2 * stabby) * max(1, armour_block - armour_penetration)))
		if(stabby < 1 && stabby > 0)
			reagent_type.expose_mob(C, TOUCH, max(0, 1 / stabby))
	if(proximity_flag && reagent_type)
		for(var/I in special_traits)
			var/datum/special_trait/A = I
			if(prob(A.effectiveness))
				A.on_hit(target, user, src, FORGED_MELEE_TWOHANDED)
	..()

/obj/item/twohanded/forged/greatsword
	name = "forged greatsword"
	desc = "A custom greatsword forged from solid ingots"
	icon_state = "forged_greatsword"
	inhand_icon_state = "forged_sword"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	hitsound = 'sound/weapons/slash.ogg'
	weapon_type = MELEE_TYPE_GREATSWORD
	stabby = TRANSFER_SHARPEST
	w_class = WEIGHT_CLASS_HUGE
	sharpness = SHARP_EDGED
	attack_verb_simple = list("gored", "impaled", "stabbed", "slashed", "torn", "run-through")
	attack_verb_continuous = list("gored", "impaled", "stabbed", "slashed", "torn", "run-through")
	embedding = list("embed_chance" = 5, "embedded_pain_multiplier" = 1.75, "embedded_fall_pain_multiplier" = 2, "embedded_impact_pain_multiplier" = 2, "embedded_unsafe_removal_pain_multiplier" = 1.5)

/obj/item/twohanded/forged/greatsword/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	..()
	if(iscarbon(user) && proximity_flag)
		var/mob/living/carbon/CU = user
		CU.adjustStaminaLoss(10)


/obj/item/twohanded/forged/warhammer
	name = "forged warhammer"
	desc = "A custom warhammer forged from solid ingots"
	icon_state = "forged_hammer0"
	worn_icon_state = "forged_hammer0"
	base_icon_state = "forged_hammer0"
	slot_flags = ITEM_SLOT_BACK
	hitsound = 'sound/misc/crunch.ogg'
	weapon_type = MELEE_TYPE_WARHAMMER
	stabby = TRANSFER_BLUNT
	w_class = WEIGHT_CLASS_HUGE
	attack_verb_simple = list("crushed", "flattened", "bludgeoned", "pulverised", "shattered")
	armour_penetration = 10

/obj/item/twohanded/forged/warhammer/on_unwield(obj/item/source, mob/user)
	. = ..()
	icon_state = base_icon_state


/obj/item/twohanded/forged/warhammer/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	..()
	if(iscarbon(user) && proximity_flag && target)
		var/mob/living/carbon/CU = user
		CU.adjustStaminaLoss(15)

	if(iswallturf(target) && proximity_flag)
		var/turf/closed/wall/W = target
		var/chance = (force_wielded + W.hardness * 0.5)//>lower hardness = stronger wall
		if(chance < 10)
			return FALSE

		if(prob(chance))
			playsound(src, 'sound/misc/bustconcrete1.ogg', 100, 1) //wonder where this is from!
			W.dismantle_wall(TRUE)

		else
			playsound(src, 'sound/misc/bustconcrete2.ogg', 50, 1)
			W.add_dent(WALL_DENT_HIT)
			visible_message("<span class='danger'>[user] has smashed [W] with [src]!</span>", null, COMBAT_MESSAGE_RANGE)
	return TRUE


/obj/projectile/bullet/forged
	damage = 0
	hitsound_wall = "ricochet"
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	var/datum/reagent/reagent_type
	var/identifier = FORGED_BULLET_CASING
	speed = 0.8
	var/list/special_traits
	var/radioactive = FALSE
	var/fire = FALSE


/obj/projectile/bullet/forged/proc/assign_properties(datum/reagent/reagent_type, caliber_multiplier)
	if(reagent_type)
		special_traits = list()
		name = name += " ([reagent_type.name])"
		color = reagent_type.color
		damage = max(0.1, (reagent_type.density * 1.5 * caliber_multiplier))
		speed = max(0, reagent_type.density / 2.5)
		for(var/I in reagent_type.special_traits)
			var/datum/special_trait/S = new I
			LAZYADD(special_traits, S)
			S.on_apply(src, identifier)


/obj/projectile/bullet/forged/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(reagent_type)
		for(var/I in special_traits)
			var/datum/special_trait/A = I
			if(prob(A.effectiveness))
				A.on_hit(target, I = src, type = identifier)
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		var/limb_hit =  C.check_limb_hit(def_zone)
		var/armour_block = C.getarmor(limb_hit, "bullet") * 0.01
		if(!armour_block)
			armour_block = 1
		C.reagents.add_reagent(reagent_type.type, max(0, 1 * max(1, armour_block - armour_penetration)))
		reagent_type.expose_mob(C, TOUCH, 1)

//fuck tg
/obj/projectile/bullet/forged/proc/open_flame(flame_heat=700)
	var/turf/location = loc
	if(ismob(location))
		var/mob/M = location
		var/success = FALSE
		if(src == M.get_item_by_slot(ITEM_SLOT_MASK))
			success = TRUE
		if(success)
			location = get_turf(M)
	if(isturf(location))
		location.hotspot_expose(flame_heat, 5)


/obj/projectile/bullet/forged/Move()
	. = ..()
	if(!QDELETED(src))
		for(var/I in special_traits)
			var/datum/special_trait/A = I
			if(prob(A.effectiveness))
				A.on_hit(I = src, type = identifier)

		if(radioactive)
			radiation_pulse(src, 300)

		if(fire)
			open_flame()
		var/turf/location = get_turf(src)
		if(location && reagent_type)
			reagent_type.expose_turf(location, 1)


/obj/item/ammo_casing/forged
	name = "forged bullet casing"
	desc = "A custom bullet casing designed to be quickly changeable to any caliber. Using it in-hand also transforms all of the casings on your tile."
	projectile_type = /obj/projectile/bullet/forged
	var/datum/reagent/reagent_type
	var/static/list/calibers = list(".357" = 4.5, "a762" = 5, "n762" = 5, ".50" = 6, ".38" = 1.5, "10mm" = 3, "9mm" = 2, "4.6x30mm" = 2, ".45" = 2.5, "a556" = 3.5, "mm195129" = 4.5, "shotgun" = 3.5)


/obj/item/ammo_casing/forged/proc/assign_properties()//placeholder proc to prevent runtimes, this SHOULD be the only exception to the rule
	if(reagent_type)
		name = "([reagent_type.name]-[caliber] bullet casing)"
	return


/obj/item/ammo_casing/forged/attack_self(mob/user)
	..()
	if(!caliber)
		caliber = input("Shape the bullet to which caliber? (You may only do this once!)", "Transform", caliber) as null|anything in calibers
		if(loaded_projectile)
			var/obj/projectile/bullet/forged/FF = loaded_projectile
			FF.reagent_type = reagent_type
			FF.assign_properties(reagent_type, calibers[caliber])
			desc = "A custom [caliber] bullet casing"
			assign_properties()
			var/turf/T = get_turf(user)
			for(var/obj/item/ammo_casing/forged/F in T)
				if(F == src)
					continue
				var/obj/projectile/bullet/forged/FK = F.loaded_projectile
				FK.reagent_type = reagent_type
				FK.assign_properties(reagent_type, calibers[caliber])
				F.caliber = caliber
				F.desc = desc
				F.assign_properties()
