
/obj/item/circuit_component/light_switch
	display_name = "Light Switch"
	desc = "Allows to control the lights of an area."
	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL

	///If the lights should be turned on or off when the trigger is triggered.
	var/datum/port/input/on_setting
	///Whether the lights are turned on
	var/datum/port/output/is_on

	var/obj/machinery/light_switch/attached_switch

/obj/item/circuit_component/light_switch/populate_ports()
	on_setting = add_input_port("On", PORT_TYPE_NUMBER)
	is_on = add_output_port("Is On", PORT_TYPE_NUMBER)

/obj/item/circuit_component/light_switch/register_usb_parent(atom/movable/parent)
	. = ..()
	if(istype(parent, /obj/machinery/light_switch))
		attached_switch = parent
		RegisterSignal(parent, COMSIG_LIGHT_SWITCH_SET, .proc/on_light_switch_set)

/obj/item/circuit_component/light_switch/unregister_usb_parent(atom/movable/parent)
	attached_switch = null
	UnregisterSignal(parent, COMSIG_LIGHT_SWITCH_SET)
	return ..()

/obj/item/circuit_component/light_switch/proc/on_light_switch_set(datum/source, status)
	SIGNAL_HANDLER
	is_on.set_output(status)

/obj/item/circuit_component/light_switch/input_received(datum/port/input/port)
	attached_switch?.set_lights(on_setting.value ? TRUE : FALSE)
