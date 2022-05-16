/**
 * # Computer Vision Component
 *
 * Scans for mobs or objects
 */
/obj/item/circuit_component/computer_vision
	display_name = "Computer Vision"
	display_desc = "Scans its surroundings to find mobs or objects"
	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL|CIRCUIT_FLAG_OUTPUT_SIGNAL
	icon_state = "computer_vision"

	var/datum/port/output/scanned_objects
	var/scan_range = 5
	var/object_scan_range = 3
	
/obj/item/circuit_component/computer_vision/populate_options()
	var/static/component_options = list(COMP_COMPVIS_MOB, COMP_COMPVIS_OBJECT) // gonna implement the second one later
	options = component_options

/obj/item/circuit_component/computer_vision/Initialize()
	scanned_objects = add_output_port("Scanned Objects", PORT_TYPE_TABLE)
	. = ..()

/obj/item/circuit_component/computer_vision/Destroy()
	scanned_objects = null
	return ..()

// i love writing garbage code
/obj/item/circuit_component/computer_vision/input_received(datum/port/input/port)
	. = ..()

	if(.)
		return

	var/list/new_table = list()
	
	var/turf/current_turf = get_turf(src)
	if(current_option == COMP_COMPVIS_MOB)
		for(var/mob/living/A in view(scan_range, current_turf))
			if(A.invisibility > SEE_INVISIBLE_LIVING)
				continue
			var/list/entry = list()
			entry["entity"] = A
			entry["name"] = A.name
			entry["health"] = A.health
			entry["range"] = get_dist(current_turf, A)
			var/mob/living/carbon/human/human = A
			if(!istype(human) || !A.has_dna())
				entry["species"] = initial(A.name)
			else
				entry["species"] = human.dna.species.name
			new_table += list(entry)
	else
		for(var/atom/A in view(object_scan_range, current_turf))
			if(A.invisibility > SEE_INVISIBLE_LIVING)
				continue
			var/list/entry = list()
			entry["entity"] = A
			entry["name"] = A.name
			entry["range"] = get_dist(current_turf, A)
			new_table += list(entry)

	scanned_objects.set_output(new_table)
