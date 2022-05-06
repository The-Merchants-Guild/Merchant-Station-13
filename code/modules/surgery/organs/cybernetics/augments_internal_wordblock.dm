GLOBAL_LIST_EMPTY(wordblockers)

/obj/item/organ/cyberimp/brain/wordblocker
	name = "speech filtration implant"
	desc = "Originally made for prison use, this gruesome implant interfaces directly with the brain's speech centers, both allowing control over what the victim can say AND bypassing need for a cyberlink."
	icon_state = "brain_implant"
	slot = ORGAN_SLOT_BRAIN_LANGUAGEINHIBITOR
	encode_info = AUGMENT_NO_REQ

	var/id = 0
	var/static/wordblock_uid = 0

	var/datum/wordfilter_manager/mgr = null

/obj/item/organ/cyberimp/brain/wordblocker/New()
	id = wordblock_uid + 1
	wordblock_uid = id
	mgr = new(id, src)

	GLOB.wordblockers.Add(src)
	..()

/obj/item/organ/cyberimp/brain/wordblocker/ComponentInitialize()
	. = ..()
	// We do not want our encode_info scrambled
	AddElement(/datum/element/empprotection, EMP_PROTECT_SELF)

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
		. += "<span class='info'>The implant currently does [mgr.visible ? "" : "not"] allow remote access. Use a screwdriver to change this.</span>"

/obj/item/organ/cyberimp/brain/wordblocker/screwdriver_act(mob/living/user, obj/item/I)
	. = ..()
	if(.)
		return TRUE
	I.play_tool_sound(src)
	if(!mgr || mgr == null)
		to_chat(user, "<span class='notice'>You try to reconfigure [src], but the screwdriver phases straight through it. You should probably notify a coder. </span>")
		return
	mgr.visible = !mgr.visible
	to_chat(user, "<span class='notice'>You reconfigure [src] to [mgr.visible ? "" : "not"] allow remote access.</span>")

/datum/wordfilter
	var/blocked_word = "lgbt"
	var/replace_phrase = "lg tv+"

	var/case_sensitive = FALSE
	var/active = TRUE // might want to disable but keep the thing to
	var/replace = TRUE

/datum/wordfilter/New(block, replace_msg, casesensitive = FALSE, replacetxt = TRUE, on = TRUE)
	blocked_word = block
	replace_phrase = replace_msg
	case_sensitive = casesensitive
	replace = replacetxt
	active = on

/datum/wordfilter/proc/process_msg(message)
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

/datum/wordfilter_manager
	var/id = null
	var/visible = TRUE
	var/list/datum/wordfilter/word_filters = list()
	var/obj/item/organ/cyberimp/brain/wordblocker/implant = null

/datum/wordfilter_manager/New(mgrid, imp)
	id = mgrid
	implant = imp
	if(!imp)
		WARNING("[src] created with no implant! This will cause issues.")
		// issues include: runtime when logging message


/datum/wordfilter_manager/proc/add_filter(block, replace, casesensitive = FALSE, replacetxt = TRUE, on = TRUE)
	var/datum/wordfilter/wb = new(block, replace, casesensitive, replacetxt, on)
	word_filters.Add(wb)

/datum/wordfilter_manager/proc/process_msg(message)
	. = message
	// going over it like this to make sure it applies
	// the "topmost" filter first
	for(var/i = 1; i <= word_filters.len, i++) // why are byond lists 1-indexed why
		var/datum/wordfilter/w = word_filters[i]
		var/before_message = message
		message = w.process_msg(message)
		if(message == FALSE)
			implant.owner.log_talk("Message blocked by [implant] (ID: [id]): [w.blocked_word] -> (!BLOCK!) | message: [before_message]", LOG_WORDFILTER)
			return FALSE
		if(message != before_message) // don't log no changes
			implant.owner.log_talk("Message modified by [implant] (ID: [id]): [w.blocked_word] -> [w.replace_phrase] | message: '[before_message]' -> '[message]'", LOG_WORDFILTER)

	return message

/obj/item/organ/cyberimp/brain/wordblocker/nwordinhibitor
	name = "N Word Inhibitor Implant"
	desc = "DOKTOR! TURN OFF MY N WORD INHIBITOR!"

/obj/item/organ/cyberimp/brain/wordblocker/nwordinhibitor/New()
	..()
	mgr.add_filter(@"n+\s*i+\s*g+\s*g+\s*e+\s*r+", "Crime statistically misrepresented Person(s)", FALSE, FALSE, TRUE)

/obj/item/autosurgeon/organ/nwordinhibitor
	starting_organ = /obj/item/organ/cyberimp/brain/wordblocker/nwordinhibitor
	uses = 1
