// will be moved to augments_internal.dm later. maybe.

GLOBAL_LIST_EMPTY(wordblockers)

/obj/item/organ/cyberimp/brain/wordblocker
	name = "word inhibitor implant"
	desc = "This implant allows you to stop the victim from saying certain words." // todo: better desc
	icon_state = "brain_implant"
	slot = ORGAN_SLOT_BRAIN_LANGUAGEINHIBITOR
	encode_info = AUGMENT_NO_REQ // dunno wtf this is seems nice

	var/id = 0
	var/static/wordblock_uid = 0

	var/datum/wordblocker_manager/mgr = null

/obj/item/organ/cyberimp/brain/wordblocker/New()
	id = wordblock_uid + 1
	wordblock_uid = id
	mgr = new(id)

	GLOB.wordblockers.Add(src)

	..()

/obj/item/organ/cyberimp/brain/wordblocker/Del()
	GLOB.wordblockers.Remove(src)
	..()

/obj/item/organ/cyberimp/brain/wordblocker/proc/get_manager()
	if(!mgr)
		mgr = new(id)

	return mgr

/obj/item/organ/cyberimp/brain/wordblocker/examine(mob/user)
	. = ..()
	. += "<span class='info'>A little screen reads: 'Implant Unique ID: [id]'</span>"
	if(mgr)
		. += "<span class='info'>The implant currently does [mgr.visible ? "" : "not"] allow remote access. Use a screwdriver to change this.>"

/obj/item/organ/cyberimp/brain/wordblocker/screwdriver_act(mob/living/user, obj/item/I)
	. = ..()
	if(.)
		return TRUE
	I.play_tool_sound(src)
	if(!mgr || mgr == null)
		to_chat(user, "<span class='notice'> You try to reconfigure [src], only to fail miserably. You should probably notify a coder. </span>")
		return
	// feels hacky idk
	mgr.visible = !mgr.visible
	to_chat(user, "<span class='notice'>You reconfigure [src] to [mgr.visible ? "" : "not"] allow remote access.")

/datum/wordblocker
	var/blocked_word = "lgbt"
	var/replace_phrase = "lg tv+"

	var/case_sensitive = FALSE
	var/active = TRUE // might want to disable but keep the thing to
	var/replace = TRUE

// looks ugly but eh
/datum/wordblocker/New(block, replace_msg, casesensitive = FALSE, replacetxt = TRUE, on = TRUE)
	blocked_word = block
	replace_phrase = replace_msg
	case_sensitive = casesensitive
	replace = replacetxt
	active = on

/datum/wordblocker/proc/process_msg(message)
	. = message
	if(!active)
		return message // don't process the string
	var/regex/r = new(blocked_word, (case_sensitive ? "gm" : "gmi"))

	if(replace)
		var/t = r.Replace(message, replace_phrase)
		if(uppertext(message) == message) // I AM YELLING CAN YOU HEAR ME
			t = uppertext(t)
		return t
	else
		var/found = r.Find(message)
		if(found)
			return FALSE

/datum/wordblocker_manager
	var/id = null
	var/visible = TRUE
	var/list/datum/wordblocker/word_filters = list()

/datum/wordblocker_manager/New(mgrid)
	id = mgrid
	var/datum/wordblocker/wb = new("cbt", "cock and ball torture from wikipedia the free encyclopedia at EN dot WIKIPEDIA dot ORG")
	word_filters.Add(wb)

/datum/wordblocker_manager/proc/add_filter(block, replace, casesensitive = FALSE, replacetxt = TRUE, on = TRUE)
	var/datum/wordblocker/wb = new(block, replace, casesensitive, replacetxt, on)
	word_filters.Add(wb)

/datum/wordblocker_manager/proc/process_msg(message)
	//var/original_message = message
	// going over it like this to make sure it applies
	// the "topmost" filter first
	for(var/i = 1; i <= word_filters.len, i++) // why are byond lists 1-indexed why
		var/datum/wordblocker/w = word_filters[i]
		message = w.process_msg(message)
		if(message == FALSE)
			return FALSE
	return message

/obj/item/organ/cyberimp/brain/wordblocker/nwordinhibitor
	name = "N Word Inhibitor Implant"
	desc = "DOKTOR! TURN OFF MY N WORD INHIBITOR!"

/obj/item/organ/cyberimp/brain/wordblocker/nwordinhibitor/New()
	..()
	mgr.add_filter("nigger", "cock and ball torture", FALSE, FALSE, TRUE)

/obj/item/autosurgeon/organ/nwordinhibitor
	starting_organ = /obj/item/organ/cyberimp/brain/wordblocker/nwordinhibitor
	uses = 1
