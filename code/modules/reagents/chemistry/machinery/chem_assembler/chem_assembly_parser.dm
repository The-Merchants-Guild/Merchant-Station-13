/datum/chem_assembly_parser
	var/list/instructions = list(
		"mov" = /datum/chem_assembly_instruction/move,
		"syn" = /datum/chem_assembly_instruction/synthesise,
		"get" = /datum/chem_assembly_instruction/get,
		"put" = /datum/chem_assembly_instruction/put,
		"rem" = /datum/chem_assembly_instruction/remove,
		"tmp" = /datum/chem_assembly_instruction/temp,
		"flt" = /datum/chem_assembly_instruction/filter,
		"int" = /datum/chem_assembly_instruction/interrupt,
		"jmp" = /datum/chem_assembly_instruction/jump,
		"jsf" = /datum/chem_assembly_instruction/jump/jump_slot_full,
		"jse" = /datum/chem_assembly_instruction/jump/jump_slot_empty,
		"jsa" = /datum/chem_assembly_instruction/jump/jump_slot_acidic,
		"jsb" = /datum/chem_assembly_instruction/jump/jump_slot_basic,
		"jsr" = /datum/chem_assembly_instruction/jump/jump_slot_reacting,
		"jtc" = /datum/chem_assembly_instruction/jump/jump_temperature_correct,
		"sneed" = /datum/chem_assembly_instruction/sneed
	)

	var/list/state

/datum/chem_assembly_parser/New(S)
	. = ..()
	state += S

/datum/chem_assembly_parser/proc/reset()
	state["labels"] = list()

/datum/chem_assembly_parser/proc/parse(text, arguments)
	reset()
	var/error
	text = replacetext(replacetext(text, regex("  +", "g"), " "), regex("^ +| +$|^\\n|\\n$", "gm"), "")
	if (!text)
		return "Nothing to parse."
	var/list/lines = splittext(lowertext(text), "\n")
	var/line_num = 0
	var/label
	var/list/program = list()
	for (var/L in lines)
		line_num++
		L = splittext(L, ";")[1]
		if (!length(L))
			continue
		if (findtext(L, ":"))
			label = splittext(L, ":")
			if (length(label) == 2)
				L = replacetext(label[2], regex("^ +| +$", "gm"), "")
				label = label[1]
			else
				label = label[1]
				continue
		var/is = splittext(L, " ")[1]
		if (!instructions[is])
			error = "L[line_num]: Error invalid instruction '[is]'."
			break
		var/inst_path = instructions[is]
		var/datum/chem_assembly_instruction/inst = new inst_path
		var/is_args = splittext(copytext(L, length(is) + 1, 0), ",")
		for (var/I in 1 to length(is_args))
			is_args[I] = replacetext(is_args[I], regex("^ +| +$", "gm"), "")
		if (label)
			state["labels"][label] = inst
			label = ""
		program += list(list(inst, is_args, line_num))

	if (!error)
		for (var/I in 1 to length(program))
			var/datum/chem_assembly_instruction/ins = program[I][1]
			if (I < length(program))
				ins.next = program[I + 1][1]
			var/R = ins.parse_arguments(program[I][2], state)
			if (istext(R))
				error = "L[program[I][3]]: Error '[R]'."
				break

	if (error)
		for (var/I in 1 to length(program))
			qdel(program[I][1])
			program[I][1] = null
		return error

	return program[1][1]
