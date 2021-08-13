/obj/item/circuit_component/mech_movement
	display_name = "Mech Movement"
	display_desc = "The movement interface with an mech."

	/// Called when attack_hand is called on the shell.
	var/obj/vehicle/sealed/mecha/attached_mech

	/// The inputs to allow for the drone to move
	var/datum/port/input/north
	var/datum/port/input/east
	var/datum/port/input/south
	var/datum/port/input/west

	// Done like this so that travelling diagonally is more simple
	COOLDOWN_DECLARE(north_delay)
	COOLDOWN_DECLARE(east_delay)
	COOLDOWN_DECLARE(south_delay)
	COOLDOWN_DECLARE(west_delay)

	/// Delay between each movement
	var/move_delay = 0.1 SECONDS

/obj/item/circuit_component/mech_movement/Initialize()
	. = ..()
	north = add_input_port("Move North", PORT_TYPE_SIGNAL)
	east = add_input_port("Move East", PORT_TYPE_SIGNAL)
	south = add_input_port("Move South", PORT_TYPE_SIGNAL)
	west = add_input_port("Move West", PORT_TYPE_SIGNAL)


/obj/item/circuit_component/mech_movement/register_shell(atom/movable/shell)
	. = ..()
	if(istype(shell, /obj/vehicle/sealed/mecha))
		attached_mech = shell

/obj/item/circuit_component/mech_movement/Destroy()
	north = null
	east = null
	south = null
	west = null
	return ..()

/obj/item/circuit_component/mech_movement/input_received(datum/port/input/port)
	. = ..()
	if(.)
		return

	if(!attached_mech)
		return

	var/direction

	if(COMPONENT_TRIGGERED_BY(north, port) && COOLDOWN_FINISHED(src, north_delay))
		direction = NORTH
		COOLDOWN_START(src, north_delay, move_delay)
	else if(COMPONENT_TRIGGERED_BY(east, port) && COOLDOWN_FINISHED(src, east_delay))
		direction = EAST
		COOLDOWN_START(src, east_delay, move_delay)
	else if(COMPONENT_TRIGGERED_BY(south, port) && COOLDOWN_FINISHED(src, south_delay))
		direction = SOUTH
		COOLDOWN_START(src, south_delay, move_delay)
	else if(COMPONENT_TRIGGERED_BY(west, port) && COOLDOWN_FINISHED(src, west_delay))
		direction = WEST
		COOLDOWN_START(src, west_delay, move_delay)

	if(!direction)
		return

	attached_mech.vehicle_move(direction)

/obj/item/circuit_component/mech_equipment
	display_name = "Mech Equipment"
	display_desc = "The equipment interface with an mech."

	/// Called when attack_hand is called on the shell.
	var/obj/vehicle/sealed/mecha/combat/attached_mech

	/// The inputs to allow for the drone to move
	var/datum/port/input/attack
	var/datum/port/input/target
	var/datum/port/input/change_equipment
	var/mob/living/attacker = null


/obj/item/circuit_component/mech_equipment/Initialize()
	. = ..()
	attack = add_input_port("Attack", PORT_TYPE_SIGNAL)
	target = add_input_port("Target", PORT_TYPE_ATOM)
	change_equipment = add_input_port("Switch Equipment", PORT_TYPE_SIGNAL)

	attacker = new
	attacker.combat_mode = TRUE


/obj/item/circuit_component/mech_equipment/register_shell(atom/movable/shell)
	. = ..()
	if(istype(shell, /obj/vehicle/sealed/mecha))
		attached_mech = shell
		attached_mech.add_occupant(attacker, VEHICLE_CONTROL_EQUIPMENT | VEHICLE_CONTROL_MELEE)
		attacker.forceMove(attached_mech)

/obj/item/circuit_component/mech_equipment/unregister_shell(atom/movable/shell)
	attached_mech.remove_occupant(attacker)

/obj/item/circuit_component/mech_equipment/Destroy()
	attack = null
	target = null
	change_equipment = null
	attached_mech.remove_occupant(attacker)
	qdel(attacker)
	return ..()

/obj/item/circuit_component/mech_equipment/input_received(datum/port/input/port)
	. = ..()
	if(.)
		return

	if(!attached_mech)
		return
	if(COMPONENT_TRIGGERED_BY(attack, port))
		var/atom/tgt = target.input_value
		if(!tgt)
			return
		attached_mech.on_mouseclick(attacker, tgt, "")

	if(COMPONENT_TRIGGERED_BY(change_equipment, port))
		var/list/available_equipment = list()
		for(var/e in attached_mech.equipment)
			var/obj/item/mecha_parts/mecha_equipment/equipment = e
			if(equipment.selectable)
				available_equipment += equipment
		if(!attached_mech.selected)
			attached_mech.selected = available_equipment[1]
			return
		var/number = 0
		for(var/equipment in available_equipment)
			number++
			if(equipment != attached_mech.selected)
				continue
			if(available_equipment.len == number)
				attached_mech.selected = null
			else
				attached_mech.selected = available_equipment[number+1]
			return
	
