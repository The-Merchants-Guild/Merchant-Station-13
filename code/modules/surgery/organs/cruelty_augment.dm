/obj/item/organ/cyberimp/brain/skull_gun
	name = "anti-drop implant"
	desc = "Scoop up part of your skull and replace it with a mounted gun. Popular among completely braindead corporate mechs."
	var/active = 0
	var/list/stored_items = list()
	implant_color = "#DE7E00"
	slot = ORGAN_SLOT_BRAIN_ANTIDROP
	encode_info = AUGMENT_NT_HIGHLEVEL
	actions_types = list(/datum/action/item_action/organ_action/skull_gun)
	var/projectile_type = /obj/projectile/bullet/c10mm
	var/skull_damage = 7
	var/brain_damage = 3

/obj/item/organ/cyberimp/brain/skull_gun/proc/fire()
	var/obj/projectile/P = new projectile_type(owner.loc)
	P.firer = owner
	var/target = get_edge_target_turf(owner, owner.dir)
	P.preparePixelProjectile(target, owner)
	P.fire()
	var/mob/living/carbon/human/implanted = owner
	if (implanted)
		implanted.apply_damage(skull_damage, BRUTE, BODY_ZONE_HEAD)
		implanted.adjustOrganLoss(ORGAN_SLOT_BRAIN,  brain_damage)

/obj/item/organ/cyberimp/brain/skull_gun/emp_act()
	fire()

/datum/action/item_action/organ_action/skull_gun
	name = "Fire Skull Gun"
	icon_icon = 'icons/hud/actions.dmi'
	button_icon_state = "skull_gun"

/datum/action/item_action/organ_action/skull_gun/Trigger()
	. = ..()
	if(. && istype(target, /obj/item/organ/cyberimp/brain/skull_gun))
		var/obj/item/organ/cyberimp/brain/skull_gun/sgun = target
		sgun.fire()

/obj/item/organ/cyberimp/chest/biothruster
	name = "biothruster implant"
	desc = "Propel yourself forwards with a powerful jet of sticky liquid from holes on your back. This one uses the content of your stomach for fuel."
	slot = ORGAN_SLOT_THRUSTERS
	icon_state = "imp_jetpack"
	implant_overlay = null
	implant_color = null
	actions_types = list(/datum/action/item_action/organ_action/biothruster)
	w_class = WEIGHT_CLASS_NORMAL
	encode_info = AUGMENT_NT_HIGHLEVEL
	var/on = FALSE
	var/datum/effect_system/trail_follow/ion/ion_trail

/datum/action/item_action/organ_action/biothruster
	name = "Activate Biothruster"
	icon_icon = 'icons/hud/actions.dmi'
	button_icon_state = "biothruster"
	var/cooldown = 2 SECONDS
	var/on_cooldown
	var/stomachcost = 15
	var/jumpdistance = 2
	var/jumpspeed = 3

/datum/action/item_action/organ_action/biothruster/Trigger()
	if(!isliving(owner))
		return

	if(on_cooldown)
		to_chat(owner, span_warning("You must wait [timeleft(on_cooldown)*0.1] seconds to use [src] again!"))
		return
	new /obj/effect/decal/cleanable/vomit(get_turf(owner))
	if (owner.nutrition < stomachcost)
		to_chat(owner, span_warning("Your stomach contents are not enough to propel you forward"))
		return

	owner.adjust_nutrition(stomachcost)

	var/atom/target = get_edge_target_turf(owner, owner.dir)
	if (owner.throw_at(target, jumpdistance, jumpspeed, spin = FALSE, diagonals_first = FALSE))
		playsound(owner, 'sound/effects/splat.ogg', 50, TRUE, TRUE)
		owner.visible_message(span_warning("[usr] dashes forward propelled by a stream of vomit from their back!"))
		on_cooldown = addtimer(VARSET_CALLBACK(src, on_cooldown, null), cooldown , TIMER_STOPPABLE)
	else
		to_chat(owner, span_warning("Something prevents you from dashing forward!"))

/obj/item/organ/cyberimp/arm/item_set/gun/grappendix
	name = "grappendix"
	desc = "An additional external intestine used for climbing and swinging."
	icon = 'icons/hud/actions.dmi'
	icon_state = "biothruster"
	encode_info = AUGMENT_NT_HIGHLEVEL
	contents = newlist(/obj/item/gun/magic/grappendix)

/obj/item/gun/magic/grappendix
	name = "grappendix launcher"
	desc = "Fire out a sticky tentacles that grapples to surfaces and creatures, and pulls you towards them. Smooth, slick and strong."
	icon = 'icons/obj/changeling_items.dmi'
	icon_state = "tentacle"
	inhand_icon_state = "tentacle"
	lefthand_file = 'icons/mob/inhands/antag/changeling_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/changeling_righthand.dmi'
	item_flags = ABSTRACT | DROPDEL | NOBLUDGEON
	flags_1 = NONE
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = NONE
	ammo_type = /obj/item/ammo_casing/magic/grappendix
	fire_sound = 'sound/effects/splat.ogg'
	force = 0
	max_charges = 1
	fire_delay = 1
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0

/obj/item/gun/magic/grappendix/Initialize(mapload, silent)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CHANGELING_TRAIT)
	if(ismob(loc))
		if(!silent)
			loc.visible_message(span_warning("[loc.name]\'s arm starts stretching inhumanly!"), span_warning("Our arm twists and mutates, transforming it into a tentacle."), span_hear("You hear organic matter ripping and tearing!"))
		else
			to_chat(loc, span_notice("You prepare to extend a tentacle."))

/obj/item/gun/magic/grappendix/shoot_with_empty_chamber(mob/living/user as mob|obj)
	to_chat(user, span_warning("The [name] is not ready yet."))

/obj/item/gun/magic/grappendix/process_fire(atom/target, mob/living/user, message, params, zone_override, bonus_spread)
	. = ..()
	if(charges == 0)
		qdel(src)

/obj/item/gun/magic/grappendix/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] coils [src] tightly around [user.p_their()] neck! It looks like [user.p_theyre()] trying to commit suicide!"))
	return (OXYLOSS)

/obj/item/ammo_casing/magic/grappendix
	name = "grappendix"
	projectile_type = /obj/projectile/grappendix
	caliber = CALIBER_TENTACLE
	icon_state = "tentacle_end"
	firing_effect_type = null

/obj/projectile/grappendix
	name = "grappendix"
	icon_state = "tentacle_end"
	pass_flags = PASSTABLE
	damage = 0
	damage_type = BRUTE
	range = 12
	hitsound = 'sound/weapons/thudswoosh.ogg'
	var/chain

/obj/projectile/grappendix/Initialize()
	. = ..()

/obj/projectile/grappendix/fire(setAngle)
	if(firer)
		chain = firer.Beam(src, icon_state = "tentacle")
	..()

/obj/projectile/grappendix/on_hit(atom/target, blocked = FALSE)
	var/mob/living/carbon/human/H = firer
	new /datum/forced_movement(H, get_turf(target), 5, TRUE)

/obj/projectile/grappendix/Destroy()
	qdel(chain)
	return ..()

/obj/item/autosurgeon/organ/skull_gun
	uses = 1
	starting_organ = /obj/item/organ/cyberimp/brain/skull_gun

/obj/item/autosurgeon/organ/biothruster
	uses = 1
	starting_organ = /obj/item/organ/cyberimp/chest/biothruster

/obj/item/autosurgeon/organ/grappendix
	uses = 1
	starting_organ = /obj/item/organ/cyberimp/arm/item_set/gun/grappendix