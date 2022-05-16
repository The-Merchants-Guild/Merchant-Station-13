/obj/item/canister_regulator_breaker
	name = "canister pressure regulator breaker"
	desc = "This just looks like a hammer."
	icon_state = "regulator_breaking_tool"
	force = 20

/obj/item/canister_regulator_breaker/pre_attack(atom/A, mob/living/user, params)
	. = ..()
	if (.)
		playsound(loc, 'sound/effects/bang.ogg', 50, 1) // I like the sound.

/obj/item/canister_regulator_breaker/attack_obj(obj/O, mob/living/user, params)
	if (istype(O, /obj/machinery/portable_atmospherics/canister))
		var/obj/machinery/portable_atmospherics/canister/C = O
		C.release_pressure = INFINITY
		C.broken_regulator = TRUE
	. = ..()
