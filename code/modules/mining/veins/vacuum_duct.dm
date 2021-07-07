/obj/machinery/vacuum_duct
	name = "vacuum duct"
	icon = 'icons/obj/plumbing/fluid_ducts.dmi'
	icon_state = "nduct"

/obj/item/stack/vaccum_duct
	name = "stack of vacuum ducts"
	desc = "A stack of vacuum ducts."
	singular_name = "duct"
	icon = 'icons/obj/plumbing/fluid_ducts.dmi'
	icon_state = "ducts"
	mats_per_unit = list(/datum/material/iron=500)
	w_class = WEIGHT_CLASS_TINY
	novariants = FALSE
	max_amount = 50
	item_flags = NOBLUDGEON
	merge_type = /obj/item/stack/vaccum_duct

/obj/item/stack/ducts/afterattack(atom/target, user, proximity)
	. = ..()
	if(!proximity)
		return
	if(istype(target, /obj/machinery/vaccum_duct))
		var/obj/machinery/vaccum_duct/D = target
		if(!D.anchored)
			add(1)
			qdel(D)
	check_attach_turf(target)

/obj/item/stack/ducts/proc/check_attach_turf(atom/target)
	if(istype(target, /turf/open) && use(1))
		var/turf/open/open_turf = target
		new /obj/machinery/vacuum_duct(open_turf, FALSE)
		playsound(get_turf(src), 'sound/machines/click.ogg', 50, TRUE)
