/obj/machinery/point_vendor
	name = "job point vendor"
	desc = "An equipment vendor for jobs."
	icon = 'icons/obj/vending.dmi'
	icon_state = "generic"
	density = TRUE
	var/icon_vend
	var/icon_deny
	var/light_mask
	var/department
	var/obj/item/card/id/inserted_id
	var/list/equipment_list = list(
		/obj/item/melee/supermatter_sword = list(
			"Supermatter Sword",	// Name
			100,					// Point cost
			200,					// Credits cost
			2,						// Amount
			2 MINUTES				// Replenish time
		)
	)
	var/list/replenishing = list()

/obj/machinery/point_vendor/Initialize()
	. = ..()
	build_inventory()

/obj/machinery/point_vendor/proc/build_inventory()
	for(var/p in equipment_list)
		GLOB.vending_products[p] = 1

/obj/machinery/point_vendor/proc/dispense(path)
	to_chat(usr, span_notice("[src] clanks to life briefly before vending [equipment_list[path][1]]!"))
	if (icon_vend)
		flick(icon_vend,src)
	equipment_list[path][4]--
	new path(loc)
	if (!equipment_list[path][5])
		return

	if (replenishing[path])
		replenishing[path] += world.time + equipment_list[path][5]
	else
		replenishing[path] = list(world.time + equipment_list[path][5])

/obj/machinery/point_vendor/process()
	for (var/p in replenishing)
		for (var/t in replenishing[p])
			if (world.time < t)
				continue
			replenishing[p] -= t
			equipment_list[p][4]++

/obj/machinery/point_vendor/update_overlays()
	. = ..()
	if(!light_mask)
		return
	if(!(machine_stat & BROKEN) && powered())
		. += emissive_appearance(icon, light_mask)

/obj/machinery/point_vendor/update_icon_state()
	if(machine_stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
		return ..()
	icon_state = "[initial(icon_state)][powered() ? null : "-off"]"
	return ..()

/obj/machinery/point_vendor/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/vending),
	)

/obj/machinery/point_vendor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PointVendor", name)
		ui.open()

/obj/machinery/point_vendor/ui_static_data(mob/user)
	. = list()
	.["dept"] = department
	.["inventory"] = list()
	for(var/path in equipment_list)
		var/list/I = equipment_list[path]
		.["inventory"] += list(list(
			"path" = "[path]",
			"icon" = replacetext(replacetext("[path]", "/obj/item/", ""), "/", "-"),
			"name" = I[1],
			"points" = I[2],
			"credits" = I[3]
		))

/obj/machinery/point_vendor/ui_data(mob/user)
	. = list()
	var/obj/item/card/id/C
	if(isliving(user))
		var/mob/living/L = user
		C = L.get_idcard(TRUE)
	if(C)
		.["user"] = list()
		var/P = C.registered_account.job_points[department]
		.["user"]["points"] = P != null ? P : 0
		.["user"]["credits"] = C.registered_account.account_balance
		if(C.registered_account)
			.["user"]["name"] = C.registered_account.account_holder
			if(C.registered_account.account_job)
				.["user"]["job"] = C.registered_account.account_job.title
			else
				.["user"]["job"] = "No Job"
	.["amounts"] = list()
	for(var/path in equipment_list)
		.["amounts"] += list("[path]" = equipment_list[path][4])

/obj/machinery/point_vendor/ui_act(action, params)
	. = ..()
	if (.)
		return

	switch (action)
		if ("purchase")
			var/obj/item/card/id/I
			if (isliving(usr))
				var/mob/living/L = usr
				I = L.get_idcard(TRUE)
			if (!istype(I))
				to_chat(usr, span_alert("Error: An ID is required!"))
				flick(icon_deny, src)
				return
			var/item = text2path(params["path"])
			if (!item || !(equipment_list[item]))
				to_chat(usr, span_alert("Error: Invalid choice!"))
				flick(icon_deny, src)
				return
			if (equipment_list[item][4] <= 0)
				to_chat(usr, span_alert("Error: Out of stock!"))
				flick(icon_deny, src)
				return
			if (params["type"] == "points")
				if (equipment_list[item][2] > I.registered_account.job_points[department])
					to_chat(usr, span_alert("Error: Insufficient points for [equipment_list[item][1]] on [I]!"))
					flick(icon_deny, src)
					return
				I.registered_account.job_points[department] -= equipment_list[item][2]
				dispense(item)
				SSblackbox.record_feedback("nested tally", "[department]_equipment_bought_points", 1, list("[type]", "[item]"))
				. = TRUE
			else
				if (!I.registered_account.has_money(equipment_list[item][3]))
					to_chat(usr, span_alert("Error: Insufficient credits for [equipment_list[item][1]] on [I]!"))
					flick(icon_deny, src)
					return
				I.registered_account.adjust_money(-equipment_list[item][3])
				dispense(item)
				SSblackbox.record_feedback("nested tally", "[department]_equipment_bought_credits", 1, list("[type]", "[item]"))
				. = TRUE

/obj/machinery/point_vendor/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, "mining-open", "mining", I))
		return
	if(default_deconstruction_crowbar(I))
		return
	return ..()

/obj/machinery/point_vendor/ex_act(severity, target)
	do_sparks(5, TRUE, src)
	if(severity > EXPLODE_LIGHT && prob(17 * severity))
		qdel(src)
