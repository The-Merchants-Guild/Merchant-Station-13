/datum/wires/pipebomb
	holder_type = /obj/item/grenade/pipebomb
	proper_name = "Pipe Bomb"
	randomize = FALSE

/datum/wires/pipebomb/New(atom/holder)
	wires = list(
		WIRE_BOOM
	)
	..()

/obj/wires/pipebomb/attackby(obj/item/item, mob/user, params)
	if(item.tool_behaviour == TOOL_SCREWDRIVER)
		if(!..())
		return FALSE
	var/obj/item/grenade/pipebomb/P = holder
	if(P.open_panel)
		return TRUE
	else
		return ..()

/datum/wires/pipebomb/on_pulse(wire)
	var/obj/wires/pipebomb/B = holder
	switch(wire)
		if(WIRE_BOOM)
			B.receive_signal()

/datum/wires/pipebomb/on_cut(wire, mend)
	var/obj/machinery/syndicatebomb/B = holder
	switch(wire)
		if(WIRE_BOOM)
			if(!mend && B.active)
				B.receive_signal()
				tell_admins(B)

/datum/wires/pipebomb/proc/tell_admins(obj/machinery/syndicatebomb/B)
	var/turf/T = get_turf(B)
	log_game("\A [B] was detonated via boom wire at [AREACOORD(T)].")
	message_admins("A [B.name] was detonated via boom wire at [ADMIN_VERBOSEJMP(T)].")
