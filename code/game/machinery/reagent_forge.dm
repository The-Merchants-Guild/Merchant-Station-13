/obj/machinery/reagent_forge
	name = "material forge"
	desc = "A bulky machine that can smelt practically any material in existence."
	icon = 'icons/obj/3x3.dmi'
	icon_state = "arc_forge"
	bound_width = 96
	bound_height = 96
	anchored = TRUE
	max_integrity = 1000
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 10
	active_power_usage = 3000
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	circuit = null
	light_range = 5
	light_power = 1.5
	light_color = LIGHT_COLOR_FIRE
	var/operation = ""
	var/datum/reagent/currently_forging //forge one mat at a time
	var/processing = FALSE
	var/efficiency = 1
	var/datum/techweb/stored_research
	var/list/currently_using = list()

/datum/techweb/specialized/autounlocking/reagent_forge
	design_autounlock_buildtypes = REAGENT_FORGE
	allowed_buildtypes = REAGENT_FORGE

/obj/machinery/reagent_forge/Initialize()
	. = ..()
	AddComponent(/datum/component/material_container, list(/datum/material/custom), 200000, MATCONTAINER_EXAMINE, _after_insert = CALLBACK(src, .proc/AfterMaterialInsert))
	stored_research = new /datum/techweb/specialized/autounlocking/reagent_forge

/obj/machinery/reagent_forge/attackby(obj/item/stack/sheet/mineral/reagent/I, mob/living/carbon/human/user)

	if(user.combat_mode)
		return ..()

	if(istype(I, /obj/item/stack/sheet/mineral/reagent))
		var/obj/item/stack/sheet/mineral/reagent/R = I

		if(!in_range(src, R) || !user.Adjacent(src))
			return

		if(panel_open)
			to_chat(user, "<span class='warning'>You can't load the [src.name] while it's opened!</span>")
			return

		if(R.reagent_type)
			var/datum/reagent/RE = R.reagent_type
			if(!initial(RE.can_forge))
				to_chat(user, "<span class='warning'>[initial(RE.name)] cannot be forged!</span>")
				return

			if(!currently_forging || !currently_forging.type)
				var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
				if(R.amount <= 0)//this shouldn't exist
					to_chat(user, "<span class='warning'>The sheet crumbles away into dust, perhaps it was a fake one?</span>")
					qdel(R)
					return FALSE
				for()
					materials.user_insert(R, user, R.amount)
				to_chat(user, "<span class='notice'>You add [R] to [src]</span>")
				currently_forging = new R.reagent_type.type
				return

			if(currently_forging && currently_forging.type && R.reagent_type.type == currently_forging.type)//preventing unnecessary references from being made
				var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
				materials.user_insert(R, user, R.amount)
				to_chat(user, "<span class='notice'>You add [R] to [src]</span>")
				return
			else
				to_chat(user, "<span class='notice'>[currently_forging] is currently being forged, either remove or use it before adding a different material</span>")//if null is currently being forged comes up i'm gonna scree
				return
	if(currently_forging)
		desc += "There is currently [currently_forging] inside."
	else
		to_chat(user, "<span class='alert'>[src] rejects the [I]</span>")


/obj/machinery/reagent_forge/proc/create_product(datum/design/forge/D, amount, mob/user)
	var/datum/component/material_container/ourmaterials = GetComponent(/datum/component/material_container)
	if(!loc)
		return FALSE
	var/amount_needed = D.materials[/datum/material/custom]
	to_chat(world, "<span class='boldannounce'>[amount_needed]")
	if(ourmaterials.has_materials(amount_needed))
		to_chat(world, span_boldannounce("WORKIES........"))
	else
		to_chat(world, span_boldannounce("no WORKIES........"))

	for(var/i in 1 to amount)
		to_chat(world, "<span class='boldannounce'>[check_cost(D.materials, TRUE)]")
		if(!check_cost(D.materials, TRUE))
			visible_message("<span class='warning'>The low material indicator flashes on [src]!</span>")
			playsound(src, 'sound/machines/buzz-two.ogg', 60, 0)
			return FALSE

		if(D.build_path)
			var/atom/A = new D.build_path(user.loc)
			if(currently_forging)
				if(istype(D, /datum/design/forge))
					var/obj/item/forged/F = A
					var/paths = subtypesof(/datum/reagent)
					for(var/path in paths)
						var/datum/reagent/RR = new path
						if(RR.type == currently_forging.type)
							F.reagent_type = RR
							F.assign_properties()
							break
						else
							qdel(RR)
		. = TRUE
	update_icon()
	return .

