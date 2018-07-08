
//After notransform is checked!
/mob/living/carbon/human/proc/OnHippieLifeAfterNoTransform()
	if(client)
		if(jobban_isbanned(src, CATBAN) && src.dna.species.name != "Catbeast") //Jobban checks here
			set_species(/datum/species/tarajan, icon_update=1)
		if(jobban_isbanned(src, CLUWNEBAN) && !dna.check_mutation(CLUWNEMUT))
			dna.add_mutation(CLUWNEMUT)
		if(hud_used)
			if(hud_used.staminas)
				hud_used.staminas.icon_state = staminahudamount()
			if(mind && hud_used.combo_object && hud_used.combo_object.cooldown < world.time)
				hud_used.combo_object.update_icon()
				mind.martial_art.streak = ""

/mob/living/carbon/human/handle_heart()
	var/sent_message = FALSE
	if(!can_heartattack())
		return

	var/we_breath = !has_trait(TRAIT_NOBREATH, SPECIES_TRAIT)


	if(!undergoing_cardiac_arrest())
		sent_message = FALSE
		return

	// Cardiac arrest, unless heart is stabilized
	if(has_trait(TRAIT_STABLEHEART))
		return

	if(undergoing_cardiac_arrest())
		if(NOHEART && !sent_message)
			sent_message = TRUE
			visible_message("<span class='userdanger'>[src] clutches at [src.p_their()] chest as if they lost their heart!</span>")

	if(we_breath)
		adjustOxyLoss(8)
		Unconscious(80)
	// Tissues die without blood circulation
	adjustBruteLoss(2)
