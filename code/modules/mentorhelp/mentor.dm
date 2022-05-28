GLOBAL_LIST_EMPTY(mentor_datums)
GLOBAL_PROTECT(mentor_datums)

GLOBAL_VAR_INIT(mentor_href_token, GenerateToken())
GLOBAL_PROTECT(mentor_href_token)

/datum/mentors
	var/name = "someone's mentor datum"
	var/client/owner // the actual mentor, client type
	var/target // the mentor's ckey
	var/href_token // href token for mentor commands, uses the same token used by admins.
	var/mob/following

/datum/mentors/New(ckey)
	if(!ckey)
		QDEL_IN(src, 0)
		throw EXCEPTION("Mentor datum created without a ckey")
		return
	target = ckey(ckey)
	name = "[ckey]'s mentor datum"
	href_token = GenerateToken()
	GLOB.mentor_datums[target] = src
	//set the owner var and load commands
	owner = GLOB.directory[ckey]
	if(owner)
		owner.mentor_datum = src
		owner.add_mentor_verbs()
		GLOB.mentors += owner

/datum/mentors/proc/CheckMentorHREF(href, href_list)
	var/auth = href_list["mentor_token"]
	. = auth && (auth == href_token || auth == GLOB.mentor_href_token)
	if(.)
		return
	var/msg = !auth ? "no" : "a bad"
	message_admins("[key_name_admin(usr)] clicked an href with [msg] authorization key!")
	if(CONFIG_GET(flag/debug_admin_hrefs))
		message_admins("Debug mode enabled, call not blocked. Please ask your coders to review this round's logs.")
		log_world("UAH: [href]")
		return TRUE
	log_admin_private("[key_name(usr)] clicked an href with [msg] authorization key! [href]")

/proc/RawMentorHrefToken(forceGlobal = FALSE)
	var/tok = GLOB.mentor_href_token
	if(!forceGlobal && usr)
		var/client/C = usr.client
		to_chat(world, C)
		to_chat(world, usr)
		if(!C)
			CRASH("No client for HrefToken()!")
		var/datum/mentors/holder = C.mentor_datum
		if(holder)
			tok = holder.href_token
	return tok

/proc/MentorHrefToken(forceGlobal = FALSE)
	return "mentor_token=[RawMentorHrefToken(forceGlobal)]"

/proc/load_mentors()
	var/dbfail
	if(!CONFIG_GET(flag/mentor_legacy_system) && !SSdbcore.Connect())
		message_admins("Failed to connect to database while loading mentors. Loading from backup.")
		log_sql("Failed to connect to database while loading mentors. Loading from backup.")
		dbfail = 1
	//Clear the datums references
	GLOB.mentor_datums.Cut()
	for(var/client/C in GLOB.mentors)
		C.remove_mentor_verbs()
		C.mentor_datum = null
	GLOB.mentors.Cut()
	//ckeys listed in mentors.txt are always made mentors before sql loading is attempted
	var/mentors_text = file2text("[global.config.directory]/mentors.txt")
	var/regex/mentors_regex = new(@"^(?!#)(.+?)\s+=\s+(.+)", "gm")
	while(mentors_regex.Find(mentors_text))
		new /datum/mentors(mentors_regex.group[1])
	if(!CONFIG_GET(flag/mentor_legacy_system) || dbfail)
		var/datum/db_query/query_load_mentors = SSdbcore.NewQuery("SELECT `ckey` FROM [format_table_name("mentor")]")
		if(!query_load_mentors.Execute())
			message_admins("Error loading mentors from database. Loading from backup.")
			log_sql("Error loading mentors from database. Loading from backup.")
			dbfail = 1
		else
			while(query_load_mentors.NextRow())
				var/mentor_ckey = ckey(query_load_mentors.item[1])
				var/skip
				if(GLOB.mentor_datums[mentor_ckey])
					skip = 1
				if(!skip)
					new /datum/mentors(mentor_ckey)
		qdel(query_load_mentors)

	#ifdef TESTING
	var/msg = "Mentors Built:\n"
	for(var/ckey in GLOB.mentor_datums)
		var/datum/mentors/M = GLOB.mentor_datums[ckey]
		msg += "\t[ckey] - MENTOR\n"
	testing(msg)
	#endif

/datum/mentors/proc/disassociate()
	if(owner)
		GLOB.mentors -= owner
		owner.remove_mentor_verbs()
		owner.init_verbs()
		owner.mentor_datum=null
		owner.holder = null
		owner = null

