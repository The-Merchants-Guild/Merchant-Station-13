GLOBAL_LIST_EMPTY(interface_contracts)
//The "fake" interface type, it is actually a children of Datum BUT NEVER FUCKING INSTANTIATE IT, you can cast things *to* it, but never instantiate it, since it should actually be abstract but byond doesnt handle that.
/interface

/interface/New()
	stack_trace("Attempting to initialize an interface type")

/interface/Destroy()
	stack_trace("Attempting to destroy an interface type")
	return ..()

//Definition of the interface, You shouldn't make children of interfaces because things WILL break
#define INTERFACE_DEF(X) 													\
/interface/##X; 															\
																			\
/datum/interface_contract_proc_holder/proc/interface_procs_##X(){  	\
	return typesof(/interface/##X/proc);									\
}

/datum/interface_contract_proc_holder

//The interface contract, something that holds all the relevant data to actually checking if a given type contains given procs
/datum/interface_contract
	var/interface/contractor = null
	var/contracted_type = null
	var/type_id
	var/interface_id

/datum/interface_contract/New(_interface_id, _type_id, interface/_contractor, datum/_contracted_type)
	. = ..()
	contractor = _contractor
	contracted_type = _contracted_type
	interface_id = _interface_id
	type_id = _type_id
	GLOB.interface_contracts += src

/datum/interface_contract/Destroy(force, ...)
	contractor = null
	contracted_type = null
	return ..()

/proc/check_implementations()
	var/datum/interface_contract_proc_holder/holder = new()

	for(var/datum/interface_contract/contract as anything in GLOB.interface_contracts)
		var/list/procs = call(holder,"interface_procs_[contract.interface_id]")()

		for(var/object as anything in procs)
			var/list/object_procs = call(holder,"object_procs_[contract.type_id][contract.interface_id]")()

			//ok now we can actually do the checking
			if(__check_implementation(__sanitize_list(procs,"[contract.contractor]"), __sanitize_list(object_procs,"[contract.contracted_type]")))
				continue

			stack_trace("INTERFACE CONTRACT BREACHED! [contract.contracted_type] doesn't implement all of [contract.contractor] procs!")
			return 1

	//lets free up the memory since this happens only on init
	QDEL_LIST(GLOB.interface_contracts)
	QDEL_NULL(holder)
	return 0

/proc/__sanitize_list(list/items)
	var/list/sanitized_procs = list()
	for(var/item in items)
		var/sanitized_text = copytext("[item]",findtext("[item]","proc"))

		sanitized_procs += sanitized_text
	return sanitized_procs

/proc/__check_implementation(list/interface_procs,list/object_procs)
	var/list/missing_procs = list()
	for(var/interface_proc in interface_procs)
		var/found = FALSE
		for(var/object_proc in object_procs)
			if(interface_proc == object_proc)
				found = TRUE
		if(!found)
			missing_procs += interface_proc
	return (missing_procs.len == 0)


///IMPLEMENTS MACRO, id must be unique and cannot be the same as interface or type, type is the path that implements the interface, and interface is the actual interface (just the name)
#define IMPLEMENTS(id,type,xinterface) 																					\
GLOBAL_DATUM_INIT(__##id_##xinterface,/datum/interface_contract,new(#xinterface,#id,/interface/##xinterface,##type)); 	\
/datum/interface_contract_proc_holder/proc/object_procs_##id##xinterface(){  											\
	return typesof(##type/proc);																						\
}


INTERFACE_DEF(test_interface)

/interface/test_interface/proc/foo()
	return

/datum/interface_test

/datum/interface_test/proc/bar()
	return 1

/datum/interface_test/proc/foo()
	return 1

IMPLEMENTS(interface_test,/datum/interface_test,test_interface)



