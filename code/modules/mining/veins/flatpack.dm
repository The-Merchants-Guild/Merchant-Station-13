/obj/structure/flatpack
	name = "flatpack"
	icon = 'icons/obj/drilling.dmi'
	icon_state = "flatpack"
	var/contained_object

/obj/structure/flatpack/crowbar_act(mob/living/user, obj/item/tool)
	. = ..()
	user.visible_message(span_notice("[user] starts unpacking the [src]."), span_notice("You start unpacking the [src]."))
	if (!do_after(user, 2 SECONDS, src))
		return
	tool.play_tool_sound(src)
	if (ispath(contained_object))
		var/O = new contained_object(get_turf(src))
		user.visible_message(span_notice("[user] unpacks the [O]."), span_notice("You unpack the [O]."))
		qdel(src)
		return
	else if (istype(contained_object, /atom/movable))
		var/atom/movable/AM = contained_object
		AM.forceMove(get_turf(src))
		user.visible_message(span_notice("[user] unpacks the [AM]."), span_notice("You unpack the [AM]."))
		qdel(src)
		return
	else
		to_chat(user, span_warning("There was nothing inside."))
		qdel(src)
		return
