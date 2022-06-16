/**
 * # Spread component
 *
 * Spread a list
 */
/obj/item/circuit_component/spread
	display_name = "List Spread"
	desc = "Spread a list into ports"
	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL|CIRCUIT_FLAG_OUTPUT_SIGNAL

	///Input list
	var/datum/port/input/input_port

	///List of output ports
	var/list/datum/port/output/outputs = list()

	var/list_size = 0
	var/default_list_size = 0

	var/max_list_size = 24


	ui_buttons = list(
		"plus" = "increase",
		"minus" = "decrease"
	)


/obj/item/circuit_component/spread/proc/set_list_size(new_list_size)

	if(new_list_size > max_list_size)
		return

	if(new_list_size < 1)
		for(var/datum/port/port in outputs)
			remove_output_port(port)
		outputs = list()
		list_size = 0
		return

	while(list_size < new_list_size)
		outputs += add_output_port("index [list_size]", PORT_TYPE_ANY)
		list_size++

	while(list_size > new_list_size)
		list_size--
		outputs -= outputs[list_size]

/obj/item/circuit_component/spread/ui_perform_action(mob/user, action)
	switch(action)
		if("increase")
			set_list_size(list_size + 1)
		if("decrease")
			set_list_size(list_size - 1)

/obj/item/circuit_component/spread/populate_ports()
	set_list_size(default_list_size)
