/**
 * # Shell Item
 *
 * Printed out by protolathes. Screwdriver to complete the shell.
 */
/obj/item/shell
	name = "assembly"
	desc = "A shell assembly that can be completed by screwdrivering it."
	icon = 'icons/obj/wiremod.dmi'
	var/shell_to_spawn
	var/screw_delay = 3 SECONDS

/obj/item/shell/screwdriver_act(mob/living/user, obj/item/tool)
	user.visible_message(span_notice("[user] begins finishing [src]."), span_notice("You begin finishing [src]."))
	tool.play_tool_sound(src)
	if(!do_after(user, screw_delay, src))
		return
	user.visible_message(span_notice("[user] finishes [src]."), span_notice("You finish [src]."))

	var/turf/drop_loc = drop_location()

	qdel(src)
	if(drop_loc)
		new shell_to_spawn(drop_loc)

	return TRUE

/obj/item/shell/bot
	name = "bot assembly"
	icon_state = "setup_medium_box-open"
	shell_to_spawn = /obj/structure/bot

/obj/item/shell/money_bot
	name = "money bot assembly"
	icon_state = "setup_large-open"
	shell_to_spawn = /obj/structure/money_bot

/obj/item/shell/drone
	name = "drone assembly"
	icon_state = "setup_medium_med-open"
	shell_to_spawn = /mob/living/circuit_drone

/obj/item/shell/server
	name = "server assembly"
	icon_state = "setup_stationary-open"
	shell_to_spawn = /obj/structure/server
	screw_delay = 10 SECONDS

/obj/item/shell/airlock
	name = "circuit airlock assembly"
	icon = 'icons/obj/doors/airlocks/station/public.dmi'
	icon_state = "construction"
	shell_to_spawn = /obj/machinery/door/airlock/shell
	screw_delay = 10 SECONDS

/obj/item/shell/bci
	name = "brain-computer interface assembly"
	icon_state = "bci-open"
	shell_to_spawn = /obj/item/organ/cyberimp/bci

/obj/item/shell/mech
	name = "mech interface assembly"
	icon_state = "bci-open"
	desc = "A shell assembly that can permanently convert any mech into a circuit mech. It has a screw that just keeps turning in place. Odd."
	shell_to_spawn = /obj/item/shell/mech

/obj/item/shell/mech/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return
	if(!istype(target, /obj/vehicle/sealed/mecha))
		return
	var/datum/component/shell/shell_mech = target.GetComponent(/datum/component/shell)
	if(shell_mech)
		return
	user.visible_message(span_notice("[user] begins inserting an interface module into [target]."), span_notice("You begin inserting the circuit interface into [target]."))
	if(!do_after(user, 8 SECONDS, src))
		return
	user.visible_message(span_notice("[user] finishes inserting the mech interface module into [target]."), span_notice("You finish inserting the circuit interface into [target]."))
	target.AddComponent( \
		/datum/component/shell, \
		unremovable_circuit_components = list(new /obj/item/circuit_component/mech_movement, new /obj/item/circuit_component/mech_equipment), \
		capacity = SHELL_CAPACITY_LARGE, \
		shell_flags = SHELL_FLAG_ALLOW_FAILURE_ACTION \
	)
	target.name += "-Circuitix"
	qdel(src)


/obj/item/shell/mech/screwdriver_act(mob/living/user, obj/item/tool)
	user.visible_message(span_notice("[user] begins screwing [src]."), span_notice("You begin screwing [src]."))
	tool.play_tool_sound(src)
	if(!do_after(user, 1 SECONDS, src))
		return
	user.visible_message(span_notice("[user] rotates the screw of [src] in place."), span_notice("The screw just spins in place. Darn."))
	return
