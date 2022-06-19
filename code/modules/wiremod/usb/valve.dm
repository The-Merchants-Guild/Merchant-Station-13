/obj/item/circuit_component/digital_valve
	display_name = "Digital Valve"
	desc = "The interface for communicating with a digital valve."

	var/obj/machinery/atmospherics/components/binary/valve/digital/attached_valve

	/// Opens the digital valve
	var/datum/port/input/open
	/// Closes the digital valve
	var/datum/port/input/close

	/// Whether the valve is currently open
	var/datum/port/output/is_open
	/// Sent when the valve is opened
	var/datum/port/output/opened
	/// Sent when the valve is closed
	var/datum/port/output/closed

/obj/item/circuit_component/digital_valve/populate_ports()
	open = add_input_port("Open", PORT_TYPE_SIGNAL)
	close = add_input_port("Close", PORT_TYPE_SIGNAL)

	is_open = add_output_port("Is Open", PORT_TYPE_NUMBER)
	opened = add_output_port("Opened", PORT_TYPE_SIGNAL)
	closed = add_output_port("Closed", PORT_TYPE_SIGNAL)

/obj/item/circuit_component/digital_valve/register_usb_parent(atom/movable/shell)
	. = ..()
	if(istype(shell, /obj/machinery/atmospherics/components/binary/valve/digital))
		attached_valve = shell
		RegisterSignal(attached_valve, COMSIG_VALVE_SET_OPEN, .proc/handle_valve_toggled)

/obj/item/circuit_component/digital_valve/unregister_usb_parent(atom/movable/shell)
	UnregisterSignal(attached_valve, COMSIG_VALVE_SET_OPEN)
	attached_valve = null
	return ..()

/obj/item/circuit_component/digital_valve/proc/handle_valve_toggled(datum/source, on)
	SIGNAL_HANDLER
	is_open.set_output(on)
	if(on)
		opened.set_output(COMPONENT_SIGNAL)
	else
		closed.set_output(COMPONENT_SIGNAL)

/obj/item/circuit_component/digital_valve/input_received(datum/port/input/port)

	if(!attached_valve)
		return

	if(COMPONENT_TRIGGERED_BY(open, port) && !attached_valve.on)
		attached_valve.set_open(TRUE)
	if(COMPONENT_TRIGGERED_BY(close, port) && attached_valve.on)
		attached_valve.set_open(FALSE)
