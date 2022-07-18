/datum/job/arms_dealer
	title = "Arms Dealer"
	department_head = list("Head of Personnel")
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#bbe291"

	outfit = /datum/outfit/job/arms_dealer
	plasmaman_outfit = /datum/outfit/plasmaman/arms

	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_ARMS_DEALER
	bounty_types = CIV_JOB_RANDOM
	departments = DEPARTMENT_SERVICE

	family_heirlooms = list(/obj/item/clothing/head/bearpelt)

	mail_goodies = list(
		/obj/item/ammo_box/a762,
		/obj/item/reagent_containers/glass/bottle/clownstears = 10,
		/obj/item/stack/sheet/mineral/plasma = 10,
		/obj/item/stack/sheet/mineral/uranium = 10,
	)

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE


/datum/outfit/job/arms_dealer
	name = "Arms Dealer"
	head = /obj/item/clothing/head/ushanka
	jobtype = /datum/job/arms_dealer
	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/color/black
	belt = /obj/item/pda/arms
	ears = /obj/item/radio/headset/headset_srv
	mask = /obj/item/clothing/mask/gas
	uniform = /obj/item/clothing/under/costume/soviet
	suit = /obj/item/clothing/suit/armor/vest/russian_coat
	shoes = /obj/item/clothing/shoes/jackboots
	id_trim = /datum/id_trim/job/arms_dealer

/datum/outfit/job/arms_dealer/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()

	var/obj/item/card/id/W = H.wear_id
	if(H.age < AGE_MINOR)
		W.registered_age = AGE_MINOR
		to_chat(H, span_notice("You're not technically old enough to buy or sell guns, but your ID has been discreetly modified to display your age as [AGE_MINOR]. Try to keep that a secret!"))
