/obj/item/circuit_component/conveyor_switch
	display_name = "Conveyor Switch"
	desc = "Allows to control connected conveyor belts."
	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL

	/// The current direction of the conveyor attached to the component.
	var/datum/port/output/direction
	/// The switch this conveyor switch component is attached to.
	var/obj/machinery/conveyor_switch/attached_switch

/obj/item/circuit_component/conveyor_switch/populate_ports()
	direction = add_output_port("Conveyor Direction", PORT_TYPE_NUMBER)

/obj/item/circuit_component/conveyor_switch/get_ui_notices()
	. = ..()
	. += create_ui_notice("Conveyor direction 0 means that it is stopped, 1 means that it is active and -1 means that it is working in reverse mode", "orange", "info")

/obj/item/circuit_component/conveyor_switch/register_usb_parent(atom/movable/shell)
	. = ..()
	if(istype(shell, /obj/machinery/conveyor_switch))
		attached_switch = shell

/obj/item/circuit_component/conveyor_switch/unregister_usb_parent(atom/movable/shell)
	attached_switch = null
	return ..()

/obj/item/circuit_component/conveyor_switch/input_received(datum/port/input/port)
	if(!attached_switch)
		return

	INVOKE_ASYNC(src, .proc/update_conveyers, port)

/obj/item/circuit_component/conveyor_switch/proc/update_conveyers(datum/port/input/port)
	if(!attached_switch)
		return

	attached_switch.update_position()
	attached_switch.update_appearance()
	attached_switch.update_linked_conveyors()
	attached_switch.update_linked_switches()
	direction.set_output(attached_switch.position)
