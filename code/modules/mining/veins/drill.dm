#define AMOUNT_MEAN 1000
#define AMOUNT_STD 200

GLOBAL_LIST_EMPTY(drill_list)

/obj/machinery/ore_drill
	name = "ore drill"
	desc = "A large device designed for mining ore veins in lavaland."
	icon_state = "drill"
	icon = 'icons/obj/drill_large.dmi'
	layer = MOB_LAYER
	density = TRUE
	processing_flags = START_PROCESSING_MANUALLY

	var/mining
	var/obj/machinery/power/ore_drill_power_module/power_panel
	var/obj/machinery/ore_drill_output_module/output_panel
	var/mining_power_use = 20000 // 20 kW
	var/mining_delay = 5 SECONDS
	COOLDOWN_DECLARE(mining_cooldown)
	var/turf/open/floor/plating/asteroid/basalt/lava_land_surface/ore/ore

/obj/machinery/ore_drill/Initialize()
	. = ..()
	if (!istype(loc, /turf/open/floor/plating/asteroid/basalt/lava_land_surface/ore))
		return
	ore = loc

/obj/machinery/ore_drill/ComponentInitialize()
	AddComponent(/datum/component/extensible_machine, list(
		"Power input" = list(object = /obj/machinery/power/ore_drill_power_module, image = image(icon = 'icons/obj/drilling.dmi', icon_state = "power-icon"), amount = 1),
		"Ore output" = list(object = /obj/machinery/ore_drill_output_module, image = image(icon = 'icons/obj/drilling.dmi', icon_state = "output-icon"), amount = 1)
	), 3 SECONDS, TOOL_CROWBAR, EAST|WEST)
	RegisterSignal(src, COMSIG_EXTEND_MACHINE, .proc/handle_extension)

/obj/machinery/ore_drill/Destroy()
	GLOB.drill_list -= src
	qdel(power_panel)
	power_panel = null
	qdel(output_panel)
	output_panel = null
	ore = null
	. = ..()

/obj/machinery/ore_drill/proc/handle_extension(datum/source, obj/extension, mob/user)
	if (istype(extension, /obj/machinery/power/ore_drill_power_module))
		power_panel = extension
		power_panel.parent = src
		if (!output_panel)
			return
	else
		output_panel = extension
		if (!power_panel)
			return
	start_mining()

/obj/machinery/ore_drill/proc/start_mining()
	if (mining)
		return
	if (!power_panel.powernet && !power_panel.connect_to_network())
		power_panel.update_appearance()
		return
	mining = TRUE
	GLOB.drill_list += src
	begin_processing()

/obj/machinery/ore_drill/proc/stop_mining()
	if (!mining)
		return
	output_panel.send_packet()
	GLOB.drill_list -= src
	end_processing()

/obj/machinery/ore_drill/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if (power_panel && output_panel)
		start_mining()

/obj/machinery/ore_drill/process(delta_time)
	if (!ore || ore.mat_amount <= 0)
		return stop_mining()
	power_panel.update_appearance()
	if (power_panel.surplus() < mining_power_use)
		return
	power_panel.add_load(mining_power_use)
	if (!output_panel.can_output() || !COOLDOWN_FINISHED(src, mining_cooldown))
		return
	COOLDOWN_START(src, mining_cooldown, mining_delay)
	playsound(src, 'sound/weapons/drill.ogg', 100, TRUE, 5) // loud fucker.
	var/amount = min(gaussian(AMOUNT_MEAN, AMOUNT_STD), ore.mat_amount)
	var/mat = ore.ore_material
	var/obj/item/raw_ore/O = new (output_panel, mat, amount)
	ore.mat_amount -= amount
	output_panel.output_ore(O)

/obj/machinery/power/ore_drill_power_module
	name = "ore drill power panel"
	icon_state = "electricity_mod"
	icon = 'icons/obj/drilling.dmi'
	density = TRUE
	var/obj/machinery/ore_drill/parent

/obj/machinery/power/ore_drill_power_module/examine(mob/user)
	. = ..()
	if (!powernet)
		. += "<span class='notice'>It requires a power connection.</span>"

/obj/machinery/power/ore_drill_power_module/update_overlays()
	. = ..()
	if(!powernet || surplus() < parent.mining_power_use)
		. += mutable_appearance(icon, "electricity_mod_e")
		return

/obj/machinery/ore_drill_output_module
	name = "ore drill output panel"
	icon_state = "output_mod"
	icon = 'icons/obj/drilling.dmi'
	density = TRUE
	var/packet_size = 5 // more of an anti-lag thing
	var/obj/structure/disposalpipe/trunk/trunk

/obj/machinery/ore_drill_output_module/examine(mob/user)
	. = ..()
	if (!trunk)
		. += "<span class='notice'>It is lacking a disposal connection.</span>"

/obj/machinery/ore_drill_output_module/proc/can_output()
	if (!trunk)
		trunk = locate() in loc
	return !isnull(trunk)

/obj/machinery/ore_drill_output_module/proc/output_ore(obj/ore)
	ore.forceMove(src)
	if (contents.len < packet_size)
		return
	send_packet()

/obj/machinery/ore_drill_output_module/proc/send_packet()
	var/obj/structure/disposalholder/H = new(src)
	H.forceMove(trunk)
	for (var/obj/C in contents)
		C.forceMove(H)
	H.active = TRUE
	H.setDir(DOWN)
	H.move()

/obj/machinery/ore_drill_box
	name = "ore drill in a box"
	icon_state = "boxed"
	icon = 'icons/obj/drilling.dmi'
	density = TRUE
	anchored = FALSE

/obj/machinery/ore_drill_box/crowbar_act(mob/living/user, obj/item/tool)
	if (!istype(loc, /turf/open/floor/plating/asteroid/basalt/lava_land_surface/ore))
		to_chat(user, "<span class='warning'>Can't unpack the [src] here!</span>")
		return
	user.visible_message("<span class='notice'>[user] starts unpacking [src].</span>", "<span class='notice'>You start unpacking [src].</span>")
	if (do_after(user, 5 SECONDS, src))
		var/D = new /obj/machinery/ore_drill(get_turf(src))
		user.visible_message("<span class='notice'>[user] unpacks the [D].</span>", "<span class='notice'>You unpack the [D].</span>")
		qdel(src)
		return TRUE

#undef AMOUNT_MEAN
#undef AMOUNT_STD
