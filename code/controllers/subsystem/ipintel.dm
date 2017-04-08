GLOBAL_REAL(SSipintel, /datum/controller/subsystem/ipintel)

/datum/controller/subsystem/ipintel
	name = "XKeyScore"
	init_order = -10
	flags = SS_NO_FIRE
	var/enabled = 0 //disable at round start to avoid checking reconnects
	var/throttle = 0
	var/errors = 0

	var/list/cache = list()

/datum/controller/subsystem/ipintel/New()
	NEW_SS_GLOBAL(SSipintel)

/datum/controller/subsystem/ipintel/Initialize(timeofday, zlevel)
	enabled = 1
	. = ..()

