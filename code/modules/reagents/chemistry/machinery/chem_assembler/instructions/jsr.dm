/datum/chem_assembly_instruction/jump/jump_slot_reacting/execute(obj/machinery/chem_assembler/A)
	if (A.current_slot.is_reacting)
		A.current = jump_to
		return CHEM_INST_RERUN
	return CHEM_INST_SUCCESS
