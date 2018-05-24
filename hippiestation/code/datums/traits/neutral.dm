/* Hippie Neutral Traits */
/datum/quirk/monochromatic
	name = "Monochromacy"
	desc = "You suffer from full colorblindness, and perceive nearly the entire world in blacks and whites."
	value = 0
	medical_record_text = "Patient is afflicted with almost complete color blindness."

/datum/quirk/monochromatic/add()
	quirk_holder.add_client_colour(/datum/client_colour/monochrome)

/datum/quirk/monochromatic/post_add()
	if(quirk_holder.mind.assigned_role == "Detective")
		to_chat(quirk_holder, "<span class='boldannounce'>Mmm. Nothing's ever clear on this station. It's all shades of gray...</span>")
		quirk_holder.playsound_local(quirk_holder, 'sound/ambience/ambidet1.ogg', 50, FALSE)

/datum/quirk/monochromatic/remove()
	quirk_holder.remove_client_colour(/datum/client_colour/monochrome)

/datum/quirk/greyscale_vision
	name = "Old School Vision"
	desc = "Did you get stuck in an old video recorder? You can only see in black and white!"
	value = 0
	gain_text = "<span class='notice'>...Huh? You can't see colour anymore!</span>"
	lose_text = "<span class='notice'>You can see colour again!</span>"

/datum/quirk/greyscale_vision/add()
	quirk_holder.add_client_colour(/datum/client_colour/greyscale)

/datum/quirk/greyscale_vision/remove()
	quirk_holder.remove_client_colour(/datum/client_colour/greyscale)

/datum/quirk/inverted_vision
	name = "Inverted Colour Vision"
	desc = "You see red and blue colours as reversed."
	value = 0
	gain_text = "<span class='notice'>You feel like you're seeing colours differently.</span>"
	lose_text = "<span class='notice'>You feel like you're seeing colours normally again.</span>"

/datum/quirk/inverted_vision/add()
	quirk_holder.add_client_colour(/datum/client_colour/inverted)

/datum/quirk/inverted_vision/remove()
	quirk_holder.remove_client_colour(/datum/client_colour/inverted)

//I'm going to leave this code in here just in case we figure out how to do it properly, but for now leave this disabled - it doesn't work
/*
/datum/quirk/vibrancy
	name = "Vibrancy"
	desc = "You must have taken some of the good stuff, because everything looks way brighter and far more vibrant!"
	value = 0
	lose_text = "<span class='notice'>It seems like everything is not so vibrant anymore...</span>"

/datum/quirk/vibrancy/add()
	if (locate(/datum/client_colour/monochrome) in quirk_holder.client_colours)
		to_chat(quirk_holder, "<span class='warning'>You feel your vibrant vision having no effect because of your monochromacy!</span>")
		sleep(20) //Don't want the two messages to pop up instantly, muh immershun
		remove()
	else
		quirk_holder.add_client_colour(/datum/client_colour/vibrant)
		to_chat(quirk_holder, "<span class='notice'>You feel like everything has gotten brighter and more colourful.</span>")

		//The vibrancy trait won't get removed if you have monochromacy because when traits get added at roundstart, it doesn't currently call the add proc, so there's probably no use for all of this

/datum/quirk/vibrancy/remove()
	quirk_holder.remove_client_colour(/datum/client_colour/vibrant)
*/

/datum/quirk/super_lungs
	name = "Super Lungs"
	desc = "Your extra powerful lungs allow you to scream much louder than normal, at the cost of losing more oxygen whenever you scream."
	value = 0
	gain_text = "<span class='notice'>You feel like you can scream louder than normal.</span>"
	lose_text = "<span class='notice'>You feel your ability to scream returning to normal.</span>"

/datum/quirk/super_lungs/add()
	var/mob/living/carbon/human/H = quirk_holder
	H.scream_vol = 100
	H.scream_oxyloss = 10

/datum/quirk/super_lungs/remove()
	var/mob/living/carbon/human/H = quirk_holder
	H.scream_vol = initial(H.scream_vol)
	H.scream_oxyloss = initial(H.scream_oxyloss)

/datum/quirk/chronicbrainrot
	name = "Chronic Brainrot"
	desc = "You have a permanent, non-infectious version of brainrot that has rendered you permanently retarded and progressively gives you brain damage. However, the incredible amounts of retardation you have gained allow you to have an imaginary friend."
	value = 0
	gain_text = "<span class='danger'>You feel like you're slowly becoming dumber.</span>"
	lose_text = "<span class='notice'>You no longer feel as if you're getting dumber...</span>"

/datum/quirk/chronicbrainrot/on_process()
	var/mob/living/carbon/human/H = quirk_holder
	if(prob(50))
		H.adjustBrainLoss(rand(0.25, 1))

/datum/quirk/chronicbrainrot/add()
	var/mob/living/carbon/human/H = quirk_holder
	if(istype(H))
		H.gain_trauma(/datum/brain_trauma/mild/dumbness, TRAUMA_RESILIENCE_ABSOLUTE)
		H.gain_trauma(/datum/brain_trauma/special/imaginary_friend, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/chronicbrainrot/remove()
	var/mob/living/carbon/human/H = quirk_holder
	H.cure_trauma_type(brain_trauma_type = /datum/brain_trauma/mild/dumbness, TRAUMA_RESILIENCE_ABSOLUTE)
	H.cure_trauma_type(brain_trauma_type = /datum/brain_trauma/special/imaginary_friend, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/split_personality	//For testing in live, remove this once testing is complete
	name = "Split Personality"
	desc = "This trait gives you a split personality, simple as that. *THIS IS A TEMPORARY TRAIT FOR TESTING PURPOSES* bugs and/or crashes may occur from split personalities so pick this at your own risk!!"
	value = 0
	gain_text = "<span class='notice'>You now have a split personality via trait.</span>"
	lose_text = "<span class='notice'>You no longer have a split personality via trait.</span>"

/datum/quirk/split_personality/add()
	var/mob/living/carbon/human/H = quirk_holder
	if(istype(H))
		H.gain_trauma(/datum/brain_trauma/severe/split_personality, TRAUMA_RESILIENCE_SURGERY)

/datum/quirk/split_personality/remove()
	var/mob/living/carbon/human/H = quirk_holder
	H.cure_trauma_type(brain_trauma_type = /datum/brain_trauma/severe/split_personality, TRAUMA_RESILIENCE_SURGERY)