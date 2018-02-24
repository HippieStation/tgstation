/obj/item/storage/box/syndie_kit/hockey
	name = "\improper Ka-Nada Boxed S.S.F Hockey Set"
	desc = "The iconic extreme environment gear used by Ka-Nada special sport forces.\
	Used to devastating effect during the great northern sports wars of the second great athletic republic.\
	The unmistakeable grey and red gear provides great protection from most if not all environmental hazards\
	and combat threats in addition to coming with the signature weapon of the Ka-Nada SSF and all terrain Hyper-Blades\
	for enhanced mobility and lethality in melee combat. This power comes at a cost as your Ka-Nada benefactors expect\
	absolute devotion to the cause, once equipped you will be unable to remove the gear so be sure to make it count."

/obj/item/storage/box/syndie_kit/hockey/PopulateContents()
	new /obj/item/hockeypack(src)
	new /obj/item/storage/belt/hippie/hockey(src)
	new /obj/item/clothing/suit/hippie/hockey(src)
	new /obj/item/clothing/shoes/hippie/hockey(src)
	new /obj/item/clothing/mask/hippie/hockey(src)
	new /obj/item/clothing/head/hippie/hockey(src)

/obj/item/storage/box/syndie_kit/bowling
	name = "\improper Right-Up-Your-Alley bowling kit"
	desc = "Bowling is definitely a real sport. Anyone who says otherwise is stupid.\
			Suit up with the latest in bowling fashion, and prepare to show off your skills.\
			Syndicate nanobots embedded in the bowling uniform will make you a real Mister 300,\
			with no training required."

/obj/item/storage/box/syndie_kit/bowling/PopulateContents()
	new /obj/item/clothing/shoes/hippie/bowling(src)
	new /obj/item/clothing/under/hippie/bowling(src)
	new /obj/item/bowling(src)
	new /obj/item/bowling(src)
	new /obj/item/bowling(src)

/obj/item/storage/box/syndie_kit/imp_mindslave
	name = "Mindslave Implant (with injector)"

/obj/item/storage/box/syndie_kit/imp_mindslave/PopulateContents()
	new /obj/item/implanter/mindslave(src)

/obj/item/storage/box/syndie_kit/imp_gmindslave
	name = "Greater Mindslave Implant (with injector)"

/obj/item/storage/box/syndie_kit/imp_gmindslave/PopulateContents()
	new /obj/item/implanter/mindslave/greater(src)

/obj/item/storage/box/syndie_kit/wrestling
	name = "\improper Squared-Circle smackdown set"
	desc = "For millenia, man has dreamed of wrestling. In 1980, it was invented by the great Macho\
	Man Randy Savage. Although he is no longer with us, you can live on in his name with the latest in\
	wrestling technology. Corkscrew your enemies and smash them into a pulp with your newfound wrestling skills,\
	which you will obtain from this set. Now with a complimentary space-wrestling gear!"

/obj/item/storage/box/syndie_kit/wrestling/PopulateContents()
	new /obj/item/clothing/mask/hippie/wrestling(src)
	new /obj/item/clothing/glasses/hippie/wrestling(src)
	new /obj/item/clothing/under/hippie/wrestling(src)
	new /obj/item/storage/belt/champion/wrestling(src)

/obj/item/storage/box/syndie_kit/imp_comstimms
	name = "boxed combat stimulant implant (with injector)"

/obj/item/storage/box/syndie_kit/imp_comstimms/PopulateContents()
	var/obj/item/implanter/O = new(src)
	O.imp = new /obj/item/implant/comstimms(O)
	O.update_icon()

/obj/item/storage/box/syndie_kit/firesuit
	name = "\improper Boxed Syndicate Firesuit set"
	desc = "Contains one Syndicate firesuit and one Syndicate firefighting helmet. The box radiates warmth."

/obj/item/storage/box/syndie_kit/firesuit/PopulateContents()
	new /obj/item/clothing/suit/fire/atmos/syndicate(src)
	new /obj/item/clothing/head/hardhat/atmos/syndicate(src)

/obj/item/storage/box/syndicate/proc/columbineKit()
	new /obj/item/ammo_box/buckshotbox(src)
	new /obj/item/gun/ballistic/automatic/pistol/g17(src)
	new /obj/item/storage/box/syndie_kit/imp_gmindslave(src)
	for(var/duplicate in 1 to 2)
		new /obj/item/clothing/suit/jacket/leather/overcoat(src)
		new /obj/item/clothing/mask/bandana/black(src)
		new /obj/item/storage/belt/bandolier(src)
		new /obj/item/clothing/shoes/combat(src)
		new /obj/item/clothing/gloves/fingerless(src)
	var/ericBag = new /obj/item/storage/backpack/duffelbag(src)
	new /obj/item/switchblade(ericBag)
	new /obj/item/melee/baton/cattleprod(ericBag)
	new /obj/item/grenade/plastic/x4(ericBag)
	new /obj/item/melee/baton/cattleprod(ericBag)
	new /obj/item/melee/baseball_bat/spike(ericBag)
	new /obj/item/stock_parts/cell/upgraded(ericBag)
	new /obj/item/gun/ballistic/revolver/doublebarrel/improvised(ericBag)
	for(var/duplicateIED in 1 to 5)
		new /obj/item/grenade/iedcasing(ericBag)
	for(var/duplicateC4 in 1 to 2)
		new /obj/item/grenade/plastic(ericBag)
	for(var/duplicateConcussion in 1 to 2)
		new /obj/item/grenade/syndieminibomb/concussion(ericBag)
	var/dylanBag = new /obj/item/storage/backpack/duffelbag(src)
	new /obj/item/melee/baseball_bat/spike(dylanBag)
	new /obj/item/switchblade(dylanBag)
	new /obj/item/grenade/plastic/x4(dylanBag)
	new /obj/item/melee/baton/cattleprod(dylanBag)
	new /obj/item/stock_parts/cell/upgraded(dylanBag)
	for(var/duplicateIED in 1 to 5)
		new /obj/item/grenade/iedcasing(dylanBag)
	for(var/duplicateC4 in 1 to 2)
		new /obj/item/grenade/plastic(dylanBag)
	for(var/duplicateConcussion in 1 to 2)
		new /obj/item/grenade/syndieminibomb/concussion(dylanBag)

/obj/item/storage/box/syndie_kit/armstrong
	name = "\improper Brad Armstrong Family Style Karate Kit"
	desc = "A kit with the necessary tools to become the best karate master on the planet!\
	Contains a paper letting you know how to fight. \
	The only cost is your right to not suck at parenting."

/obj/item/storage/box/syndie_kit/armstrong/PopulateContents()
	new /obj/item/armstrong_scroll(src)
	new /obj/item/paper/armstrong_tutorial(src)