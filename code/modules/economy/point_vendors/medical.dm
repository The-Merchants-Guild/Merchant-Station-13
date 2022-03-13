/obj/machinery/point_vendor/medical
	name = "\improper NanoMed Plus"
	desc = "A vendor for medical equipment."
	icon_state = "med"
	icon_deny = "med-deny"
	light_mask = "med-light-mask"
	department = ACCOUNT_MED

	equipment_list = list(
		/obj/item/stack/medical/gauze = list("Medical Gauze", 25, 100, 8, 10 SECONDS),
		/obj/item/reagent_containers/syringe = list("Syringe", 25, 100, 12, 10 SECONDS),
		/obj/item/reagent_containers/dropper = list("Dropper", 25, 100, 3, 10 SECONDS),
		/obj/item/healthanalyzer = list("Health Analyzer", 100, 400, 4, 4 MINUTES),
		/obj/item/wrench/medical = list("Medical Wrench", 50, 200, 1, 4 MINUTES),
		/obj/item/stack/sticky_tape/surgical = list("Surgical Tape", 25, 100, 3, 10 SECONDS),
		/obj/item/healthanalyzer/wound = list("First Aid Analyzer", 50, 200, 4, 4 MINUTES),
		/obj/item/stack/medical/ointment = list("Oinment", 25, 100, 2, 30 SECONDS),
		/obj/item/stack/medical/suture = list("Suture", 25, 100, 2, 30 SECONDS),
		/obj/item/stack/medical/bone_gel/four = list("Bone Gel", 25, 100, 4, 30 SECONDS),
		/obj/item/reagent_containers/hypospray/medipen = list("Epinepherine Medipen", 25, 100, 3, 1 MINUTES),
		/obj/item/storage/belt/medical = list("Medical Belt", 100, 400, 2, 8 MINUTES),
		/obj/item/sensor_device = list("Handheld Crew Monitor", 200, 800, 2, 8 MINUTES),
		/obj/item/pinpointer/crew = list("Crew Pinpointer", 250, 900, 2, 4 MINUTES),
		/obj/item/storage/firstaid/advanced = list("Advanced First Aid Kit", 500, 2000, 2, 10 MINUTES),
		/obj/item/shears = list("Amputation Shears", 500, 2000, 1, 10 MINUTES),
		/obj/item/storage/organbox = list("Organ Transport Box", 400, 1600, 1, 10 MINUTES)
	)

/obj/machinery/point_vendor/drug
	name = "\improper NanoDrug Plus"
	desc = "A vendor for drugs."
	icon_state = "drug"
	icon_deny = "drug-deny"
	department = ACCOUNT_MED

	equipment_list = list(
		/obj/item/reagent_containers/pill/patch/libital = list("Libital Patch (Brute)", 10, 40, 5, 10 SECONDS),
		/obj/item/reagent_containers/pill/patch/aiuri = list("Aiuri Patch (Burn)", 10, 40, 5, 10 SECONDS),
		/obj/item/reagent_containers/syringe/convermol = list("Convermol Syringe", 5, 20, 2, 10 SECONDS),
		/obj/item/reagent_containers/pill/insulin = list("Insulin Pill", 10, 40, 5, 10 SECONDS),
		/obj/item/reagent_containers/glass/bottle/multiver = list("Multiver Bottle", 10, 40, 2, 10 SECONDS),
		/obj/item/reagent_containers/glass/bottle/syriniver = list("Syriniver Bottle", 10, 40, 2, 10 SECONDS),
		/obj/item/reagent_containers/glass/bottle/epinephrine = list("Epinephrine Bottle", 10, 40, 3, 10 SECONDS),
		/obj/item/reagent_containers/glass/bottle/morphine = list("Morphine Bottle", 10, 40, 4, 10 SECONDS),
		/obj/item/reagent_containers/glass/bottle/potass_iodide = list("Anti-Radiation Bottle", 10, 40, 1, 10 SECONDS),
		/obj/item/reagent_containers/glass/bottle/salglu_solution = list("Saline-Glucose Solution Bottle", 10, 40, 3, 10 SECONDS),
		/obj/item/reagent_containers/glass/bottle/toxin = list("Toxin Bottle", 10, 40, 3, 10 SECONDS),
		/obj/item/reagent_containers/syringe/antiviral = list("Spaceacillin Syringe", 5, 20, 6, 10 SECONDS),
		/obj/item/reagent_containers/medigel/libital = list("Libital Medical Gel", 50, 200, 2, 5 MINUTES),
		/obj/item/reagent_containers/medigel/aiuri = list("Aiuri Medical Gel", 50, 200, 2, 5 MINUTES),
		/obj/item/reagent_containers/medigel/sterilizine = list("Sterilizer Gel", 50, 200, 1, 5 MINUTES),
		/obj/item/reagent_containers/medigel/synthflesh = list("Synthflesh Medical Gel", 100, 400, 2, 5 MINUTES),
		/obj/item/storage/pill_bottle/psicodine = list("Psicodine Pill Bottle", 50, 200, 2, 5 MINUTES)
	)
