/obj/machinery/ore_refiner/grinder
	name = "ore grinder"
	desc = "A machine that uses industrial diamond grinding wheels to break down ore."
	processes = list("0" = list(/datum/material/iron = 25, /datum/material/gold = 10, /datum/material/silver = 10, /datum/material/titanium = 10))

/obj/machinery/ore_refiner/grinder/Initialize()
	. = ..()
	overlays += mutable_appearance('icons/obj/drilling.dmi', "grinder")
