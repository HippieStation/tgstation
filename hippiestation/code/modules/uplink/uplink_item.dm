/* Stimpak */
/datum/uplink_item/stealthy_tools/stimpack
	name = "Syndicate Nano-Booster"
	desc = "Also known as the 'Call of Duty' this powerful cluster of medical nanites effectively heals all damage \
	over time. If you are injured simply get to cover and wait a while and your wounds will vanish before your eyes. \
	It's duration is roughly five minutes."
	item = /obj/item/weapon/reagent_containers/syringe/nanoboost
	cost = 5
	surplus = 90

/datum/uplink_item/implants/adrenal
	name = "Combat Stimulant Implant"
	desc = "An implant injected into the body, and later activated at the user's will. It will inject a chemical \
			cocktail which has a very potent healing effect."
	item = /obj/item/weapon/storage/box/syndie_kit/imp_comstimms
	cost = 8
	player_minimum = 0 //Healing like this, while strong as heck, isn't going to help you murderbone like antistuns can.

/* Botany */
/datum/uplink_item/role_restricted/lawnmower
	name = "Gas powered lawn mower"
	desc = "A lawn mower is a machine utilizing one or more revolving blades to cut a grass surface to an even height, or bodies if that's your thing"
	restricted_roles = list("Botanist")
	cost = 14
	item = /obj/vehicle/lawnmower/emagged
/* Science */
/datum/uplink_item/role_restricted/experimental_teleporter
	name = "Experimental Teleporter"
	desc = "An imperfect bluespace teleportation device recovered from an abandoned mine that relocates the user 3 to 5 metres in their direction. The teleportation will telefrag any living creature in the new location. Relocating into solid walls will yield less than stellar results."
	restricted_roles = list("Research Director")
	cost = 14
	item = /obj/item/device/experimental_teleporter
	cant_discount = TRUE	
	
/* Glock */
/datum/uplink_item/dangerous/g17
	name = "Glock 17 Handgun"
	desc = "A simple yet popular handgun chambered in 9mm. Made out of strong but lightweight polymer. The standard magazine can hold up to 14 9mm cartridges. Compatible with a universal suppressor."
	item = /obj/item/weapon/gun/ballistic/automatic/pistol/g17
	cost = 10
	surplus = 15

/datum/uplink_item/ammo/g17
	name = "9mm Handgun Magazine"
	desc = "An additional 14-round 9mm magazine; compatible with the Glock 17 pistol."
	item = /obj/item/ammo_box/magazine/g17
	cost = 1

/* Sports */
/datum/uplink_item/badass/sports
	name = "Sports bundle"
	desc = "A hand-selected box of paraphernalia from one of the best sports. \
			Currently available are hockey, wrestling, and bowling kits."
	item = /obj/item/weapon/paper
	cost = 20
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/gang)
	cant_discount = TRUE

/datum/uplink_item/badass/sports/spawn_item(turf/loc, obj/item/device/uplink/U)
	var/list/possible_items = list(
								"/obj/item/weapon/storage/box/syndie_kit/wrestling",
								"/obj/item/weapon/storage/box/syndie_kit/bowling",
								"/obj/item/weapon/storage/box/syndie_kit/hockey"
								)
	if(possible_items.len)
		var/obj/item/I = pick(possible_items)
		return new I(loc)

/datum/uplink_item/nukeoffer/blastco
	name = "Unlock the BlastCo(tm) Armory"
	desc = "Enough gear to fully equip a team with explosive based weaponry."
	item = /obj/item/weapon/paper
	cost = 200

/datum/uplink_item/nukeoffer/blastco/spawn_item(turf/loc, obj/item/device/uplink/U)
	LAZYINITLIST(blastco_doors)
	if(LAZYLEN(blastco_doors))
		for(var/V in blastco_doors)
			var/obj/machinery/door/poddoor/shutters/blastco/X = V
			X.open()
		loc.visible_message("<span class='notice'>The Armory has been unlocked successfully!</span>")
	else
		loc.visible_message("<span class='warning'>The purchase was unsuccessful, and spent telecrystals have been refunded.</span>")
		U.telecrystals += cost //So the admins don't have to refund you
	return
