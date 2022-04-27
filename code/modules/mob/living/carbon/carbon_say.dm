/mob/living/carbon/proc/handle_tongueless_speech(mob/living/carbon/speaker, list/speech_args)
	SIGNAL_HANDLER

	var/message = speech_args[SPEECH_MESSAGE]
	var/static/regex/tongueless_lower = new("\[gdntke]+", "g")
	var/static/regex/tongueless_upper = new("\[GDNTKE]+", "g")
	if(message[1] != "*")
		message = tongueless_lower.Replace(message, pick("aa","oo","'"))
		message = tongueless_upper.Replace(message, pick("AA","OO","'"))
		speech_args[SPEECH_MESSAGE] = message

/mob/living/carbon/can_speak_vocal(message)
	if(silent)
		if(HAS_TRAIT(src, TRAIT_SIGN_LANG))
			return ..()
		else
			return FALSE
	return ..()

/mob/living/carbon/could_speak_language(datum/language/language)
	var/obj/item/organ/tongue/T = getorganslot(ORGAN_SLOT_TONGUE)
	if(T)
		return T.could_speak_language(language)
	else
		return initial(language.flags) & TONGUELESS_SPEECH

/mob/living/carbon/midflight_check(message)
	. = ..()
	var/obj/item/organ/cyberimp/brain/wordblocker/W = getorganslot(ORGAN_SLOT_BRAIN_LANGUAGEINHIBITOR)
	if(W)
		var/datum/wordblocker_manager/M = W.get_manager()
		var/postcheck = M.process_msg(message)
		return postcheck
