// Why their own files?
// easier to work with that's why

/obj/item/circuit_component/bluespace_launchpad
	display_name = "Bluespace Launchpad Console"
	desc = "Teleports anything to and from any location on the station. Doesn't use actual GPS coordinates, but rather offsets from the launchpad itself. Can only go as far as the launchpad can go, which depends on its parts."

	var/datum/port/input/launchpad_id
	var/datum/port/input/x_pos
	var/datum/port/input/y_pos
	var/datum/port/input/send_trigger
	var/datum/port/input/retrieve_trigger

	var/datum/port/output/sent
	var/datum/port/output/retrieved
	var/datum/port/output/on_fail
	var/datum/port/output/why_fail

	var/obj/machinery/computer/launchpad/attached_console

/obj/item/circuit_component/bluespace_launchpad/get_ui_notices()
	. = ..()
	var/current_launchpad = launchpad_id.value
	if(isnull(current_launchpad))
		return

	var/obj/machinery/launchpad/the_pad = attached_console.launchpads[current_launchpad]
	if(isnull(the_pad))
		return

	. += create_ui_notice("Minimum Range: [-the_pad.range]", "orange", "minus")
	. += create_ui_notice("Maximum Range: [the_pad.range]", "orange", "plus")

/obj/item/circuit_component/bluespace_launchpad/populate_ports()
	launchpad_id = add_input_port("Launchpad ID", PORT_TYPE_NUMBER, trigger = null, default = 1)
	x_pos = add_input_port("X offset", PORT_TYPE_NUMBER)
	y_pos = add_input_port("Y offset", PORT_TYPE_NUMBER)
	send_trigger = add_input_port("Send", PORT_TYPE_SIGNAL)
	retrieve_trigger = add_input_port("Retrieve", PORT_TYPE_SIGNAL)

	sent = add_output_port("Sent", PORT_TYPE_SIGNAL)
	retrieved = add_output_port("Retrieved", PORT_TYPE_SIGNAL)
	why_fail = add_output_port("Fail reason", PORT_TYPE_STRING)
	on_fail = add_output_port("Failed", PORT_TYPE_SIGNAL)

/obj/item/circuit_component/bluespace_launchpad/register_usb_parent(atom/movable/shell)
	. = ..()
	if(istype(shell, /obj/machinery/computer/launchpad))
		attached_console = shell

/obj/item/circuit_component/bluespace_launchpad/unregister_usb_parent(atom/movable/shell)
	attached_console = null
	return ..()

/obj/item/circuit_component/bluespace_launchpad/input_received(datum/port/input/port)
	if(!attached_console || length(attached_console.launchpads) == 0)
		why_fail.set_output("No launchpads connected!")
		on_fail.set_output(COMPONENT_SIGNAL)
		return


	if(!launchpad_id.value)
		return

	var/obj/machinery/launchpad/the_pad = KEYBYINDEX(attached_console.launchpads, launchpad_id.value)
	if(isnull(the_pad))
		why_fail.set_output("Invalid launchpad selected!")
		on_fail.set_output(COMPONENT_SIGNAL)
		return

	the_pad.set_offset(x_pos.value, y_pos.value)

	if(COMPONENT_TRIGGERED_BY(port, x_pos))
		x_pos.set_value(the_pad.x_offset)
		return

	if(COMPONENT_TRIGGERED_BY(port, y_pos))
		y_pos.set_value(the_pad.y_offset)
		return

	var/checks = attached_console.teleport_checks(the_pad)
	if(!isnull(checks))
		why_fail.set_output(checks)
		on_fail.set_output(COMPONENT_SIGNAL)
		return

	if(COMPONENT_TRIGGERED_BY(send_trigger, port))
		INVOKE_ASYNC(the_pad, /obj/machinery/launchpad.proc/doteleport, null, TRUE, parent.get_creator())
		sent.set_output(COMPONENT_SIGNAL)

	if(COMPONENT_TRIGGERED_BY(retrieve_trigger, port))
		INVOKE_ASYNC(the_pad, /obj/machinery/launchpad.proc/doteleport, null, FALSE, parent.get_creator())
		retrieved.set_output(COMPONENT_SIGNAL)
