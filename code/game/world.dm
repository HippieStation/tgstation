#define PR_ANNOUNCEMENTS_PER_ROUND 5 //The number of unique PR announcements allowed per round
									//This makes sure that a single person can only spam 3 reopens and 3 closes before being ignored

GLOBAL_VAR(security_mode)
GLOBAL_PROTECT(security_mode)

/world/New()
	log_world("World loaded at [time_stamp()]")

	SetupExternalRSC()

	GLOB.config_error_log = GLOB.world_pda_log = GLOB.sql_error_log = GLOB.world_href_log = GLOB.world_runtime_log = GLOB.world_attack_log = GLOB.world_game_log = file("data/logs/config_error.log") //temporary file used to record errors with loading config, moved to log directory once logging is set bl

	CheckSecurityMode()

	make_datum_references_lists()	//initialises global lists for referencing frequently used datums (so that we only ever do it once)

	new /datum/controller/configuration

	hippie_initialize()
	CheckSchemaVersion()
	SetRoundID()

	SetupLogs()

	SERVER_TOOLS_ON_NEW

	load_motd()
	load_admins()
	LoadVerbs(/datum/verbs/menu)
	if(CONFIG_GET(flag/usewhitelist))
		load_whitelist()
	LoadBans()

	GLOB.timezoneOffset = text2num(time2text(0,"hh")) * 36000

	Master.Initialize(10, FALSE)

<<<<<<< HEAD
=======
	if(CONFIG_GET(flag/irc_announce_new_game))
		IRCBroadcast("New round starting on [SSmapping.config.map_name]!")

