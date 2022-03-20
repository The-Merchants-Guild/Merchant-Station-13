/obj/item/holotool
	name = "experimental holotool"
	desc = "A highly experimental holographic tool projector."
	icon = 'icons/obj/objects.dmi'
	inhand_icon_state = "holotool"
	icon_state = "holotool"
	damtype = BURN
	force = 0
	slot_flags = ITEM_SLOT_BELT
	hitsound = 'sound/weapons/blade1.ogg'
	usesound = 'sound/items/pshoom.ogg'
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	actions_types = list(/datum/action/item_action/change_tool, /datum/action/item_action/change_ht_color)
	w_class = WEIGHT_CLASS_TINY

	var/obj/item/current_tool = 0
	var/current_color = "#48D1CC" //mediumturquoise

/obj/item/holotool/proc/AddTool(typee, namee)
	var/obj/item/WR = new typee(src)
	WR.forceMove(src)
	WR.name = namee
	WR.usesound = usesound //use the same sound as we do
	WR.toolspeed = 0.55

/obj/item/holotool/proc/AddTools()
	AddTool(/obj/item/wrench, "holo-wrench")
	AddTool(/obj/item/screwdriver, "holo-screwdriver")
	AddTool(/obj/item/wirecutters, "holo-wirecutters")
	AddTool(/obj/item/weldingtool/largetank, "holo-welder")
	AddTool(/obj/item/crowbar, "holo-crowbar")
	AddTool(/obj/item/multitool, "holo-multitool")

/obj/item/holotool/Initialize()
	. = ..()
	//create and rename tools
	AddTools()

/obj/item/holotool/attack_self(mob/living/user)
	if(current_tool)
		current_tool.attack_self(user)
	update_icons()

/obj/item/holotool/ui_action_click(mob/user, datum/action/action)
	if(istype(action, /datum/action/item_action/change_tool))
		var/chosen = input("Choose tool settings", "Tool", null, null) as null|anything in contents
		if(!chosen)
			return
		current_tool = chosen
		if(istype(current_tool, /obj/item/holoknife))
			force = 10
			armour_penetration = 10
			sharpness = SHARP_EDGED
			attack_verb_simple = list("attacked", "chopped", "cleaved", "torn", "cut")
			attack_verb_continuous = list("attacked", "chopped", "cleaved", "torn", "cut")
		else
			force = 0
			armour_penetration = 10
			sharpness = NONE
			attack_verb_simple = "poked"
			attack_verb_continuous = "poked"
		src.tool_behaviour = current_tool.tool_behaviour
		playsound(loc, 'sound/items/rped.ogg', get_clamped_volume(), 1, -1)
		update_icons()
	else
		var/C = input(user, "Select Color", "Select color", "#48D1CC") as null|color
		if(!C || QDELETED(src))
			return
		current_color = C
		update_icons()
	action.UpdateButtonIcon()
	update_icons()

/obj/item/holotool/proc/update_icons()
	cut_overlays()
	if(current_tool)
		var/mutable_appearance/holo_item = mutable_appearance(icon, current_tool.name)
		holo_item.color = current_color
		inhand_icon_state = current_tool.name
		add_overlay(holo_item)
		set_light(3, null, current_color)
	else
		inhand_icon_state = "holotool"
		icon_state = "holotool"
		set_light(0)

	for(var/datum/action/A in actions)
		A.UpdateButtonIcon()

/obj/item/holotool/emag_act(mob/user)
	if(!(/obj/item/holoknife in GetAllContents(src)))
		to_chat(user, "<span class='danger'>ZZT- ILLEGAL BLUEPRINT UNLOCKED- CONTACT !#$@^%$# NANOTRASEN SUPPORT-@*%$^%!</span>")
		var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread()
		sparks.set_up(5, 0, loc)
		sparks.start()
		AddTool(/obj/item/holoknife, "holo-knife")




/obj/item/holoknife
	name = "holo-knife"
	force = 5
	armour_penetration = 10
	sharpness = SHARP_EDGED
	attack_verb_simple = list("attacked", "chopped", "cleaved", "torn", "cut")
	attack_verb_continuous = list("attacked", "chopped", "cleaved", "torn", "cut")
	hitsound = 'sound/weapons/blade1.ogg'


/obj/structure/closet/secure_closet/research_director/PopulateContents()
	. = ..()
	new /obj/item/holotool(src)
