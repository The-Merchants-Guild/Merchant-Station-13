GLOBAL_LIST_EMPTY(microwave_receievers)

// kg * J/(kg*K) | mass * specific heat
#define MACHINE_HEAT_CAPACITY 1000 * 502.416
// This is just a random number
#define HEAT_TRANSFER_COEFFICIENT 0.87
// litres
#define GAS_TRANSFER_RATE 500

/obj/machinery/microwave_transmission
	name = "wzhzhzh"
	desc = "wzhzhzh"
	var/energy_loss = 0.1 // energy loss
	var/temperature = T0C // in Kelvin
	var/obj/machinery/power/powerbox
	var/obj/machinery/atmospherics/components/unary/coolant_input
	var/obj/machinery/atmospherics/components/unary/coolant_output

/obj/machinery/microwave_transmission/ComponentInitialize()
	AddComponent(/datum/component/extensible_machine, list(
		"Power" = list(object = /obj/machinery/power/microwave_powerbox, image = image(icon = 'icons/obj/drilling.dmi', icon_state = "power-icon"), amount = 1),
		"Coolant In" = list(object = /obj/machinery/atmospherics/components/unary/microwave_input, image = image(icon = 'icons/obj/drilling.dmi', icon_state = "output-icon"), amount = 1),
		"Coolant Out" = list(object = /obj/machinery/atmospherics/components/unary/microwave_output, image = image(icon = 'icons/obj/drilling.dmi', icon_state = "output-icon"), amount = 1)
	), 3 SECONDS, TOOL_CROWBAR, EAST|WEST)
	RegisterSignal(src, COMSIG_EXTEND_MACHINE, .proc/handle_extension)

/obj/machinery/microwave_transmission/proc/handle_extension(datum/source, obj/extension, mob/user)
	switch (extension.type)
		if (/obj/machinery/power/microwave_powerbox)
			powerbox = extension
		if (/obj/machinery/atmospherics/components/unary/microwave_input)
			coolant_input = extension
		if (/obj/machinery/atmospherics/components/unary/microwave_output)
			coolant_output = extension

/obj/machinery/microwave_transmission/proc/coolant_process()
	if (!coolant_input || !coolant_output)
		return
	var/datum/gas_mixture/input = coolant_input.airs[1]
	var/datum/gas_mixture/removed = input.remove_ratio(GAS_TRANSFER_RATE / input.volume)
	if (!removed.total_moles())
		return
	var/ihc = removed.heat_capacity()
	var/energy = ihc * (removed.temperature - temperature) * HEAT_TRANSFER_COEFFICIENT
	change_heat(energy)
	removed.temperature -= energy / ihc
	coolant_output.airs[1].merge(removed)

/obj/machinery/microwave_transmission/proc/change_heat(energy)
	var/E = MACHINE_HEAT_CAPACITY * temperature
	E += energy
	temperature = E / MACHINE_HEAT_CAPACITY

/obj/machinery/microwave_transmission/transmitter
	name = "Microwave power transmitter"
	desc = "It is a machine with a hollow metallic cylinder protruding from the top of it."
	var/obj/effect/abstract/microwave_target/target
	var/power_transfer = 1000000 // watt seconds

/obj/machinery/microwave_transmission/transmitter/Initialize()
	. = ..()
	target = new(loc)

/obj/machinery/microwave_transmission/transmitter/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	var/T = input(user, "Choose a target.", "Target Selection") as null|anything in GLOB.microwave_receievers
	if (T)
		change_target(T)
		START_PROCESSING(SSmachines, src)

/obj/machinery/microwave_transmission/transmitter/process(delta_time)
	. = ..()
	if (powerbox)
		transmit(delta_time)

/obj/machinery/microwave_transmission/transmitter/proc/change_target(new_target)
	target.forceMove(get_turf(new_target))

/obj/machinery/microwave_transmission/transmitter/proc/transmit(delta_time)
	var/power = min(powerbox.delayed_surplus(), power_transfer) * delta_time
	if (!power)
		return
	var/loss = power * energy_loss
	powerbox.add_load(power - loss)
	change_heat(loss)

/obj/machinery/microwave_transmission/receiver
	name = "Microwave power receiever"
	desc = "It is a machine with some kind of focusing mirror on top of it."

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
	icon_state = "beam"
	pixel_y = 480
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/last_time = 0

/obj/effect/abstract/microwave_target/proc/bwwwwwmmmm(power)
	last_time = world.time
	var/obj/machinery/microwave_transmission/receiver/R = locate(/obj/machinery/microwave_transmission/receiver) in loc
	if (R)
		R.receieve(power)
		return
	var/turf/open/T = get_turf(src)
	if (!istype(T))
		return
	T.air.temperature += power

/obj/effect/abstract/microwave_target/process(delta_time)
	. = ..()
	alpha = 255 - (255 * ((world.time - last_time) / 3 SECONDS))

/obj/machinery/power/microwave_powerbox
	name = "Powerbox"

/obj/machinery/atmospherics/components/unary/microwave_input
	name = "Coolant input"

/obj/machinery/atmospherics/components/unary/microwave_output
	name = "Coolant output"

#undef MACHINE_HEAT_CAPACITY
#undef HEAT_TRANSFER_COEFFICIENT
#undef GAS_TRANSFER_RATE
