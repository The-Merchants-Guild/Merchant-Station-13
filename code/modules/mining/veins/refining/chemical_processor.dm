/obj/machinery/ore_refiner/chemical_processor
	name = "chemical processor"
	desc = "A machine for doing various chemical actions to ore."
	processes = list("0" = list(/datum/material/bluespace = 10),
					 "1" = list(/datum/material/gold = 10, /datum/material/silver = 10, /datum/material/titanium = 10),
					 "2" = list(/datum/material/silver = 10))

/obj/machinery/ore_refiner/chemical_processor/Initialize()
	. = ..()
	overlays += mutable_appearance('icons/obj/drilling.dmi', "chem")

