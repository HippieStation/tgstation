/mob/living/say(message, bubble_type,var/list/spans = list(), sanitize = TRUE, datum/language/language = null)
	if(findtext(message, (pick("rouge", ":^)", ":^(", ":)", ":(", "uwu", "^w^", "^.^", ";w;"))))
		playsound_local(get_turf(src), 'hippiestation/sound/misc/slidewhistle_down.ogg', 90, FALSE, pressure_affected = FALSE)
		src.Knockdown(80)
		src.confused += 5
		if(!issilicon(src))
			to_chat(src, "<span class='boldwarning'>Your own stupidity causes you to collapse!</span>")
			adjustBrainLoss(10)
		else
			to_chat(src, "<span class='boldwarning'>Your own stupidity overloads your sensors!</span>")
			src.flash_act(affect_silicon = 1)
		..()
