//REMAIN CALM
//HIPPIE ENDURES
//LCASS LIVES
//HIPPIESTATION SHALL ENDURE
//THERE IS MUCH TO BE ADDED

/obj/machinery/chem
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/chemical.dmi'
	resistance_flags = FIRE_PROOF | ACID_PROOF
	use_power = IDLE_POWER_USE
	idle_power_usage = 10
	var/obj/item/reagent_containers/beaker = null
	var/on = FALSE

/obj/machinery/chem/Initialize()
	. = ..()
	create_reagents(200, NO_REACT)

/obj/machinery/chem/Destroy()
	if(beaker)
		QDEL_NULL(beaker)
	return ..()

/obj/machinery/chem/deconstruct(disassembled)
	. = ..()
	if(beaker && disassembled)
		beaker.forceMove(drop_location())
		beaker = null

/obj/machinery/chem/proc/replace_beaker(mob/living/user, obj/item/reagent_containers/new_beaker)
	if(beaker)
		try_put_in_hand(beaker, user)
		beaker = null
	if(new_beaker)
		beaker = new_beaker
	else
		beaker = null
	update_icon()
	return TRUE

/obj/machinery/chem/AltClick(mob/living/user)
	..()
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return
	if(on)
		to_chat(user, "<span class='notice'>You can't remove the [beaker] while the [src] is working!</span>")
		return
	replace_beaker(user)
	return

/obj/machinery/chem/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, icon_state, icon_state, I))
		return

	if(default_deconstruction_crowbar(I))
		return

	if(istype(I, /obj/item/reagent_containers) && !(I.item_flags & ABSTRACT) && I.is_open_container())
		. = TRUE //no afterattack
		var/obj/item/reagent_containers/B = I
		if(!user.transferItemToLoc(B, src))
			return
		replace_beaker(user, B)
		to_chat(user, "<span class='notice'>You add \the [B] to \the [src].</span>")
		update_appearance()
		return
	return ..()

/obj/machinery/chem/pressure//This used heater code before. Not anymore
	name = "Pressurized reaction chamber"
	desc = "Creates high pressures to suit certain reaction conditions"
	icon_state = "press"
	circuit = /obj/item/circuitboard/machine/pressure

/obj/machinery/chem/pressure/process()
	..()
	if(beaker)
		beaker.reagents.handle_reactions()

/obj/machinery/chem/pressure/proc/pressurize(obj/item/reagent_containers/A)
	A.reagents.chem_pressurized = 1
	src.on = 0
	visible_message(span_notice("[src] makes a ding to signal that its pressurization cycle is over!"))

/obj/machinery/chem/pressure/proc/depressurize(obj/item/reagent_containers/A)
	A.reagents.chem_pressurized = 0
	src.on = 0
	visible_message(span_notice("[src] makes a ding to signal that its de-pressurization cycle is over!"))

/obj/machinery/chem/pressure/interact(mob/user)
	. = ..()
	var/warning = tgui_alert(user, "How would you like to operate the machine?","Operate Pressurized reaction chamber", list("Pressurize", "Depressurize",))
	switch(warning)
		if("Pressurize")
			if(beaker)
				if(beaker.reagents)
					visible_message("<span class='notice'>[src] begins to pressurize its contents!</span>")
					on = 1
					addtimer(CALLBACK(src, .proc/pressurize, beaker), 60)
		if("Depressurize")
			if(beaker)
				if(beaker.list_reagents)
					visible_message("<span class='notice'>[src] begins to pressurize its contents!</span>")
					on = 1
					addtimer(CALLBACK(src, .proc/depressurize, beaker), 60)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/machinery/chem/radioactive//break up in action dust I walk my brow and I strut my
	name = "Radioactive molecular reassembler"
	desc = "A mystical machine that changes molecules directly on the level of bonding."
	icon_state = "radio"
	var/material_amt = 0 //requires uranium in order to function
	var/target_radioactivity = 0
	circuit = /obj/item/circuitboard/machine/radioactive

/obj/machinery/chem/radioactive/proc/irradiate(obj/item/reagent_containers/A)
	A.reagents.chem_irradiated = 1
	src.material_amt -= 100
	icon_state = "radio"
	if(prob(50))
		radiation_pulse(src.loc, 80, 1)
	src.on = 0
	visible_message(span_notice("[src] makes a ding and the green light turns off!"))

/obj/machinery/chem/radioactive/proc/scrub(obj/item/reagent_containers/A)
	A.reagents.chem_irradiated = 0
	src.on = 0
	visible_message(span_notice("[src] makes a ding and the blue light turns off!"))

