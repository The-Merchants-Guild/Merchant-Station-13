/obj/machinery/ore_refiner/chemical_processor
	name = "chemical processor"
	desc = "A machine for doing various chemical actions to ore."

/obj/machinery/ore_refiner/chemical_processor/Initialize()
	. = ..()
	overlays += mutable_appearance('icons/obj/drilling.dmi', "chem")

