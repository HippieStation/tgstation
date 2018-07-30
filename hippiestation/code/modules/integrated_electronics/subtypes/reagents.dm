// - Integrated extinguisher - //
/obj/item/integrated_circuit/reagent/extinguisher
	name = "integrated extinguisher"
	desc = "This circuit sprays any of its contents out like an extinguisher."
	icon_state = "injector"
	extended_desc = "This circuit can hold up to 30 units of any given chemicals. On each use, it sprays these reagents like a fire extinguisher."

	container_type = OPENCONTAINER
	volume = 30

	complexity = 30
	cooldown_per_use = 6 SECONDS
	inputs = list(
		"target X rel" = IC_PINTYPE_NUMBER,
		"target Y rel" = IC_PINTYPE_NUMBER
		)
	outputs = list(
		"volume" = IC_PINTYPE_NUMBER,
		"self reference" = IC_PINTYPE_REF
		)
	activators = list(
		"spray" = IC_PINTYPE_PULSE_IN,
		"on sprayed" = IC_PINTYPE_PULSE_OUT,
		"on fail" = IC_PINTYPE_PULSE_OUT
		)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 15
	var/busy = FALSE

/obj/item/integrated_circuit/reagent/extinguisher/Initialize()
	.=..()
	set_pin_data(IC_OUTPUT,2, src)

/obj/item/integrated_circuit/reagent/extinguisher/on_reagent_change(changetype)
	push_vol()

/obj/item/integrated_circuit/reagent/extinguisher/do_work()
	//Check if enough volume
	set_pin_data(IC_OUTPUT, 1, reagents.total_volume)
	if(!reagents || (reagents.total_volume < IC_SMOKE_REAGENTS_MINIMUM_UNITS) || busy)
		push_data()
		activate_pin(3)
		return

	playsound(src.loc, 'sound/effects/extinguish.ogg', 75, 1, -3)

	//Get the tile on which the water particle spawns
	var/turf/Spawnpoint = get_turf(src)
	if(!Spawnpoint)
		push_data()
		activate_pin(3)
		return


	//Get direction and target turf for each water particle
	var/turf/T = locate(Spawnpoint.x + get_pin_data(IC_INPUT, 1),Spawnpoint.y + get_pin_data(IC_INPUT, 2),Spawnpoint.z)
	if(!T)
		push_data()
		activate_pin(3)
		return
	var/direction = get_dir(Spawnpoint, T)
	var/turf/T1 = get_step(T,turn(direction, 90))
	var/turf/T2 = get_step(T,turn(direction, -90))
	var/list/the_targets = list(T,T1,T2)
	busy = TRUE

	for(var/a=0, a<5, a++)
		spawn(0)
			var/obj/effect/particle_effect/water/W = new /obj/effect/particle_effect/water(get_turf(src))
			if(!src)
				break
			if(!W)
				continue
			var/turf/my_target = pick(the_targets)
			var/datum/reagents/R = new/datum/reagents(5)
			W.reagents = R
			R.my_atom = W
			reagents.trans_to(W,1)
			for(var/b=0, b<5, b++)
				step_towards(W,my_target)
				if(!W || !W.reagents)
					break
				W.reagents.reaction(get_turf(W))
				for(var/A in get_turf(W))
					if(!W)
						break
					W.reagents.reaction(A)
				if(W.loc == my_target)
					break
				sleep(2)
	push_data()
	activate_pin(2)
	busy = FALSE

// - Drain circuit - //
/obj/item/integrated_circuit/reagent/drain
	name = "chemical drain circuit"
	desc = "This circuit either eliminates reagents by creating a puddle or can suck up chemicals on tiles."
	icon_state = "injector"
	extended_desc = "Set mode to FALSE to eliminate reagents and TRUE to drain."

	container_type = OPENCONTAINER
	volume = 20

	complexity = 10
	inputs = list(
		"mode" = IC_PINTYPE_BOOLEAN
		)
	outputs = list(
		"volume" = IC_PINTYPE_NUMBER,
		"self reference" = IC_PINTYPE_REF
		)
	activators = list(
		"drain" = IC_PINTYPE_PULSE_IN,
		"on drained" = IC_PINTYPE_PULSE_OUT,
		"on fail" = IC_PINTYPE_PULSE_OUT
		)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 15


/obj/item/integrated_circuit/reagent/drain/Initialize()
	.=..()
	set_pin_data(IC_OUTPUT,2, src)


/obj/item/integrated_circuit/reagent/drain/do_work()
	if(get_pin_data(IC_OUTPUT, 1, reagents.total_volume))
		if(!reagents || !reagents.total_volume)
			push_data()
			activate_pin(3)
			return
		// Put the reagents on the floortile the assembly is on
		reagents.reaction(get_turf(src))
		reagents.clear_reagents()
		push_data()
		activate_pin(2)
		return

	else
		if(reagents)
			if(reagents.total_volume >= volume)
				push_data()
				activate_pin(3)
				return
		// Favorably, drain it from a chemicals pile, else, try something different
		var/obj/effect/decal/cleanable/drainedchems = locate(/obj/effect/decal/cleanable) in get_turf(src)
		if(!drainedchems || !drainedchems.reagents || drainedchems.reagents.total_volume == 0)
			push_data()
			activate_pin(3)
			return
		drainedchems.reagents.trans_to(src, 30, 0.5)
		if(drainedchems.reagents.total_volume == 0)
			qdel(drainedchems)
	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/reagent/drain/on_reagent_change(changetype)
	push_vol()
