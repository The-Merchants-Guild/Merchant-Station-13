/obj/item/circuitboard/machine/bluespace_miner
	name = "Bluespace Miner (Machine Board)"
	build_path = /obj/machinery/mineral/bluespace_miner
	req_components = list(
		/obj/item/stock_parts/matter_bin = 3,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/manipulator = 3,
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stack/ore/bluespace_crystal = 3,
		/obj/item/stack/sheet/mineral/gold = 1,
		/obj/item/stack/sheet/mineral/uranium = 1)
	needs_anchored = FALSE

/datum/techweb_node/bluemining
	id = "bluemining"
	display_name = "Bluespace Mining Technologies"
	description = "Through the power of Bluespace-Assisted A.S.S Compression it is possible to mine resources."
	prereq_ids = list("practical_bluespace")
	design_ids = list("bluemine")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 10000)

/datum/design/bluemine
	name = "Machine Design (Bluespace Miner)"
	desc = "Through the joint effort of Bluespace-A.S.S Technologies, It is now possible to mine a trickle of resources via Bluespace Magic..."
	id = "bluemine"
	build_type = IMPRINTER
	materials = list(/datum/material/gold = 500, /datum/material/silver = 500, /datum/material/bluespace = 500) //quite cheap, for more convenience
	build_path = /obj/item/circuitboard/machine/bluespace_miner
	category = list("Bluespace Designs")

/obj/machinery/mineral/bluespace_miner
	name = "bluespace mining machine"
	desc = "A machine that uses the magic of Bluespace to slowly generate materials and add them to a linked ore silo."
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "bs_miner"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/bluespace_miner
	layer = BELOW_OBJ_LAYER
	processing_flags = START_PROCESSING_ON_INIT
	var/list/ores = list(/datum/material/iron = 600, /datum/material/plasma = 400,  /datum/material/silver = 400, /datum/material/gold = 250, /datum/material/titanium = 250, /datum/material/uranium = 250, /datum/material/bananium = 90, /datum/material/diamond = 90, /datum/material/bluespace = 90)
	var/datum/component/remote_materials/materials

/obj/machinery/mineral/bluespace_miner/Initialize(mapload)
	. = ..()
	materials = AddComponent(/datum/component/remote_materials, "bsm", mapload)


/obj/machinery/mineral/bluespace_miner/Destroy()
	materials = null
	return ..()

/obj/machinery/mineral/bluespace_miner/multitool_act(mob/living/user, obj/item/multitool/I)
	. = ..()
	if (istype(I))
		to_chat(user, "<span class='notice'>You update [src] with the multitool's buffer.</span>")
		materials?.silo = I.buffer
		return TRUE
	else
		to_chat(user, "<span class='notice'>The buffer is empty.</span>")
		return FALSE

/obj/machinery/mineral/bluespace_miner/examine(mob/user)
	. = ..()
	if(!materials?.silo)
		. += "<span class='notice'>No ore silo connected. Use a multi-tool to link an ore silo to this machine.</span>"
	else if(materials?.on_hold())
		. += "<span class='warning'>Ore silo access is on hold, please contact the quartermaster.</span>"

/obj/machinery/mineral/bluespace_miner/process()
	if(!materials?.silo || materials?.on_hold())
		return
	var/datum/component/material_container/mat_container = materials.mat_container
	if(!mat_container || panel_open || !powered())
		return
	var/datum/material/ore = pick(ores)
	materials.mat_container.insert_amount_mat(ores[ore], ore)

