/* This is currently only supported for monkeys */
/mob/living/proc/hippie_equip_mob_with_items(rand_int)
	return

/mob/living/resist_grab(moving_resist)
	if(pulledby.grab_state)
		if(prob(30) && pulledby.grab_state != GRAB_KILL)
			visible_message("<span class='danger'>[src] has broken free of [pulledby]'s grip!</span>")
			log_combat(pulledby, src, "broke grab")
			pulledby.stop_pulling()
			return FALSE
		if(moving_resist && client) //we resisted by trying to move
			client.move_delay = world.time + 20
	else
		pulledby.stop_pulling()

/mob/living/proc/canGhost()
	return TRUE

/mob/living/proc/canSuccumb()
	return TRUE

/mob/living/proc/do_pindown(atom/A, tog=1)
	var/pixel_x_diff = 0
	var/pixel_y_diff = 0
	var/direction = get_dir(src, A)
	switch(direction)
		if(NORTH)
			pixel_y_diff = 8
		if(SOUTH)
			pixel_y_diff = -8
		if(EAST)
			pixel_x_diff = 8
		if(WEST)
			pixel_x_diff = -8
		if(NORTHEAST)
			pixel_x_diff = 8
			pixel_y_diff = 8
		if(NORTHWEST)
			pixel_x_diff = -8
			pixel_y_diff = 8
		if(SOUTHEAST)
			pixel_x_diff = 8
			pixel_y_diff = -8
		if(SOUTHWEST)
			pixel_x_diff = -8
			pixel_y_diff = -8
	if (tog)
		animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, time = 2)
	else
		animate(src, pixel_x = initial(pixel_x), pixel_y = initial(pixel_y), time = 2)
		setMovetype(movement_type & ~FLOATING) // If we were without gravity, the bouncing animation got stopped, so we make sure we restart the bouncing after the next movement.

/mob/living/Initialize()
	. = ..()
	update_transform()

//Called when we bump onto a mob
/mob/living/MobBump(mob/M)
	// Can't move with pinned people
	if (pinned_to || M.pinned_to)
		return TRUE

	return ..()

/mob/living/proc/update_tts_hud()
	if (!hud_used)
		return
	if (!hud_used.tts)
		return
	hud_used.tts.icon_state = "tts_ready"

/mob/living/proc/process_residual_energy()
	var/static/list/beneficial_clothes = typecacheof(list(
		/obj/item/clothing/suit/wizrobe,
		/obj/item/clothing/head/wizard
	))

	. = 5
	if(mind && (mind.assigned_role == "Scientist" || mind.assigned_role == "Research Director"))
		. -= 0.5
	var/obj/item/clothing/helmet = get_item_by_slot(ITEM_SLOT_HEAD)
	if(is_type_in_typecache(helmet, beneficial_clothes))
		. += 0.45
	else
		if(helmet && istype(helmet))
			if(helmet.clothing_flags & THICKMATERIAL)
				. -= 0.5
	var/obj/item/clothing/armor = get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(is_type_in_typecache(armor, beneficial_clothes))
		. += 0.75
	else
		if(armor && istype(armor))
			if(armor.clothing_flags & THICKMATERIAL)
				if(armor.body_parts_covered & CHEST)
					. -= 0.5
				if(armor.body_parts_covered & GROIN)
					. -= 0.5
				if(armor.body_parts_covered & LEGS)
					. -= 0.5
				if(armor.body_parts_covered & ARMS)
					. -= 0.5
