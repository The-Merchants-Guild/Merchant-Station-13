
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

/datum/component/extensible_machine/proc/extension_removed(datum/source, force)
	SIGNAL_HANDLER
	if (!(source in extended_objects))
		return
	SEND_SIGNAL(parent, COMSIG_EXTENSION_BROKE, source)
	extended_objects -= source
	var/D = get_dir(parent, source)
	deployed_directions &= ~D
	if (isnull(extensions[source.type][2]))
		return
	extensions[source.type][2]++

/datum/component/extensible_machine/proc/attacked(datum/source, obj/item/I, mob/living/user)
	SIGNAL_HANDLER
	if (I.tool_behaviour != tool_behaviour)
		return
	var/D = get_dir(parent, user)
	if ((D & (D - 1)))
		return COMPONENT_NO_AFTERATTACK
	if (!(D & extension_directions) || (D & deployed_directions))
		return COMPONENT_NO_AFTERATTACK
	INVOKE_ASYNC(src, .proc/extending, user)
	return COMPONENT_NO_AFTERATTACK

/datum/component/extensible_machine/proc/extending(mob/living/user)
	var/list/choices = list()
	for (var/K in extensions)
		var/V = extensions[K]
		if (!isnull(V[2]) && V[2] <= 0)
			continue
		var/obj/O = K
		choices[initial(O.name)] = V[1]

	var/choice = show_radial_menu(user, parent, choices, require_near = TRUE)
	var/obj/CO
	for (var/K in extensions)
		var/obj/O = K
		if (initial(O.name) == choice)
			CO = K
			break
	if (!CO)
		return
	user.visible_message("<span class='notice'>[user] starts extending [parent].</span>", "<span class='notice'>You start extending [parent].</span>")
	if (!do_after(user, extension_speed, parent))
		return
	if (!isnull(extensions[CO][2]))
		extensions[CO][2]--

	var/D = get_dir(parent, user)
	CO = new CO(get_step(parent, D))
	CO.dir = REVERSE_DIR(D)
	extended_objects += CO
	deployed_directions |= D
	RegisterSignal(CO, COMSIG_PARENT_PREQDELETED, .proc/extension_removed)
	SEND_SIGNAL(parent, COMSIG_EXTEND_MACHINE, CO, user)
