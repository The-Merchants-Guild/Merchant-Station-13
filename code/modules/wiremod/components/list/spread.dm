/**
 * # Spread component
 *
 * Spread a list
 */
/obj/item/circuit_component/spread
	display_name = "List Spread"
	display_desc = "Spread a list into ports"
	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL|CIRCUIT_FLAG_OUTPUT_SIGNAL

	///Input list
	var/datum/port/input/input_port

	///List of output ports
	var/list/datum/port/output/output_ports

	var/list_size = 0
	var/default_list_size = 0

	var/max_list_sizre = 24


	ui_buttons = list(
		"plus" = "increase",
		"minus" = "decrease"
	)

/obj/ite.circuit_component/spread/populate_ports()
	set_list_size(default_list_size)

/obj/item/circuit_component/spread/proc/set_list_size(var/number/new_list_size)

	if(new_list_size > max_list_size)
		return

	if(new_list_size < 1)
		for(var/datum/port/port in output_ports)
			remove_bit_port(port)
		output_ports = list()
		list_size = 0
		return

	while(list_size < new_list_size)
		output_ports += var/datum/port/output/output_port
		list_size++

	while(list_size > new_list_size)
		output_ports -= bit_array[list_size-1]
		list_size--

/obj/item/circuit_component/spread/ui_perform_action(mob/user, action)
	switch(action)
		if("increase")
			set_list_size(array_size + 1)
		if("decrease")
			set_list_size(array_size - 1)
