/**
 * # Split component
 *
 * Splits a string
 */
/obj/item/circuit_component/string_split
	display_name = "String Split"
	display_desc = "Splits a string by the separator, giving the first N results"

	/// The input port
	var/datum/port/input/input_port

	/// The seperator
	var/datum/port/input/separator

	/// The result from the output
	var/list/outputs = list()

	var/num_current

	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL|CIRCUIT_FLAG_OUTPUT_SIGNAL
	
/obj/item/circuit_component/string_split/populate_options()
	var/static/component_options = list(2, 3, 4, 5, 6, 7, 8, 9, 10)
	options = component_options

/obj/item/circuit_component/string_split/Initialize()
	. = ..()
	input_port = add_input_port("Input", PORT_TYPE_STRING)
	separator = add_input_port("Seperator", PORT_TYPE_STRING)

	num_current = current_option

	for(var/i = 1, i <= num_current, i++)
		var/new_output = add_output_port("Output [i]", PORT_TYPE_STRING)
		outputs += new_output

/obj/item/circuit_component/string_split/Destroy()
	input_port = null
	separator = null
	outputs = null
	return ..()

// i love writing garbage code
/obj/item/circuit_component/string_split/input_received(datum/port/input/port)
	. = ..()

	if(num_current != current_option)
		
		if(num_current > current_option)
			for(var/i = current_option + 1, i <= num_current, i++)
				var/datum/port/output/o = outputs[current_option + 1]
				outputs -= o
				remove_output_port(o)
		
		if(num_current < current_option)
			output_ports -= trigger_output
			for(var/i = num_current + 1, i <= current_option, i++)
				var/new_output = add_output_port("Output [i]", PORT_TYPE_STRING)
				outputs += new_output
			output_ports += trigger_output //this ensures the Triggered output is always the last one

		num_current = current_option

	if(.)
		return

	var/separator_value = separator.input_value
	if(isnull(separator_value))
		return

	var/value = input_port.input_value
	if(isnull(value))
		return

	var/list/list_input = splittext(value,separator_value)

	for(var/i = 1 to num_current)
		var/datum/port/output/oi = outputs[i]
		if(length(list_input) < i)
			oi.set_output(null)
		else
			oi.set_output("[list_input[i]]")

	
