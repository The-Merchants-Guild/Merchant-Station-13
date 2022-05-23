/obj/item/mecha_parts/mecha_equipment/drill/makeshift
	name = "Makeshift exosuit drill"
	desc = "Cobbled together from likely stolen parts, this drill is nowhere near as effective as the real deal."
	equip_cooldown = 60 //Its slow as shit
	force = 10 //Its not very strong
	drill_delay = 15

/obj/item/mecha_parts/mecha_equipment/drill/makeshift/can_attach(obj/vehicle/sealed/mecha/M as obj)
	if(istype(M, /obj/vehicle/sealed/mecha/makeshift))
		return TRUE
	return FALSE

/obj/item/mecha_parts/mecha_equipment/hydraulic_clamp/makeshift
	name = "makeshift clamp"
	desc = "Loose arrangement of cobbled together bits resembling a clamp."
	equip_cooldown = 25
	clamp_damage = 10

/obj/item/mecha_parts/mecha_equipment/hydraulic_clamp/makeshift/can_attach(obj/vehicle/sealed/mecha/M as obj)
	if(istype(M, /obj/vehicle/sealed/mecha/makeshift))
		return TRUE
	return FALSE

/obj/item/mecha_parts/mecha_equipment/flamethrower
	name = "modified flamethrower"
	desc = "A flamethrower which fits in a mech, what could possibly go wrong!"
	icon = 'icons/obj/flamethrower.dmi'
	icon_state = "flamethrowerbase"
	inhand_icon_state = "flamethrower_0"
	lefthand_file = 'icons/mob/inhands/weapons/flamethrower_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/flamethrower_righthand.dmi'
	flags_1 = CONDUCT_1
	force = 3
	throwforce = 10
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_NORMAL
	custom_materials = list(/datum/material/iron=500)
	resistance_flags = FIRE_PROOF
	trigger_guard = TRIGGER_GUARD_NORMAL
	light_system = MOVABLE_LIGHT
	//light is always on
	light_on = TRUE
	range = MECHA_MELEE|MECHA_RANGED
	var/status = FALSE
	//its always on ready to be ignited
	var/lit = TRUE
	//cooldown
	var/operating = FALSE
	var/obj/item/weldingtool/weldtool = null
	var/obj/item/assembly/igniter/igniter = null
	var/obj/item/tank/internals/plasma/ptank = null
	//it always comes with the full parts
	var/create_full = TRUE
	var/create_with_tank = FALSE
	var/igniter_type = /obj/item/assembly/igniter
	var/acti_sound = 'sound/items/welderactivate.ogg'
	var/deac_sound = 'sound/items/welderdeactivate.ogg'

						//Can only fit in the lockermech
/obj/item/mecha_parts/mecha_equipment/flamethrower/can_attach(obj/vehicle/sealed/mecha/M as obj)
	if(istype(M, /obj/vehicle/sealed/mecha/makeshift))
		return TRUE
	return FALSE

				/* Code for handling modified flamethrower ignition */

		//modified flamethrower can only be ignited with a mech -> action() makes sure of that
/obj/item/mecha_parts/mecha_equipment/flamethrower/action(mob/source, atom/target, params)
	if(!action_checks(target) || get_dist(chassis, target)>3)
		return
	if(ishuman(source))
		//does he have permission to trigger the gun?
		if(!can_trigger_gun(source))
			return
	//does he have pacifism?
	if(HAS_TRAIT(source, TRAIT_PACIFISM))
		to_chat(source, span_warning("You can't bring yourself to fire \the [src]! You don't want to risk harming anyone..."))
		return
	if(target)
		var/turflist = getline(source, target)
		log_combat(source, target, "flamethrowered", src)
		flame_turf(turflist)


/obj/item/mecha_parts/mecha_equipment/flamethrower/proc/flame_turf(turflist)
	if(operating)
		return
	operating = TRUE
	for(var/turf/T in turflist)
		default_ignite_mecha(T)
		sleep(1)
	operating = FALSE

/obj/item/mecha_parts/mecha_equipment/flamethrower/proc/default_ignite_mecha(turf/target, release_amount = 0.05)
	//Transfer 5% of current tank air contents to turf
	var/datum/gas_mixture/tank_mix = ptank.return_air()
	var/datum/gas_mixture/air_transfer = tank_mix.remove_ratio(release_amount)

	if(air_transfer.gases[/datum/gas/plasma])
		air_transfer.gases[/datum/gas/plasma][MOLES] *= 5
	target.assume_air(air_transfer)
	//Burn it based on transfered gas
	target.hotspot_expose((tank_mix.temperature*2) + 380,500)
	//location.hotspot_expose(1000,500,1)

