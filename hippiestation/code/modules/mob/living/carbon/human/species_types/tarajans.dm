/datum/species/human/felinid/tarajan
	name = "Catbeast"
	id = "tarajan"
	limbs_id = null
	say_mod = "meows"
	sexes = 1
	species_traits = list(MUTCOLORS,EYECOLOR,NOTRANSSTING)
	inherent_biotypes = list(MOB_ORGANIC, MOB_HUMANOID)
	inherent_traits  = list(TRAIT_PACIFISM, TRAIT_CLUMSY)
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	mutantears = /obj/item/organ/ears/cat/tcat
	mutanttail = /obj/item/organ/tail/cat/tcat
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/cat
	skinned_type = /obj/item/stack/sheet/animalhide/cat
	exotic_bloodtype = "O-" //universal donor, more reason to drain their blood
	burnmod = 1.25
	brutemod = 1.25
	teeth_type = /obj/item/stack/teeth/cat

/datum/species/human/felinid/tarajan/qualifies_for_rank(rank, list/features)
	if(rank in GLOB.command_positions) //even if you turn off humans only
		return 0
	if(rank in GLOB.security_positions) //This list does not include lawyers.
		return 0
	if(rank in GLOB.science_positions)
		return 0
	if(rank in GLOB.medical_positions)
		return 0
	if(rank in GLOB.engineering_positions)
		return 0
	if(rank == "Quartermaster") //QM is not contained in command_positions but we still want to bar mutants from it.
		return 0
	return 1

/datum/species/human/felinid/tarajan/on_species_gain(mob/living/carbon/human/C, datum/species/old_species, pref_load)
	C.draw_hippie_parts()
	. = ..()

/datum/species/human/felinid/tarajan/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	C.draw_hippie_parts(TRUE)
	. = ..()

/datum/species/human/felinid/tarajan/check_roundstart_eligible()
	return TRUE
