/obj/machinery/point_vendor/security
	name = "\improper SecTech"
	desc = "A vendor for security equipment."
	icon_state = "sec"
	icon_deny = "sec-deny"
	light_mask = "sec-light-mask"
	department = ACCOUNT_SEC

	equipment_list = list(
		/obj/item/restraints/handcuffs = list("Handcuffs", 50, 350, 8, 1 MINUTES),
		/obj/item/restraints/handcuffs/cable/zipties = list("Zipties", 40, 300, 10, 1 MINUTES),
		/obj/item/grenade/flashbang = list("Flashbang", 100, 750, 4, 4 MINUTES),
		/obj/item/assembly/flash/handheld = list("Flash", 100, 750, 5, 4 MINUTES),
		/obj/item/food/donut = list("Donut", 25, 200, 12, 30 SECONDS),
		/obj/item/storage/box/evidence = list("Evidence Bag Box", 100, 750, 6, 8 MINUTES),
		/obj/item/flashlight/seclite = list("Seclite", 75, 600, 4, 3 MINUTES),
		/obj/item/restraints/legcuffs/bola/energy = list("Energy Bola", 45, 350, 7, 5 MINUTES),
		/obj/item/storage/belt/security/webbing = list("Security Webbing", 400, 2000, 5, 10 MINUTES),
		/obj/item/coin/antagtoken = list("Antag Token", 80, 200, 1, 0),
		/obj/item/clothing/head/helmet/blueshirt = list("Blue Helmet", 200, 1000, 1, 10 MINUTES),
		/obj/item/clothing/suit/armor/vest/blueshirt = list("Large Armor Vest", 200, 1000, 1, 10 MINUTES),
		/obj/item/clothing/gloves/tackler = list("Gripper Gloves", 300, 1500, 5, 8 MINUTES),
		/obj/item/grenade/stingbang = list("Stingbang", 400, 2000, 1, 5 MINUTES),
		/obj/item/watertank/pepperspray = list("ANTI-TIDER-2500 Supression Backpack", 500, 3000, 2, 15 MINUTES)
	)