>>>>>>> 4178c209f1... Configuration datum refactor (#30763)
/world/proc/SetupExternalRSC()
#if (PRELOAD_RSC == 0)
	external_rsc_urls = world.file2list("config/external_rsc_urls.txt","\n")
	var/i=1
	while(i<=external_rsc_urls.len)
		if(external_rsc_urls[i])
			i++
		else
			external_rsc_urls.Cut(i,i+1)
#endif

/world/proc/CheckSchemaVersion()
	if(CONFIG_GET(flag/sql_enabled))
		if(SSdbcore.Connect())
			log_world("Database connection established.")
			var/datum/DBQuery/query_db_version = SSdbcore.NewQuery("SELECT major, minor FROM [format_table_name("schema_revision")] ORDER BY date DESC LIMIT 1")
			query_db_version.Execute()
			if(query_db_version.NextRow())
				var/db_major = text2num(query_db_version.item[1])
				var/db_minor = text2num(query_db_version.item[2])
				if(db_major != DB_MAJOR_VERSION || db_minor != DB_MINOR_VERSION)
					var/which = "behind"
					if(db_major < DB_MAJOR_VERSION || db_minor < DB_MINOR_VERSION)
						which = "ahead of"
					message_admins("Database schema ([db_major].[db_minor]) is [which] the latest schema version ([DB_MAJOR_VERSION].[DB_MINOR_VERSION]), this may lead to undefined behaviour or errors")
					log_sql("Database schema ([db_major].[db_minor]) is [which] the latest schema version ([DB_MAJOR_VERSION].[DB_MINOR_VERSION]), this may lead to undefined behaviour or errors")
			else
				message_admins("Could not get schema version from database")
		else
			log_world("Your server failed to establish a connection with the database.")

/world/proc/SetRoundID()
	if(CONFIG_GET(flag/sql_enabled))
		if(SSdbcore.Connect())
			var/datum/DBQuery/query_round_start = SSdbcore.NewQuery("INSERT INTO [format_table_name("round")] (start_datetime, server_ip, server_port) VALUES (Now(), INET_ATON(IF('[config.internet_address_to_use]' LIKE '', '0', '[config.internet_address_to_use]')), '[world.port]')")
			query_round_start.Execute()
			var/datum/DBQuery/query_round_last_id = SSdbcore.NewQuery("SELECT LAST_INSERT_ID()")
			query_round_last_id.Execute()
			if(query_round_last_id.NextRow())
				GLOB.round_id = query_round_last_id.item[1]

/world/proc/SetupLogs()
	GLOB.log_directory = "data/logs/[time2text(world.realtime, "YYYY/MM/DD")]/round-"
	if(GLOB.round_id)
		GLOB.log_directory += "[GLOB.round_id]"
	else
		GLOB.log_directory += "[replacetext(time_stamp(), ":", ".")]"
	GLOB.world_game_log = file("[GLOB.log_directory]/game.log")
	GLOB.world_attack_log = file("[GLOB.log_directory]/attack.log")
	GLOB.world_runtime_log = file("[GLOB.log_directory]/runtime.log")
	GLOB.world_qdel_log = file("[GLOB.log_directory]/qdel.log")
	GLOB.world_href_log = file("[GLOB.log_directory]/hrefs.html")
	GLOB.world_pda_log = file("[GLOB.log_directory]/pda.log")
	GLOB.sql_error_log = file("[GLOB.log_directory]/sql.log")
	WRITE_FILE(GLOB.world_game_log, "\n\nStarting up round ID [GLOB.round_id]. [time_stamp()]\n---------------------")
	WRITE_FILE(GLOB.world_attack_log, "\n\nStarting up round ID [GLOB.round_id]. [time_stamp()]\n---------------------")
	WRITE_FILE(GLOB.world_runtime_log, "\n\nStarting up round ID [GLOB.round_id]. [time_stamp()]\n---------------------")
	WRITE_FILE(GLOB.world_pda_log, "\n\nStarting up round ID [GLOB.round_id]. [time_stamp()]\n---------------------")
	GLOB.changelog_hash = md5('html/changelog.html')					//used for telling if the changelog has changed recently
	if(fexists(GLOB.config_error_log))
		fcopy(GLOB.config_error_log, "[GLOB.log_directory]/config_error.log")
		fdel(GLOB.config_error_log)

	if(GLOB.round_id)
		log_game("Round ID: [GLOB.round_id]")

/world/proc/CheckSecurityMode()
	//try to write to data
	if(!text2file("The world is running at least safe mode", "data/server_security_check.lock"))
		GLOB.security_mode = SECURITY_ULTRASAFE
		warning("/tg/station 13 is not supported in ultrasafe security mode. Everything will break!")
		return

	//try to shell
	if(shell("echo \"The world is running in trusted mode\"") != null)
		GLOB.security_mode = SECURITY_TRUSTED
	else
		GLOB.security_mode = SECURITY_SAFE
		warning("/tg/station 13 uses many file operations, a few shell()s, and some external call()s. Trusted mode is recommended. You can download our source code for your own browsing and compilation at https://github.com/tgstation/tgstation")

/world/Topic(T, addr, master, key)
	var/list/input = params2list(T)

	var/pinging = ("ping" in input)
	var/playing = ("players" in input)

	if(!pinging && !playing && config && CONFIG_GET(flag/log_world_topic))
		WRITE_FILE(GLOB.world_game_log, "TOPIC: \"[T]\", from:[addr], master:[master], key:[key]")

<<<<<<< HEAD
	SERVER_TOOLS_ON_TOPIC
	var/key_valid = (global.comms_allowed && input["key"] == global.comms_key)
=======
	if(input[SERVICE_CMD_PARAM_KEY])
		return ServiceCommand(input)
	var/comms_key = CONFIG_GET(string/comms_key)
	var/key_valid = (comms_key && input["key"] == comms_key)
>>>>>>> 4178c209f1... Configuration datum refactor (#30763)

	if(pinging)
		var/x = 1
		for (var/client/C in GLOB.clients)
			x++
		return x

	else if(playing)
		var/n = 0
		for(var/mob/M in GLOB.player_list)
			if(M.client)
				n++
		return n

	else if("status" in input)
		var/list/s = list()
		s["version"] = GLOB.game_version
		s["mode"] = GLOB.master_mode
		s["respawn"] = config ? !CONFIG_GET(flag/norespawn) : FALSE
		s["enter"] = GLOB.enter_allowed
		s["vote"] = CONFIG_GET(flag/allow_vote_mode)
		s["ai"] = CONFIG_GET(flag/allow_ai)
		s["host"] = host ? host : null
		s["active_players"] = get_active_player_count()
		s["players"] = GLOB.clients.len
		s["revision"] = GLOB.revdata.commit
		s["revision_date"] = GLOB.revdata.date

		var/list/adm = get_admin_counts()
		var/list/presentmins = adm["present"]
		var/list/afkmins = adm["afk"]
		s["admins"] = presentmins.len + afkmins.len //equivalent to the info gotten from adminwho
		s["gamestate"] = SSticker.current_state

		s["map_name"] = SSmapping.config.map_name

		if(key_valid && SSticker.HasRoundStarted())
			s["real_mode"] = SSticker.mode.name
			// Key-authed callers may know the truth behind the "secret"

		s["security_level"] = get_security_level()
		s["round_duration"] = SSticker ? round((world.time-SSticker.round_start_time)/10) : 0
		// Amount of world's ticks in seconds, useful for calculating round duration

		if(SSshuttle && SSshuttle.emergency)
			s["shuttle_mode"] = SSshuttle.emergency.mode
			// Shuttle status, see /__DEFINES/stat.dm
			s["shuttle_timer"] = SSshuttle.emergency.timeLeft()
			// Shuttle timer, in seconds

		return list2params(s)

	else if("announce" in input)
		if(!key_valid)
			return "Bad Key"
		else
			AnnouncePR(input["announce"], json_decode(input["payload"]))

	else if("crossmessage" in input)
		if(!key_valid)
			return
		else
			if(input["crossmessage"] == "Ahelp")
				relay_msg_admins("<span class='adminnotice'><b><font color=red>HELP: </font> [input["source"]] [input["message_sender"]]: [input["message"]]</b></span>")
			if(input["crossmessage"] == "Comms_Console")
				minor_announce(input["message"], "Incoming message from [input["message_sender"]]")
				for(var/obj/machinery/computer/communications/CM in GLOB.machines)
					CM.overrideCooldown()
			if(input["crossmessage"] == "News_Report")
				minor_announce(input["message"], "Breaking Update From [input["message_sender"]]")

	else if("server_hop" in input)
		show_server_hop_transfer_screen(input["server_hop"])

/world/proc/AnnouncePR(announcement, list/payload)
	var/static/list/PRcounts = list()	//PR id -> number of times announced this round
	var/id = "[payload["pull_request"]["id"]]"
	if(!PRcounts[id])
		PRcounts[id] = 1
	else
		++PRcounts[id]
		if(PRcounts[id] > PR_ANNOUNCEMENTS_PER_ROUND)
			return

	var/final_composed = "<span class='announce'>PR: [announcement]</span>"
	for(var/client/C in GLOB.clients)
		C.AnnouncePR(final_composed)

/world/Reboot(reason = 0, fast_track = FALSE)
	ServiceReboot() //handles alternative actions if necessary
	if (reason || fast_track) //special reboot, do none of the normal stuff
		if (usr)
			log_admin("[key_name(usr)] Has requested an immediate world restart via client side debugging tools")
			message_admins("[key_name_admin(usr)] Has requested an immediate world restart via client side debugging tools")
		to_chat(world, "<span class='boldannounce'>Rebooting World immediately due to host request</span>")
	else
		to_chat(world, "<span class='boldannounce'>Rebooting world...</span>")
		Master.Shutdown()	//run SS shutdowns
	log_world("World rebooted at [time_stamp()]")
	..()

/world/proc/load_motd()
	GLOB.join_motd = file2text("config/motd.txt") + "<br>" + GLOB.revdata.GetTestMergeInfo()

/world/proc/update_status()
<<<<<<< HEAD
	var/s = ""

	if (config && config.server_name)
		s += "<b>[config.server_name]</b> &#8212; "

	s += "<big><b>[station_name()]</b></big>";

	if (!host && config && config.hostedby)
		s += "<br>Hosted by <b>[config.hostedby]</b>."
	s += "<img src=\"http://i.imgur.com/xH6DuHE.jpg\">" //Banner image
	s += "<br>("
	s += "<a href=\"[config.forumurl]\">"
	s += "Forums"
	s += "</a>"
	s += ")"
	s += " ("
	s += "<a href=\"[config.githuburl]\">"
	s += "Github"
	s += "</a>"
	s += ") "
	if(SSticker)
		if(GLOB.master_mode)
			s += GLOB.master_mode
	else
		s += "<b>STARTING</b>"
=======

	var/list/features = list()

	if(GLOB.master_mode)
		features += GLOB.master_mode

	if (!GLOB.enter_allowed)
		features += "closed"

	var/s = ""
	var/hostedby
	if(config)
		var/server_name = CONFIG_GET(string/servername)
		if (server_name)
			s += "<b>[server_name]</b> &#8212; "
		features += "[CONFIG_GET(flag/norespawn) ? "no " : ""]respawn"
		if(CONFIG_GET(flag/allow_vote_mode))
			features += "vote"
		if(CONFIG_GET(flag/allow_ai))
			features += "AI allowed"
		hostedby = CONFIG_GET(string/hostedby)

	s += "<b>[station_name()]</b>";
	s += " ("
	s += "<a href=\"http://\">" //Change this to wherever you want the hub to link to.
	s += "Default"  //Replace this with something else. Or ever better, delete it and uncomment the game version.
	s += "</a>"
	s += ")"

	var/n = 0
	for (var/mob/M in GLOB.player_list)
		if (M.client)
			n++

	if (n > 1)
		features += "~[n] players"
	else if (n > 0)
		features += "~[n] player"

	if (!host && hostedby)
		features += "hosted by <b>[hostedby]</b>"

	if (features)
		s += ": [jointext(features, ", ")]"
>>>>>>> 4178c209f1... Configuration datum refactor (#30763)

	status = s

/world/proc/update_hub_visibility(new_visibility)
	if(new_visibility == GLOB.hub_visibility)
		return
	GLOB.hub_visibility = new_visibility
	if(GLOB.hub_visibility)
		hub_password = "kMZy3U5jJHSiBQjr"
	else
		hub_password = "SORRYNOPASSWORD"
