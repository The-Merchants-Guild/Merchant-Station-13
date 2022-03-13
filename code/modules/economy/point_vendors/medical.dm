/obj/machinery/point_vendor/medical
	name = "\improper NanoMed Plus"
	desc = "A vendor for medical equipment."
	icon_state = "med"
	icon_deny = "med-deny"
	light_mask = "med-light-mask"
	department = ACCOUNT_MED

	equipment_list = list(
		/obj/item/stack/medical/gauze = list("Medical Gauze"),
		/obj/item/reagent_containers/syringe = list("Syringe"),
		/obj/item/reagent_containers/dropper = list("Dropper"),
		/obj/item/healthanalyzer = list("Health Analyzer"),
		/obj/item/wrench/medical = list("Medical Wrench"),
		/obj/item/stack/sticky_tape/surgical = list("Surgical Tape"),
		/obj/item/healthanalyzer/wound = list("First Aid Analyzer"),
		/obj/item/stack/medical/ointment = list("Oinment"),
		/obj/item/stack/medical/suture = list("Suture"),
		/obj/item/stack/medical/bone_gel/four = list("Bone Gel"),
		/obj/item/reagent_containers/hypospray/medipen = list("Epinepherine Medipen"),
		/obj/item/storage/belt/medical = list("Medical Belt"),
		/obj/item/sensor_device = list("Handheld Crew Monitor"),
		/obj/item/pinpointer/crew = list("Crew Pinpointer"),
		/obj/item/storage/firstaid/advanced = list("Advanced First Aid Kit"),
		/obj/item/shears = list("Amputation Shears"),
		/obj/item/storage/organbox = list("Organ Transport Box")
	)

/obj/machinery/point_vendor/drug
	name = "\improper NanoDrug Plus"
	desc = "A vendor for drugs."
	icon_state = "drug"
	icon_deny = "drug-deny"
	department = ACCOUNT_MED

	equipment_list = list(
		/obj/item/reagent_containers/pill/patch/libital = 5,
		/obj/item/reagent_containers/pill/patch/aiuri = 5,
		/obj/item/reagent_containers/syringe/convermol = 2,
		/obj/item/reagent_containers/pill/insulin = 5,
		/obj/item/reagent_containers/glass/bottle/multiver = 2,
		/obj/item/reagent_containers/glass/bottle/syriniver = 2,
		/obj/item/reagent_containers/glass/bottle/epinephrine = 3,
		/obj/item/reagent_containers/glass/bottle/morphine = 4,
		/obj/item/reagent_containers/glass/bottle/potass_iodide = 1,
		/obj/item/reagent_containers/glass/bottle/salglu_solution = 3,
		/obj/item/reagent_containers/glass/bottle/toxin = 3,
		/obj/item/reagent_containers/syringe/antiviral = 6,
		/obj/item/reagent_containers/medigel/libital = 2,
		/obj/item/reagent_containers/medigel/aiuri = 2,
		/obj/item/reagent_containers/medigel/sterilizine = 1,
		/obj/item/reagent_containers/medigel/synthflesh = 2,
		/obj/item/storage/pill_bottle/psicodine = 2
	)
