//Contender, made by ArcLumin.

/obj/item/gun/ballistic/shotgun/doublebarrel/contender
	desc = "The Contender G13, a favorite amongst space hunters. An easily modified bluespace barrel and break action loading means it can use any ammo available.\
	The side has an engraving which reads 'Made by ArcWorks'"
	name = "Contender G13"
	icon = 'hippiestation/icons/obj/guns/projectile.dmi'
	icon_state = "contender-s"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/contender
	weapon_weight = WEAPON_MEDIUM
	w_class = WEIGHT_CLASS_NORMAL
	materials = list(MAT_METAL=10000)
	obj_flags = UNIQUE_RENAME
	unique_reskin = 0

/obj/item/gun/ballistic/shotgun/doublebarrel/contender/sawoff(mob/user)
	to_chat(user, "<span class='warning'>Why would you mutilate this work of art?</span>")
	return

/obj/item/gun/ballistic/shotgun
	icon = 'hippiestation/icons/obj/guns/projectile.dmi'

/obj/item/gun/ballistic/shotgun/riot
	desc = "I used the shotgun. You know why? Cause the shot gun doesn't miss, and unlike the shitty hybrid taser it stops \
	a criminal in their tracks in two hits. Bang, bang, and they're fucking done. I use four shots just to make damn sure. \
	Because, once again, I'm not there to coddle a buncha criminal scum sucking faggots, I'm there to 1) Survive the fucking round. \
	2) Guard the armory. So you can absolutely get fucked. If I get unbanned, which I won't, you can guarantee I will continue to use \
	the shotgun to apprehend criminals. Because it's quick, clean and effective as fuck. Why in the seven hells would I fuck around \
	with the disabler shots, which take half a clip just to bring someone down, or with the tazer bolts which are slow as balls, \
	impossible to aim and do about next to jack shit, fuck all. The shotgun is the superior law enforcement weapon. Because it stops crime. \
	And it stops crime by reducing the number of criminals roaming the fucking halls."


/obj/item/gun/ballistic/shotgun/canegun
	name = "pimp stick"
	desc = "A gold-rimmed cane, with a gleaming diamond set at the top. Great for bashing in kneecaps."
	mag_type = /obj/item/ammo_box/magazine/internal/shot/canegun
	fire_sound_volume = 80
	icon = 'hippiestation/icons/obj/items_and_weapons.dmi'
	icon_state = "pimpstick"
	item_state = "pimpstick"
	lefthand_file = 'hippiestation/icons/mob/inhands/lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/righthand.dmi'
	force = 15
	throwforce = 7
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb = list("pimped", "smacked", "disciplined", "busted", "capped", "decked")
	resistance_flags = FIRE_PROOF
	tac_reloads = FALSE
	rack_sound_volume = 0
	semi_auto = TRUE
	bolt_type = BOLT_TYPE_NO_BOLT

var/mob/current_owner

/obj/item/gun/ballistic/shotgun/canegun/equipped(mob/user, slot)
	slot = SLOT_HANDS
	var/mob/holder = get(loc, /mob)
	var/mob/living/carbon/human/H = user
	if(!current_owner && holder)
		current_owner = holder
		if(istype(H))
			if(H.get_num_legs(1) < 2)
				H.add_movespeed_modifier(type, update=TRUE, priority=100, multiplicative_slowdown=-3, blacklisted_movetypes=(FLYING|FLOATING))
	if(current_owner && current_owner != holder)
		H.remove_movespeed_modifier(type)
		current_owner = null

/obj/item/gun/ballistic/shotgun/canegun/sawoff(mob/user)
	to_chat(user, "<span class='warning'>Kinda defeats the purpose of a cane, doesn't it?</span>")
	return

/obj/item/pimpstick/suicide_act(mob/user)
		user.visible_message("<span class='suicide'>[user] is hitting [user.p_them()]self with [src]! It looks like [user.p_theyre()] trying to discipline [user.p_them()]self for being a mark-ass trick.</span>")
		return (BRUTELOSS)

/obj/item/ammo_box/magazine/internal/shot/canegun
	name = "cane-gun internal magazine"
	max_ammo = 8
	