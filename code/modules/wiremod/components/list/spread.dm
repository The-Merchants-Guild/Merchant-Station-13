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
	var/datum/port/input/input_list

	///List of output ports
	var/list/datum/port/output/outputs = list()

	var/list_size = 0
	var/default_list_size = 1

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

/obj/item/circuit_component/spread/Initialize()
	. = ..()
	input_list = add_input_port("List", PORT_TYPE_LIST(PORT_TYPE_ANY))

/obj/item/circuit_component/spread/populate_ports()
	set_list_size(default_list_size)

/obj/item/circuit_component/list_literal/save_data_to_list(list/component_data)
	. = ..()
	component_data["list_size"] = list_size

/obj/item/circuit_component/list_literal/load_data_from_list(list/component_data)
	set_list_size(component_data["list_size"])

	return ..()
/obj/item/circuit_component/spread/input_received(datum/port/input/port)
	. = ..()

	if(.)
		return

	for(var/i = 1 to list_size)
		var/datum/port/output/oi = outputs[i]
		if(length(input_list) < i)
			oi.set_output(null)
		else
			oi.set_output(input_list[i])

