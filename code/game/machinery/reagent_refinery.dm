/obj/machinery/reagent_sheet
	name = "\improper reagent refinery"
	desc = "Smelts and refines solid reagents into ingots usable by the forge."
	icon_state = "furnace"
	icon = 'icons/obj/machines/mining_machines.dmi'
	density = TRUE
	anchored = TRUE
	use_power = IDLE_POWER_USE
	light_power = 0.5
	light_range = 2
	light_color = LIGHT_COLOR_FLARE
	var/obj/item/reagent_containers/food/solid_reagent/working = null
	var/work_time = 300
	var/end_volume = 100
	circuit = /obj/item/circuitboard/machine/reagent_sheet

/obj/machinery/reagent_sheet/RefreshParts()
	for(var/obj/item/stock_parts/micro_laser/ML in component_parts)
		work_time = (initial(work_time)/ML.rating)
	for(var/obj/item/stock_parts/matter_bin/MB in component_parts)
		end_volume = initial(end_volume) * MB.rating

/obj/machinery/reagent_sheet/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += span_notice("The status display reads: Outputting <b>[end_volume/20]</b> ingot(s) after <b>[work_time*0.1]</b> seconds of processing.")

/obj/machinery/reagent_sheet/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/reagent_containers/food/solid_reagent) && !panel_open)
		if(!is_operational && BROKEN)
			to_chat(user, span_warning("[src] is broken!"))
			return
		if(working)
			to_chat(user, span_warning("[src] is busy!"))
			return
		else
			var/area/a = loc.loc // Gets our locations location, like a dream within a dream
			if(!isarea(a))
				return
			if(a.power_equip == 0) // There's no APC in this area, don't try to cheat power!
				to_chat(user, span_warning("[src] seems to be powered off!"))
				return
			if(!user.transferItemToLoc(I,src) && !I.reagents)
				to_chat(user, span_alert("[src] rejects [I]."))
				return
			working = I
			var/chem_material = working.reagents.total_volume * end_volume
			use_power = working.reagents.total_volume
			updateUsrDialog()
			addtimer(CALLBACK(src, .proc/create_sheets, chem_material), work_time)
			to_chat(user, span_notice("You add [working] to [src]."))
			visible_message(span_notice("[src] activates!"))
		if(!in_range(src, working) || !user.Adjacent(src))
			return
	else
		if(!working && default_deconstruction_screwdriver(user, icon_state, icon_state, I))
			return
		if(default_deconstruction_crowbar(I))
			return
		return ..()

/obj/machinery/reagent_sheet/deconstruct()
	if(working)
		working.forceMove(drop_location())
	return ..()

/obj/machinery/reagent_sheet/Destroy()
	QDEL_NULL(working)
	return ..()

/obj/machinery/reagent_sheet/proc/create_sheets(amount)
	var/sheet_amount = max(round(amount / MINERAL_MATERIAL_AMOUNT), 1)
	var/obj/item/stack/sheet/mineral/reagent/RS = new(get_turf(src))
	visible_message(span_notice("[src] finishes processing."))
	playsound(src, 'sound/machines/ping.ogg', 50, 0)
	RS.amount = sheet_amount
	for(var/path in subtypesof(/datum/reagent))
		var/datum/reagent/RR = new path
		if(RR.type == working.reagent_type)
			RS.reagent_type = RR
			RS.name = "[RR.name] ingots"
			RS.singular_name = "[RR.name] ingot"
			RS.add_atom_colour(RR.color, FIXED_COLOUR_PRIORITY)
			break
		else
			del(RR) //lol
	QDEL_NULL(working)
	return

/obj/item/circuitboard/machine/reagent_sheet
	name = "Reagent Refinery (Machine Board)"
	build_path = /obj/machinery/reagent_sheet
	req_components = list(
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stack/cable_coil = 3)
