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
	var/trueamount = 0

/obj/machinery/reagent_forge/examine(mob/user)
	//go fuck yourself if you think I'm using a SIGNAL FOR FUCKING EXAMINING
	. = ..()
	if(trueamount != 0)
		. += "\n The Forge contains [span_blue("[trueamount]")] units of [span_blue("[currently_forging]")]"
	else
		. += "\n The Forge is empty."

/obj/machinery/reagent_forge/attackby(obj/item/stack/sheet/mineral/reagent/I, mob/living/carbon/human/user)
	if(istype(I, /obj/item/stack/sheet/mineral/reagent))
		var/obj/item/stack/sheet/mineral/reagent/R = I
		if(R.reagent_type)
			var/datum/reagent/RE = R.reagent_type
			if(!initial(RE.can_forge))
				to_chat(user, "<span class='warning'>[initial(RE.name)] cannot be forged!</span>")
				return
			if(!currently_forging || !currently_forging.type)
				//OBSERVE NOW AS I DO SOMETHING **STUPID**
				trueamount += R.amount*MINERAL_MATERIAL_AMOUNT
				to_chat(user, "<span class='notice'>You add [R] to [src]</span>")
				qdel(R)
				currently_forging = new R.reagent_type.type
				return

			if(currently_forging && currently_forging.type && R.reagent_type.type == currently_forging.type)//preventing unnecessary references from being made
				trueamount += R.amount*MINERAL_MATERIAL_AMOUNT
				qdel(R)
				to_chat(user, "<span class='notice'>You add [R] to [src]</span>")
				return
			else
				to_chat(user, "<span class='notice'>[currently_forging] is currently being forged, either remove or use it before adding a different material</span>")//if null is currently being forged comes up i'm gonna scree
				return

/obj/machinery/reagent_forge/interact(mob/user, special_state)
	. = ..()
	var/action = tgui_alert(user, "What do you want to do?","Operate Reagent Forge", list("Create", "Dump"))
	switch(action)
		if("Create")
			var/datum/design/forge/poopie
			var/list/designs_list = subtypesof(/datum/design/forge)
			var/datum/design/forge/choice = input(user, "What do you want to forge?", "Forged Weapon Type") as null|anything in designs_list
			if(choice)
				poopie = new choice
			if(!poopie)
				return FALSE
			var/amount = 0
			amount = input("How many?", "How many would you like to forge?", 1) as null|num
			if(amount <= 0)
				return FALSE
			if(!loc)
				return FALSE
			var/amount_needed = poopie.materials[/datum/material/custom] * amount
			if(trueamount>=amount_needed)
				for(var/i in 1 to amount)
					if(poopie.build_path)
						var/atom/A = new poopie.build_path(user.loc)
						if(currently_forging)
							if(istype(poopie, /datum/design/forge))
								var/obj/item/forged/F = A
								var/paths = subtypesof(/datum/reagent)
								for(var/path in paths)
									var/datum/reagent/RR = new path
									if(RR.type == currently_forging.type)
										F.reagent_type = RR
										F.assign_properties()
										trueamount -= amount_needed //if this doesn't work I'm eating my own cock
										break
									else
										qdel(RR)
					. = TRUE
				update_icon()
				return .
			else
				visible_message("<span class='warning'>The low material indicator flashes on [src]!</span>")
				playsound(src, 'sound/machines/buzz-two.ogg', 60, 0)

		if("Dump")
			if(currently_forging)
				trueamount = 0
				currently_forging = null
			else
				visible_message("<span class='warning'>Dump what, exactly? The Forge is empty!</span>")
