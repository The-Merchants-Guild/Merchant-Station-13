GLOBAL_LIST_EMPTY(microwave_receievers)

// kg * J/(kg*K) | mass * specific heat
#define MACHINE_HEAT_CAPACITY (500 * 502.416)
// This is just a random number, 7.8%
#define HEAT_TRANSFER_COEFFICIENT 0.078

/obj/machinery/microwave_transmission
	name = "wzhzhzh"
	desc = "wzhzhzh"
	icon = 'icons/obj/drilling.dmi'
	density = TRUE
	var/energy_loss = 0.1 // energy loss
	var/temperature = T0C // in Kelvin
	var/obj/machinery/power/powerbox

/obj/machinery/microwave_transmission/ComponentInitialize()
	AddComponent(/datum/component/extensible_machine, list(
		"Power" = list(object = /obj/machinery/power/microwave_powerbox, image = image(icon = 'icons/obj/drilling.dmi', icon_state = "power-icon"), amount = 1),
		"Console" = list(object = /obj/structure/microwave_console, image = image(icon = 'icons/obj/drilling.dmi', icon_state = "output-icon"), amount = 1)
	), 3 SECONDS, TOOL_CROWBAR)
	RegisterSignal(src, COMSIG_EXTEND_MACHINE, .proc/handle_extension)

/obj/machinery/microwave_transmission/process(delta_time)
	heat_process()

/obj/machinery/microwave_transmission/proc/handle_extension(datum/source, obj/extension, mob/user)
	switch (extension.type)
		if (/obj/machinery/power/microwave_powerbox)
			powerbox = extension

/obj/machinery/microwave_transmission/proc/heat_process()
	if (temperature > 1273.15) // 1000 celcius, good enough
		take_damage((temperature - 1273.15) * 0.1, BURN) // take 10% damage.
	var/turf/open/T = get_turf(src)
	if (!T)
		return
	if (!istype(T)) // no air
		change_heat(-125604) // 0.5 degrees
		return
	var/datum/gas_mixture/air = T.air
	if (air.return_pressure() < 1 && air.temperature < temperature) // basically just checking for space.
		change_heat(-125604) // 0.5 degrees, copy pasting probably not the best idea but.
		return
	var/dT = (air.temperature - temperature) * HEAT_TRANSFER_COEFFICIENT
	if ((air.temperature + dT) >= TCMB)
		air.temperature += dT
	if ((temperature - dT) >= TCMB)
		temperature -= dT

/obj/machinery/microwave_transmission/proc/change_heat(energy)
	energy /= MACHINE_HEAT_CAPACITY
	if ((temperature + energy) < TCMB)
		return
	temperature += energy

/obj/machinery/microwave_transmission/transmitter
	name = "Microwave power transmitter"
	desc = "It is a machine with a hollow metallic cylinder protruding from the top of it."
	icon_state = "transmitter"
	var/running = FALSE
	var/obj/effect/abstract/microwave_target/target
	var/power_transfer = 10000000 // watt seconds

/obj/machinery/microwave_transmission/transmitter/Initialize()
	. = ..()
	target = new(loc)
	vis_contents += target

/obj/machinery/microwave_transmission/transmitter/Destroy()
	. = ..()
	qdel(target)

/obj/machinery/microwave_transmission/transmitter/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	var/T = input(user, "Choose a target.", "Target Selection") as null|anything in GLOB.microwave_receievers
	if (T)
		change_target(T)

/obj/machinery/microwave_transmission/transmitter/process(delta_time)
	heat_process()
	if (running && powerbox)
		transmit(delta_time)

/obj/machinery/microwave_transmission/transmitter/proc/change_target(new_target)
	target.forceMove(get_turf(new_target))

/obj/machinery/microwave_transmission/transmitter/proc/transmit(delta_time)
	var/power = min(powerbox.surplus(), power_transfer * delta_time)
	if (!power)
		return
	var/loss = power * energy_loss
	powerbox.add_load(power - loss)
	target.bwwwwwmmmm(power - loss)
	change_heat(loss)

/obj/machinery/microwave_transmission/receiver
	name = "Microwave power receiever"
	desc = "It is a machine with some kind of dish on top of it."
	icon_state = "receiver"

/obj/machinery/microwave_transmission/receiver/proc/receieve(power)
	if (!power)
		return
	if (!powerbox)
		change_heat(power)
		return
	var/loss = power * energy_loss
	powerbox.add_avail(power - loss)
	change_heat(loss)

/obj/machinery/microwave_transmission/receiver/Initialize()
	. = ..()
	GLOB.microwave_receievers += src

/obj/machinery/microwave_transmission/receiver/Destroy()
	. = ..()
	GLOB.microwave_receievers -= src

/obj/effect/abstract/microwave_target
	icon = 'icons/effects/microwave_beam.dmi'
	icon_state = "laser"
	layer = ABOVE_ALL_MOB_LAYER
	plane = ABOVE_LIGHTING_PLANE
	pixel_y = 16
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	alpha = 127

/obj/effect/abstract/microwave_target/proc/bwwwwwmmmm(power)
	var/obj/machinery/microwave_transmission/receiver/R = locate(/obj/machinery/microwave_transmission/receiver) in loc
	if (R)
		R.receieve(power)
		return
	var/turf/open/T = get_turf(src)
	if (!istype(T))
		return
	T.air.temperature += power / T.air.heat_capacity()
	T.air_update_turf()

/obj/machinery/power/microwave_powerbox
	name = "Powerbox"
	icon = 'icons/obj/drilling.dmi'
	icon_state = "direction_pointer"

/obj/machinery/power/microwave_powerbox/Initialize()
	. = ..()
	connect_to_network()

/obj/structure/microwave_console

#undef MACHINE_HEAT_CAPACITY
#undef HEAT_TRANSFER_COEFFICIENT
