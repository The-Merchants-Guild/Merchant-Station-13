#define COMP_STATE_ARREST "*Arrest*"
#define COMP_STATE_PRISONER "Incarcerated"
#define COMP_STATE_SUSPECTED "Suspected"
#define COMP_STATE_PAROL "Paroled"
#define COMP_STATE_DISCHARGED "Discharged"
#define COMP_STATE_NONE "None"
#define COMP_SECURITY_ARREST_AMOUNT_TO_FLAG 10

/obj/item/circuit_component/arrest_console_data
	display_name = "Security Records Data"
	desc = "Outputs the security records data, where it can then be filtered with a Select Query component"
	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL|CIRCUIT_FLAG_OUTPUT_SIGNAL

	/// The records retrieved
	var/datum/port/output/records

	/// Sends a signal on failure
	var/datum/port/output/on_fail

	var/obj/machinery/computer/secure_data/attached_console

/obj/item/circuit_component/arrest_console_data/populate_ports()
	records = add_output_port("Security Records", PORT_TYPE_TABLE)
	on_fail = add_output_port("Failed", PORT_TYPE_SIGNAL)

/obj/item/circuit_component/arrest_console_data/register_usb_parent(atom/movable/shell)
	. = ..()
	if(istype(shell, /obj/machinery/computer/secure_data))
		attached_console = shell

/obj/item/circuit_component/arrest_console_data/unregister_usb_parent(atom/movable/shell)
	attached_console = null
	return ..()

/obj/item/circuit_component/arrest_console_data/get_ui_notices()
	. = ..()
	. += create_table_notices(list(
		"name",
		"id",
		"rank",
		"arrest_status",
		"gender",
		"age",
		"species",
		"fingerprint",
	))


/obj/item/circuit_component/arrest_console_data/input_received(datum/port/input/port)

	if(!attached_console || !attached_console.authenticated)
		on_fail.set_output(COMPONENT_SIGNAL)
		return

	if(isnull(GLOB.data_core.general))
		on_fail.set_output(COMPONENT_SIGNAL)
		return

	var/list/new_table = list()
	for(var/datum/data/record/player_record as anything in GLOB.data_core.general)
		var/list/entry = list()
		var/datum/data/record/player_security_record = find_record("id", player_record.fields["id"], GLOB.data_core.security)
		if(player_security_record)
			entry["arrest_status"] = player_security_record.fields["criminal"]
			entry["security_record"] = player_security_record
		entry["name"] = player_record.fields["name"]
		entry["id"] = player_record.fields["id"]
		entry["rank"] = player_record.fields["rank"]
		entry["gender"] = player_record.fields["gender"]
		entry["age"] = player_record.fields["age"]
		entry["species"] = player_record.fields["species"]
		entry["fingerprint"] = player_record.fields["fingerprint"]

		new_table += list(entry)

	records.set_output(new_table)

/obj/item/circuit_component/arrest_console_arrest
	display_name = "Security Records Set Status"
	desc = "Receives a table to use to set people's arrest status. Table should be from the security records data component. If New Status port isn't set, the status will be decided by the options."
	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL|CIRCUIT_FLAG_OUTPUT_SIGNAL

	/// The targets to set the status of.
	var/datum/port/input/targets

	/// Sets the new status of the targets.
	var/datum/port/input/option/new_status

	/// Returns the new status set once the setting is complete. Good for locating errors.
	var/datum/port/output/new_status_set

	/// Sends a signal on failure
	var/datum/port/output/on_fail

	var/obj/machinery/computer/secure_data/attached_console

/obj/item/circuit_component/arrest_console_arrest/register_usb_parent(atom/movable/shell)
	. = ..()
	if(istype(shell, /obj/machinery/computer/secure_data))
		attached_console = shell

/obj/item/circuit_component/arrest_console_arrest/unregister_usb_parent(atom/movable/shell)
	attached_console = null
	return ..()

/obj/item/circuit_component/arrest_console_arrest/populate_options()
	var/static/list/component_options = list(
		COMP_STATE_ARREST,
		COMP_STATE_PRISONER,
		COMP_STATE_SUSPECTED,
		COMP_STATE_PAROL,
		COMP_STATE_DISCHARGED,
		COMP_STATE_NONE,
	)
	new_status = add_option_port("Arrest Options", component_options)

/obj/item/circuit_component/arrest_console_arrest/populate_ports()
	targets = add_input_port("Targets", PORT_TYPE_TABLE)
	new_status_set = add_output_port("Set Status", PORT_TYPE_STRING)
	on_fail = add_output_port("Failed", PORT_TYPE_SIGNAL)

/obj/item/circuit_component/arrest_console_arrest/input_received(datum/port/input/port)

	if(!attached_console || !attached_console.authenticated)
		on_fail.set_output(COMPONENT_SIGNAL)
		return

	var/status_to_set = new_status.value

	new_status_set.set_output(status_to_set)
	var/list/target_table = targets.value
	if(!target_table)
		on_fail.set_output(COMPONENT_SIGNAL)
		return

	var/successful_set = 0
	var/list/names_of_entries = list()
	for(var/list/target in target_table)
		var/datum/data/record/sec_record = target["security_record"]
		if(!sec_record)
			continue

		if(sec_record.fields["criminal"] != status_to_set)
			successful_set++
			names_of_entries += target["name"]
		sec_record.fields["criminal"] = status_to_set


	if(successful_set > 0)
		investigate_log("[names_of_entries.Join(", ")] have been set to [status_to_set] by [parent.get_creator()].", INVESTIGATE_RECORDS)
		if(successful_set > COMP_SECURITY_ARREST_AMOUNT_TO_FLAG)
			message_admins("[successful_set] security entries have been set to [status_to_set] by [parent.get_creator_admin()]. [ADMIN_COORDJMP(src)]")
		for(var/mob/living/carbon/human/human as anything in GLOB.human_list)
			human.sec_hud_set_security_status()

#undef COMP_STATE_ARREST
#undef COMP_STATE_PRISONER
#undef COMP_STATE_SUSPECTED
#undef COMP_STATE_PAROL
#undef COMP_STATE_DISCHARGED
#undef COMP_STATE_NONE
#undef COMP_SECURITY_ARREST_AMOUNT_TO_FLAG
