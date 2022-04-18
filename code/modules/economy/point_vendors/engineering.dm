/obj/machinery/point_vendor/engineering
	name = "\improper Engi-Vend"
	desc = "A vendor for engineering equipment."
	icon_state = "engivend"
	icon_deny = "engivend-deny"
	light_mask = "engivend-light-mask"
	department = ACCOUNT_ENG

	equipment_list = list(
		/obj/item/clothing/glasses/meson/engine = list("Engineering Scanner Goggles", 50, 400, 2, 4 MINUTES),
		/obj/item/clothing/glasses/welding = list("Welding Goggles", 50, 400, 3, 4 MINUTES),
		/obj/item/multitool = list("Multitool", 10, 100, 4, 2 MINUTES),
		/obj/item/grenade/chem_grenade/smart_metal_foam = list("Smart Metal Foam Grenade", 25, 250, 10, 2 MINUTES),
		/obj/item/geiger_counter = list("Geiger Counter", 10, 100, 5, 2 MINUTES),
		/obj/item/stock_parts/cell/high = list("High-Capacity Power Cell", 80, 500, 10, 8 MINUTES),
		/obj/item/storage/belt/utility = list("Toolbelt", 200, 1000, 3, 5 MINUTES),
		/obj/item/construction/rcd/loaded = list("Rapid-Construction-Device", 500, 5000, 2, 10 MINUTES),
		/obj/item/storage/box/smart_metal_foam = list("Box of Smart Metal Foam Grenades", 150, 1500, 1, 10 MINUTES)
	)
