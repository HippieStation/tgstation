/datum/outfit/job/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H.client && H.client.key == "carbonhell")
		if(!istype(H.wear_mask, /obj/item/clothing/mask/fakemoustache/italian/cursed))
			if(!H.doUnEquip(H.wear_mask))
				qdel(H.wear_mask)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/fakemoustache/italian/cursed(H), slot_wear_mask)
	..()