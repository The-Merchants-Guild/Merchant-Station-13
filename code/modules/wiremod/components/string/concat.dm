/**
 * # Concatenate Component
 *
 * General string concatenation component. Puts strings together.
 */
/obj/item/circuit_component/concat
	display_name = "Concatenate"
	display_desc = "A component that combines strings."

	/// The amount of input ports to have
	var/input_port_amount = 4

	/// The result from the output
	var/datum/port/output/output
	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL|CIRCUIT_FLAG_OUTPUT_SIGNAL

/obj/item/circuit_component/concat/populate_options()
	var/static/component_options = list(2, 3, 4, 5, 6, 7, 8, 9, 10)
	options = component_options

/obj/item/circuit_component/concat/Initialize()
	. = ..()

	input_port_amount = current_option
	for(var/port_id in 1 to input_port_amount)
		var/letter = ascii2text(text2ascii("A") + (port_id-1))
		add_input_port(letter, PORT_TYPE_STRING)

	output = add_output_port("Output", PORT_TYPE_STRING)

/obj/item/circuit_component/concat/Destroy()
	output = null
	return ..()

/obj/item/circuit_component/concat/input_received(datum/port/input/port)
	. = ..()

	if(input_port_amount != current_option)
		
		if(input_port_amount > current_option)
			for(var/i in current_option + 1 to input_port_amount)
				var/datum/port/input/o = input_ports[current_option + 1]
				remove_input_port(o)
		
		if(input_port_amount < current_option)
			input_ports -= trigger_input
			for(var/i in input_port_amount + 1 to current_option)
				add_input_port(ascii2text(text2ascii("A") + (i-1)), PORT_TYPE_STRING)
			input_ports += trigger_input //this ensures the Triggered output is always the last one

		input_port_amount = current_option

	if(.)
		return

	var/result = ""
	var/list/ports = input_ports.Copy()
	ports -= trigger_input

	for(var/datum/port/input/input_port as anything in ports)
		var/value = input_port.input_value
		if(isnull(value))
			continue

		result += "[value]"

	output.set_output(result)