//I dont know what this does?
/obj/item/mecha_parts/mecha_equipment/flamethrower/process()
	var/turf/location = loc
	 //start a fire if possible
	if(isturf(location))
		igniter.flamethrower_process_mecha(location)

/obj/item/assembly/igniter/proc/flamethrower_process_mecha(turf/open/location)
	location.hotspot_expose(heat,2)

				/* Handles the items in the modified flamethrower */
/obj/item/mecha_parts/mecha_equipment/flamethrower/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/mecha_parts/mecha_equipment/flamethrower/Initialize(mapload)
	. = ..()
	if(create_full)
		if(!weldtool)
			weldtool = new /obj/item/weldingtool(src)
		weldtool.status = FALSE
		if(!igniter)
			igniter = new igniter_type(src)
		igniter.secured = FALSE
		status = TRUE
		if(create_with_tank)
			ptank = new /obj/item/tank/internals/plasma/full(src)
		update_appearance()
	RegisterSignal(src, COMSIG_ITEM_RECHARGED, .proc/instant_refill)

/obj/item/mecha_parts/mecha_equipment/flamethrower/proc/instant_refill()
	SIGNAL_HANDLER
	if(ptank)
		var/datum/gas_mixture/tank_mix = ptank.return_air()
		tank_mix.assert_gas(/datum/gas/plasma)
		tank_mix.gases[/datum/gas/plasma][MOLES] = (10*ONE_ATMOSPHERE)*ptank.volume/(R_IDEAL_GAS_EQUATION*T20C)
	else
		ptank = new /obj/item/tank/internals/plasma/full(src)
	update_appearance()

/obj/item/mecha_parts/mecha_equipment/flamethrower/update_icon_state()
	inhand_icon_state = "flamethrower_[lit]"
	return ..()

/obj/item/mecha_parts/mecha_equipment/flamethrower/update_overlays()
	. = ..()
	if(igniter)
		. += "+igniter[status]"
	if(ptank)
		. += "+ptank"
	if(lit)
		. += "+lit"

/obj/item/mecha_parts/mecha_equipment/flamethrower/examine(mob/user)
	. = ..()
	if(ptank)
		. += span_notice("\The [src] has \a [ptank] attached. Alt-click to remove it.")

/obj/item/mecha_parts/mecha_equipment/flamethrower/CheckParts(list/parts_list)
	..()
	weldtool = locate(/obj/item/weldingtool) in contents
	igniter = locate(/obj/item/assembly/igniter) in contents
	weldtool.status = FALSE
	igniter.secured = FALSE
	status = TRUE
	update_appearance()

/obj/item/mecha_parts/mecha_equipment/flamethrower/return_analyzable_air()
	if(ptank)
		return ptank.return_analyzable_air()
	else
		return null

/obj/item/mecha_parts/mecha_equipment/flamethrower/AltClick(mob/user)
	if(ptank && isliving(user) && user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE, TRUE))
		user.put_in_hands(ptank)
		ptank = null
		to_chat(user, span_notice("You remove the plasma tank from [src]!"))
		update_appearance()

/obj/item/mecha_parts/mecha_equipment/flamethrower/attackby(obj/item/W, mob/user, params)
	//only takes the plasma tank apart
	if(W.tool_behaviour == TOOL_WRENCH)
		var/turf/T = get_turf(src)
		if(ptank)
			ptank.forceMove(T)
			ptank = null
		new /obj/item/stack/rods(T)
		qdel(src)
		return

	else if(istype(W, /obj/item/tank/internals/plasma))
		if(ptank)
			if(user.transferItemToLoc(W,src))
				ptank.forceMove(get_turf(src))
				ptank = W
				to_chat(user, span_notice("You swap the plasma tank in [src]!"))
			return
		if(!user.transferItemToLoc(W, src))
			return
		ptank = W
		update_appearance()
		return
	else
		return ..()

/obj/item/mecha_parts/mecha_equipment/flamethrower/tank
	create_with_tank = TRUE

/obj/item/mecha_parts/mecha_equipment/flamethrower/Destroy()
	if(weldtool)
		qdel(weldtool)
	if(igniter)
		qdel(igniter)
	if(ptank)
		qdel(ptank)
	return ..()
