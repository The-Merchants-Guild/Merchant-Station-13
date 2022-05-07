GLOBAL_LIST_EMPTY(wordblockers)

/obj/item/organ/cyberimp/brain/wordblocker
	name = "speech filtration implant"
	desc = "Originally made for prison use, this gruesome implant interfaces directly with the brain's speech centers, both allowing control over what the victim can say and bypassing need for a cyberlink."
	icon_state = "brain_implant"
	slot = ORGAN_SLOT_BRAIN_LANGUAGEINHIBITOR
	encode_info = AUGMENT_NO_REQ

	var/id = 0
	var/static/wordblock_uid = 0
	var/locked = FALSE // write protection (for idk admin shenanigans)

	var/datum/wordfilter_manager/mgr = null

/obj/item/organ/cyberimp/brain/wordblocker/New()
	id = wordblock_uid + 1
	wordblock_uid = id
	mgr = new(id, src)

	GLOB.wordblockers.Add(src)
	..()

/obj/item/organ/cyberimp/brain/wordblocker/Insert(mob/living/carbon/owner, special)
	..()
	RegisterSignal(owner, COMSIG_MOB_SAY, .proc/handle_speech)

/obj/item/organ/cyberimp/brain/wordblocker/Remove(mob/living/carbon/organ_owner, special)
	UnregisterSignal(owner, COMSIG_MOB_SAY)
	..()

/obj/item/organ/cyberimp/brain/wordblocker/ComponentInitialize()
	. = ..()
	// We do not want our encode_info scrambled
	AddElement(/datum/element/empprotection, EMP_PROTECT_SELF)

/obj/item/organ/cyberimp/brain/wordblocker/Del()
	GLOB.wordblockers.Remove(src)
	UnregisterSignal(owner, COMSIG_MOB_SAY)
	..()

/obj/item/organ/cyberimp/brain/wordblocker/proc/get_manager()
	if(!mgr)
		mgr = new(id, src)
	return mgr

/obj/item/organ/cyberimp/brain/wordblocker/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER

	if(!mgr)
		return

	var/newmsg = mgr.process_message(speech_args[SPEECH_MESSAGE])
	if(owner && (!newmsg || newmsg == FALSE || newmsg == ""))
		to_chat(owner, span_warning("An implant prevents you from speaking!"))
		speech_args[SPEECH_MESSAGE] = ""
		return
	speech_args[SPEECH_MESSAGE] = newmsg



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
		to_chat(user, "<span class='notice'>You try to reconfigure [src], but your [I] phases straight through it. You should probably notify a coder. </span>")
		return
	if(locked)
		to_chat(user, "<span class='notice'>You try to reconfigure [src], only to find it's remote access switch glued in the [mgr.visible ? "ON" : "OFF"] position.</span>")
		return
	mgr.visible = !mgr.visible
	to_chat(user, "<span class='notice'>You reconfigure [src] to [mgr.visible ? "" : "not"] allow remote access.</span>")

/datum/wordfilter
	var/blocked_word = "lgbt"
	var/replace_phrase = "lg tv+"

	var/case_sensitive = FALSE
	var/replace = TRUE // replace or block?
	var/active = TRUE

/datum/wordfilter/New(block, replace_msg, casesensitive = FALSE, replacetxt = TRUE, on = TRUE)
	blocked_word = block
	replace_phrase = replace_msg
	case_sensitive = casesensitive
	replace = replacetxt
	active = on

/datum/wordfilter/proc/process_message(message)
	if(!active)
		return message // don't process the string
	var/regex/r = new(blocked_word, (case_sensitive ? "gm" : "gmi"))
	// regex can be replaced with replacetext() if it gets abused or something
	var/t = message
	if(replace)
		t = r.Replace(message, replace_phrase)
	else
		var/find = r.Find(message)
		if(find != 0 && (find+1) < length(message)) // block "lean" = "I love lean, you should too" -> "i love l-"
			t = splicetext(t, find+1, 0, "-")

	if(uppertext(message) == message) // I AM YELLING CAN YOU HEAR ME
		t = uppertext(t)

	return t


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

/datum/wordfilter_manager/proc/process_message(message)
	. = message
	// going over it like this to make sure it
	// applies the "topmost" filter first
	var/mob/living/carbon/impowner = implant.owner

	for(var/i = 1; i <= word_filters.len, i++)
		var/datum/wordfilter/w = word_filters[i]
		var/before_message = message
		message = w.process_message(message)
		if(impowner)
			if(w.replace == FALSE)
				impowner.log_talk("Message blocked by [implant] \[ID: [id]\]: [w.blocked_word] -> (!BLOCK!) | message: [before_message] -> '[message]'", LOG_WORDFILTER)
			if(message != before_message) // don't log no changes
				impowner.log_talk("Message modified by [implant] \[ID: [id]\]: [w.blocked_word] -> [w.replace_phrase] | message: '[before_message]' -> '[message]'", LOG_WORDFILTER)

	return message

/obj/item/organ/cyberimp/brain/wordblocker/nword
	name = "N Word Inhibitor Implant"
	desc = "DOKTOR! TURN OFF MY N WORD INHIBITOR!"
	locked = TRUE

/obj/item/organ/cyberimp/brain/wordblocker/nword/New()
	..()
	mgr.visible = FALSE
	mgr.add_filter(@"n+\s*i+\s*g+\s*g+\s*e+\s*r+", "Crime statistically misrepresented Person(s)", FALSE, FALSE, TRUE)

/obj/item/autosurgeon/organ/nword
	starting_organ = /obj/item/organ/cyberimp/brain/wordblocker/nword
	uses = 1
