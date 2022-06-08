/datum/computer_file/program/wbcontroller
	filename = "wbcontroller"
	filedesc = "WordBlock Implant Controller"
	extended_desc = "Allows fine control over word inhibitor implants"
	program_icon_state = "generic"
	size = 8
	requires_ntnet = TRUE
	available_on_ntnet = TRUE
	tgui_id = "NtosImplantController"
	//program_icon = ""

	var/error

/datum/computer_file/program/wbcontroller/proc/getManagerByID(id)
	for(var/obj/item/organ/cyberimp/brain/wordblocker/W in GLOB.wordblockers)
		if(W.id == id)
			return W.get_manager()


/datum/computer_file/program/wbcontroller/ui_act(action, params)
	. = ..()
	if (.)
		return

	var/datum/wordfilter_manager/mgr = getManagerByID(params["mgrID"])
	var/filterIndex

	if(params["filterID"] != null)
		filterIndex = params["filterID"] + 1


	switch(action)
		if("PRG_setfiltered")
			var/newfilter = params["newFiltered"]
			mgr.word_filters[filterIndex].blocked_word = newfilter
			return TRUE
		if("PRG_setfilter") // what we replace with
			var/newfilter = params["newFilter"]
			mgr.word_filters[filterIndex].replace_phrase = newfilter
			return TRUE
		if("PRG_toggleactive")
			mgr.word_filters[filterIndex].active = !mgr.word_filters[filterIndex].active
			return TRUE
		if("PRG_togglereplace")
			mgr.word_filters[filterIndex].replace = !mgr.word_filters[filterIndex].replace
			return TRUE
		if("PRG_togglecasesens")
			mgr.word_filters[filterIndex].case_sensitive = !mgr.word_filters[filterIndex].case_sensitive
			return TRUE
		if("PRG_addfilter")
			var/filtered = params["filtered"]
			var/replacement = params["replacement"]
			var/active = params["active"]
			var/replace = params["replace"]
			var/case_sensitive = params["case_sensitive"]
			mgr.add_filter(filtered, replacement, case_sensitive, replace, active)

			return TRUE
		if("PRG_removefilter")
			var/datum/wordfilter/F = mgr.word_filters[filterIndex]
			if(F)
				mgr.word_filters.Remove(F)

			return TRUE
		if("PRG_movefilter")
			var/direction = params["direction"]
			switch(direction)
				if("up")
					if(filterIndex == 0)
						return FALSE
					mgr.word_filters.Swap(filterIndex, filterIndex-1)
				if("down")
					if(filterIndex == mgr.word_filters.len)
						return FALSE
					mgr.word_filters.Swap(filterIndex, filterIndex+1)
			return TRUE

/datum/computer_file/program/wbcontroller/ui_data(mob/user)
	var/list/data = get_header_data()

	if(error)
		data["error"] = error
	else
		var/list/managers = list()
		for(var/obj/item/organ/cyberimp/brain/wordblocker/W in GLOB.wordblockers)
			if(!W || !W.mgr)
				continue
			var/datum/wordfilter_manager/M = W.mgr
			if(!M.visible)
				continue

			var/list/filters = list()
			for(var/datum/wordfilter/F in M.word_filters)
				filters += list(list(
					"filtered_word" = F.blocked_word,
					"replacement_word" = F.replace_phrase,
					"case_sensitive" = F.case_sensitive,
					"replace" = F.replace,
					"active" = F.active
				))

			managers += list(list(
				"id" = W.id,
				"filters" = filters
			))
		data["managers"] = managers

	return data

