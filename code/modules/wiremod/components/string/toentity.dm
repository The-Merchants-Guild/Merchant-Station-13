/**
 * # To String Component
 *
 * Converts any value into a string
 */
/obj/item/circuit_component/toentity
	display_name = "To Entity"
	display_desc = "A component that converts an any input to its entity."

	/// The input port
	var/datum/port/input/input_port

	/// The result from the output
	var/datum/port/output/output

	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL|CIRCUIT_FLAG_OUTPUT_SIGNAL

/obj/item/circuit_component/toentity/Initialize()
	. = ..()
	input_port = add_input_port("Input", PORT_TYPE_ANY)

	output = add_output_port("Output", PORT_TYPE_ATOM)

/obj/item/circuit_component/toentity/Destroy()
	input_port = null
	output = null
	return ..()

/obj/item/circuit_component/toentity/input_received(datum/port/input/port)
	. = ..()
	if(.)
		return

	var/input_value = input_port.input_value
	if(isatom(input_value))
		var/atom/object = input_value
		output.set_output(object)
		return

	output.set_output(null)

