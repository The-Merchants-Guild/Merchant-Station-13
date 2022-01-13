GLOBAL_LIST_EMPTY(interface_contracts)
//The "fake" interface type, it is actually a children of Datum BUT NEVER FUCKING INSTANTIATE IT, you can cast things *to* it, but never instantiate it, since it should actually be abstract but byond doesnt handle that.
/interface

/interface/New()
	stack_trace("Attempting to initialize an interface type")

/interface/Destroy()
	stack_trace("Attempting to destroy an interface type")
	return ..()



//The interface contract, something that holds all the relevant data to actually checking if a given type contains given procs
/datum/interface_contract
	var/interface/contractor = null
	var/datum/contracted_type = null

/datum/interface_contract/New(datum/_contracted_type, interface/_contractor)
	. = ..()
	contractor = _contractor
	contracted_type = _contracted_type
	GLOB.interface_contracts += src

/datum/interface_contract/Destroy(force, ...)
	contractor = null
	contracted_type = null
	return ..()

/proc/check_implementations()
	var/failed = FALSE
	for(var/datum/interface_contract/contract as anything in GLOB.interface_contracts)
		var/list/i_procs = __sanitize_list(typesof("[contract.contractor]/proc"))
		var/list/o_procs = __sanitize_list(typesof("[contract.contracted_type]/proc"))
		if((i_procs & o_procs).len != i_procs.len)
			stack_trace("INTERFACE CONTRACT BREACHED AT [contract.contracted_type]! DOESNT IMPLEMENT [contract.contractor] PROCS!")
			for(var/missing in i_procs - o_procs)
				stack_trace("CRITICAL ERROR! MISSING [missing] IMPLEMENTATION ON [contract.contracted_type]")
			failed = TRUE
	//lets free up the memory since this happens only on init
	QDEL_LIST(GLOB.interface_contracts)
	return failed

/proc/__sanitize_list(list/items)
	var/list/sanitized_procs = list()
	for(var/item in items)
		var/sanitized_text = copytext("[item]",findtext("[item]","proc"))

		sanitized_procs += sanitized_text
	return sanitized_procs

///IMPLEMENTS MACRO, id must be unique and cannot be the same as interface or type, type is the path that implements the interface, and interface is the actual interface (just the name), may not work directly on /datum type, so dont try that (variable redefiniton bullshittery)
#define IMPLEMENTS(__parent,__type,__interface) GLOBAL_DATUM_INIT(##__interface##__type,/datum/interface_contract,new /datum/interface_contract(##__parent/##__type,/interface/##__interface)); \
##__parent/##__type/implementation = TRUE;																																					\
##__parent/##__type/var/___implements_##__interface = TRUE;

#define DEF_INTERFACE(__name) /interface/##__name

#define DEF_INTERFACE_PROC(__interface_type, __name) /interface/##__interface_type/proc/##__name(){return}

#define IS_IMPLEMENTATION(__object)  ##__object.implementation

#define TOTEXT(x) #x

#define IS_IMPLEMENTATION_OF(__object, __interface) !isnull(__object.vars[TOTEXT(___implements_##__interface)])

DEF_INTERFACE(test_interface)

DEF_INTERFACE_PROC(test_interface,foo)

IMPLEMENTS(/datum,interface_test,test_interface)
/datum/interface_test

/datum/interface_test/proc/bar()
	return 1

/datum/interface_test/proc/foo()
	return 1



