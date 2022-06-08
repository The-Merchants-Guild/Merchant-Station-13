/obj/item/implant/skull_gun
	name = "skull gun implant"
	desc = "Returns you to the mothership."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "implant"
	activated = 1
	var/cooldown = 0.5 SECONDS
	var/on_cooldown
	var/projectile_type = /obj/projectile/bullet/c10mm
	var/skull_damage = 7
	var/brain_damage = 3

/obj/item/implant/skull_gun/activate()
	. = ..()
	if(on_cooldown)
		return
	var/obj/projectile/P = new projectile_type(imp_in.loc)
	P.firer = imp_in
	var/target = get_edge_target_turf(imp_in, imp_in.dir)
	P.preparePixelProjectile(target, imp_in)
	P.fire()
	imp_in.apply_damage(skull_damage, BRUTE, BODY_ZONE_HEAD)
	imp_in.adjustOrganLoss(ORGAN_SLOT_BRAIN,  brain_damage)
	on_cooldown = addtimer(VARSET_CALLBACK(src, on_cooldown, null), cooldown , TIMER_STOPPABLE)

/obj/item/implanter/skull_gun
	name = "implanter (skull gun)"
	imp_type = /obj/item/implant/skull_gun
	
/obj/item/implant/biothruster
	name = "biothruster implant"
	desc = "Returns you to the mothership."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "implant"
	activated = 1
	var/cooldown = 6 SECONDS
	var/on_cooldown
	var/stomachcost = 15
	var/jumpdistance = 2
	var/jumpspeed = 3

/obj/item/implant/biothruster/activate()
	if(!isliving(imp_in))
		return
		
	if(on_cooldown)
		to_chat(imp_in, span_warning("You must wait [timeleft(on_cooldown)*0.1] seconds to use [src] again!"))
		return
	new /obj/effect/decal/cleanable/vomit(get_turf(imp_in))	
	if (imp_in.nutrition < stomachcost)
		to_chat(imp_in, span_warning("Your stomach contents are not enough to propel you forward"))
		return
		
	imp_in.adjust_nutrition(stomachcost)

	var/atom/target = get_edge_target_turf(imp_in, imp_in.dir) 
	if (imp_in.throw_at(target, jumpdistance, jumpspeed, spin = FALSE, diagonals_first = FALSE))		
		playsound(src, 'sound/effects/splat.ogg', 50, TRUE, TRUE)
		imp_in.visible_message(span_warning("[usr] dashes forward propelled by a stream of vomit from their back!"))
		on_cooldown = addtimer(VARSET_CALLBACK(src, on_cooldown, null), cooldown , TIMER_STOPPABLE)
	else
		to_chat(imp_in, span_warning("Something prevents you from dashing forward!"))
		
/obj/item/implanter/biothruster
	name = "implanter (biothruster)"
	imp_type = /obj/item/implant/biothruster

/obj/item/implant/spell/grappendix
	name = "spell implant"
	desc = "Allows you to cast a spell as if you were a wizard."
	spell = /obj/effect/proc_holder/spell/aimed/grappendix
	
/obj/effect/proc_holder/spell/aimed/grappendix
	name = "Lightning Bolt"
	desc = "Fire a lightning bolt at your foes! It will jump between targets, but can't knock them down."
	school = SCHOOL_EVOCATION
	charge_max = 100
	invocation = "P'WAH, UNLIM'TED P'WAH"
	invocation_type = INVOCATION_SHOUT
	cooldown_min = 6 SECONDS
	base_icon_state = "lightning"
	action_icon_state = "lightning0"
	sound = 'sound/magic/lightningbolt.ogg'
	active = FALSE
	projectile_var_overrides = list("zap_range" = 15, "zap_power" = 20000, "zap_flags" = ZAP_MOB_DAMAGE)
	active_msg = "You energize your hands with arcane lightning!"
	deactive_msg = "You let the energy flow out of your hands back into yourself..."
	projectile_type = /obj/projectile/grappendix

/obj/projectile/grappendix
	name = "tentacle"
	icon_state = "tentacle_end"
	pass_flags = PASSTABLE
	damage = 0
	damage_type = BRUTE
	range = 8
	hitsound = 'sound/weapons/thudswoosh.ogg'
	var/chain
	var/obj/item/ammo_casing/magic/tentacle/source //the item that shot it
	///Click params that were used to fire the tentacle shot
	var/list/fire_modifiers

/obj/projectile/grappendix/Initialize()
	source = loc
	. = ..()

/obj/projectile/grappendix/fire(setAngle)
	if(firer)
		chain = firer.Beam(src, icon_state = "tentacle")
	..()

/obj/projectile/tentacle/on_hit(atom/target, blocked = FALSE)
	var/mob/living/carbon/human/H = firer
	new /datum/forced_movement(H, get_turf(firer), 5, TRUE)

/obj/projectile/grappendix/Destroy()
	qdel(chain)
	source = null
	return ..()
	
/obj/item/implanter/grappendix
	name = "implanter (grappendix)"
	imp_type = /obj/item/implant/spell/grappendix