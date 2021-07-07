/datum/chem_assembly_instruction/jump/jump_slot_acidic/execute(obj/machinery/chem_assembler/A)
	if (A.current_slot.ph < CHEMICAL_NORMAL_PH)
		A.current = jump_to
		return CHEM_INST_RERUN
	return CHEM_INST_SUCCESS
