
/datum/component/extensible_machine
	var/tool_behaviour
	var/extension_speed
	var/extension_directions
	var/deployed_directions
	var/list/extensions
	var/list/obj/extended_objects = list()

/datum/component/extensible_machine/Initialize(exst, ext_speed, tool, ext_dirs = ALL_CARDINALS)
	if (!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	extensions = exst
	extension_speed = ext_speed
	tool_behaviour = tool
	extension_directions = ext_dirs
	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, .proc/attacked)
	RegisterSignal(parent, COMSIG_PARENT_PREQDELETED, .proc/parent_removed)

/datum/component/extensible_machine/proc/parent_removed(datum/source, force)
	SIGNAL_HANDLER
	if (!length(extended_objects))
		return
	for (var/obj/O in extended_objects)
		qdel(O)

/datum/component/extensible_machine/proc/extension_removed(datum/source, force)
	SIGNAL_HANDLER
	if (!(source in extended_objects))
		return
	SEND_SIGNAL(parent, COMSIG_EXTENSION_BROKE, source)
	extended_objects -= source
	var/D = get_dir(parent, source)
	deployed_directions &= ~D
	for (var/K in extensions)
		if (extensions[K]["object"] == source.type && !isnull(extensions[K]["amount"]))
			extensions[source.type]["amount"]++
			return

/datum/component/extensible_machine/proc/attacked(datum/source, obj/item/I, mob/living/user)
	SIGNAL_HANDLER
	if (I.tool_behaviour != tool_behaviour)
		return
	var/D = get_dir(parent, user)
	if ((D & (D - 1))) // only cardinals.
		return COMPONENT_NO_AFTERATTACK
	if (!(D & extension_directions) || (D & deployed_directions))
		return COMPONENT_NO_AFTERATTACK
	INVOKE_ASYNC(src, .proc/extending, user)
	return COMPONENT_NO_AFTERATTACK

/datum/component/extensible_machine/proc/extending(mob/living/user)
	var/list/choices = list()
	for (var/K in extensions)
		var/V = extensions[K]
		if (!isnull(V["amount"]) && V["amount"] <= 0)
			continue
		choices[K] = V["image"]

	var/D = get_dir(parent, user) // Radial will not go away if you move so.
	var/choice = show_radial_menu(user, parent, choices, require_near = TRUE)
	var/obj/CO = extensions[choice]["object"]
	if (!CO)
		return
	user.visible_message("<span class='notice'>[user] starts extending [parent].</span>", "<span class='notice'>You start extending [parent].</span>")
	if (!do_after(user, extension_speed, parent))
		return
	if (!isnull(extensions[choice]["amount"]))
		extensions[choice]["amount"]--

	var/argus = list(get_step(parent, D), parent)
	if (extensions[choice]["arguments"])
		argus += extensions[choice]["arguments"]
	CO = new CO(arglist(argus))
	CO.dir = REVERSE_DIR(D)
	extended_objects += CO
	deployed_directions |= D
	RegisterSignal(CO, COMSIG_PARENT_PREQDELETED, .proc/extension_removed)
	SEND_SIGNAL(parent, COMSIG_EXTEND_MACHINE, CO, user)