/obj/machinery/reagent_forge/interact(mob/user, special_state)
	. = ..()
	var/action = tgui_alert(user, "What do you want to do?","Operate Reagent Forge", list("Create", "Dump"))
	switch(action)
		if("Create")
			var/datum/design/forge/poopie
			var/list/designs_list = typesof(/datum/design/forge)
			for(var/V in designs_list)
				var/datum/design/forge/A = V
			var/datum/design/forge/choice = input(user, "What do you want to forge?", "Forged Weapon Type") as null|anything in designs_list
			if(choice)
				poopie = new choice
			if(!poopie)
				return FALSE
			var/amount = 0
			to_chat(world, "<span class='boldannounce'>[poopie.name]")
			amount = input("How many?", "How many would you like to forge?", 1) as null|num
			if(amount <= 0)
				return FALSE
			create_product(poopie, amount, usr)
			return TRUE

		if("Dump")
			if(currently_forging)
				var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
				var/amount = materials.get_item_material_amount(MAT_REAGENT)
				if(amount > 0)
					var/list/materials_used = list(MAT_REAGENT=amount)
					materials.use_materials(materials_used)
					var/obj/item/stack/sheet/mineral/reagent/RS = new(get_turf(usr))
					RS.amount = materials.amount2sheet(amount)
					var/paths = subtypesof(/datum/reagent)//one reference per stack

					for(var/path in paths)
						var/datum/reagent/RR = new path
						if(RR.type == currently_forging.type)
							RS.reagent_type = RR
							RS.name = "[RR.name] ingots"
							RS.singular_name = "[RR.name] ingot"
							RS.add_atom_colour(RR.color, FIXED_COLOUR_PRIORITY)
							to_chat(usr, "<span class='notice'>You remove the [RS.name] from [src]</span>")
							break
						else
							qdel(RR)
			qdel(currently_forging)
			currently_forging = null
			return TRUE


/obj/machinery/reagent_forge/ui_interact(mob/user)
	. = ..()
	if(!user)
		return

	var/datum/browser/popup = new(user, "reagentforge", "Reagent Forge", 450, 600)
	if(!(in_range(src, user) || issilicon(user)))
		popup.close()
		return

	var/dat = ""




/obj/machinery/reagent_forge/ui_data(mob/user)
	var/list/listofrecipes = list()
	var/list/data = list()
	var/lowest_cost = 1

	for(var/v in stored_research.researched_designs)
		var/datum/design/forge/D = SSresearch.techweb_design_by_id(v)
		var/md5name = md5(D.name)
		var/cost = D.materials[MAT_REAGENT]*efficiency
		if(!listofrecipes[md5name])
			listofrecipes[md5name] = list("name" = D.name, "category" = D.category[2], "cost" = cost)
			if(cost < lowest_cost)
				lowest_cost = cost
	sortList(listofrecipes)

	var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
	data["recipes"] = listofrecipes
	data["currently_forging"] = currently_forging ? currently_forging : "Nothing"
	data["material_amount"] = materials.get_item_material_amount(MAT_REAGENT)
	data["can_afford"] = check_cost(lowest_cost, FALSE)
	return data


/*/obj/machinery/reagent_forge/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("Create")
			var/amount = 0
			amount = input("How many?", "How many would you like to forge?", 1) as null|num
			if(amount <= 0)
				return FALSE
			var/datum/design/forge/D = SSresearch.techweb_design_by_id(v)
			var/list/designs_list = typesof(/datum/design/forge)
			for(var/V in designs_list)
				var/
			if(D.name == params["name"])
				create_product(D, amount, usr)
				return TRUE

		if("Dump")
			if(currently_forging)
				var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
				var/amount = materials.get_item_material_amount(MAT_REAGENT)
				if(amount > 0)
					var/list/materials_used = list(MAT_REAGENT=amount)
					materials.use_materials(materials_used)
					var/obj/item/stack/sheet/mineral/reagent/RS = new(get_turf(usr))
					RS.amount = materials.amount2sheet(amount)
					var/paths = subtypesof(/datum/reagent)//one reference per stack

					for(var/path in paths)
						var/datum/reagent/RR = new path
						if(RR.type == currently_forging.type)
							RS.reagent_type = RR
							RS.name = "[RR.name] ingots"
							RS.singular_name = "[RR.name] ingot"
							RS.add_atom_colour(RR.color, FIXED_COLOUR_PRIORITY)
							to_chat(usr, "<span class='notice'>You remove the [RS.name] from [src]</span>")
							break
						else
							qdel(RR)
			qdel(currently_forging)
			currently_forging = null
			return TRUE

	return FALSE*/