/obj/machinery/chem/radioactive/interact(mob/user)
	. = ..()
	var/warning = tgui_alert(user, "How would you like to operate the machine?","Operate Radioactive molecular reassembler", list("Irradiate", "Scrub Radioactive Materials",))
	switch(warning)
		if("Irradiate")
			if(material_amt >= 100)
				if(beaker)
					on = TRUE
					visible_message("<span class='notice'>A green light shows on \the [src].</span>")
					icon_state = "radio_on"
					playsound(src, 'sound/machines/ping.ogg', 50, 0)
					addtimer(CALLBACK(src, .proc/irradiate, beaker), 60)

			else
				audible_message("<span class='notice'>\The [src] pings in fury: showing the empty reactor indicator!.</span>")
				playsound(src, 'sound/machines/buzz-two.ogg', 60, 0)
		if("Scrub Radioactive Materials")
			if(beaker)
				on = TRUE
				visible_message("<span class='notice'> A blue light shows on \the [src].</span>")
				icon_state = "radio_on"
				playsound(src, 'sound/machines/ping.ogg', 50, 0)
				addtimer(CALLBACK(src, .proc/scrub, beaker), 60)

/obj/machinery/chem/radioactive/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/stack/sheet/mineral/uranium))
		. = TRUE //no afterattack
		if(material_amt >= 50000)
			to_chat(user, "<span class='warning'>\The [src] is full!</span>")
			return
		to_chat(user, "<span class='notice'>You add the uranium to the [src].</span>")
		var/obj/item/stack/sheet/mineral/uranium/U = I
		material_amt = clamp(material_amt += U.amount * 1000, 0, 50000)//50 sheets max
		user.dropItemToGround(I)
		qdel(I)//it's a var now
		return
	..()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/machinery/chem/bluespace
	name = "Bluespace recombobulator"
	desc = "Forget changing molecules, this thing changes the laws of physics itself in order to produce chemicals."
	icon_state = "blue"
	var/crystal_amt = 0
	var/intensity = 0
	circuit = /obj/item/circuitboard/machine/bluespace

/obj/machinery/chem/bluespace/proc/recombobulate(obj/item/reagent_containers/beaker)
	beaker.reagents.chem_bluespaced = 1
	src.on = 0
	src.crystal_amt -= 300
	icon_state = "blue"
	if(prob(20))//low chance but could still happen
		do_sparks(4)
		for(var/mob/living/L in range(2,src))//boy is this thing nasty!
			to_chat(L, ("<span class=\"warning\">You feel disorientated!</span>"))
			do_teleport(L, get_turf(L), 5, asoundin = 'sound/effects/phasein.ogg')
	visible_message("<span class='notice'> The green light on the [src] turns off.</span>")

/obj/machinery/chem/bluespace/interact(mob/user)
	. = ..()
	if(crystal_amt >= 100)
		if(beaker)
			on = TRUE
			visible_message("<span class='notice'>A green light shows on \the [src].</span>")
			icon_state = "blue_on"
			playsound(src, 'sound/machines/ping.ogg', 50, 0)
			addtimer(CALLBACK(src, .proc/recombobulate, beaker), 60)
	else
		audible_message("<span class='notice'>\The [src] pings in fury: showing the empty reactor indicator!</span>")
		playsound(src, 'sound/machines/buzz-two.ogg', 60, 0)

/obj/machinery/chem/bluespace/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/stack/ore/bluespace_crystal))
		. = TRUE //no afterattack
		if(crystal_amt >= 10)
			to_chat(user, "<span class='warning'>\The [src] is full!</span>")
			return
		to_chat(user, "<span class='notice'>You add the bluespace material to the [src].</span>")
		crystal_amt += 1//10 crystals max
		user.temporarilyRemoveItemFromInventory(I)
		qdel(I)//it's a var now
		return
	..()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/machinery/chem/centrifuge
	name = "Centrifuge"
	desc = "Spins chemicals at high speeds to seperate them"
	icon_state = "cent_off"
	circuit = /obj/item/circuitboard/machine/centrifuge

/obj/machinery/chem/centrifuge/proc/centrifuge(obj/item/reagent_containers/beaker)
	beaker.reagents.chem_centrifuged = 1
	src.on = 0
	icon_state = "cent_off"
	visible_message("<span class='notice'> The [src] finishes its centrifuging cycle.</span>")

/obj/machinery/chem/centrifuge/interact(mob/user)
	. = ..()
	if(beaker)
		on = TRUE
		visible_message("<span class='notice'>A green light shows on \the [src].</span>")
		icon_state = "cent_on"
		playsound(src, 'sound/machines/ping.ogg', 50, 0)
		addtimer(CALLBACK(src, .proc/centrifuge, beaker), 60)
	else
		audible_message("<span class='notice'>\The [src] pings in fury: showing the empty chamber indicator! Add a beaker in!</span>")
		playsound(src, 'sound/machines/buzz-two.ogg', 60, 0)
