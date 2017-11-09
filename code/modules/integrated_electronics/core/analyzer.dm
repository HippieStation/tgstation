

/obj/item/device/integrated_electronics/analyzer
	name = "circuit analyzer"
	desc = "This tool can scan an assembly and generate code necessary to recreate it in a circuit printer."
	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "analyzer"
	flags_1 = CONDUCT_1
	w_class = 2
	var/list/circuit_list = list()
	var/list/assembly_list = list(new /obj/item/device/electronic_assembly(null),
			new /obj/item/device/electronic_assembly/medium(null),
			new /obj/item/device/electronic_assembly/large(null),
			new /obj/item/device/electronic_assembly/drone(null))

/obj/item/device/integrated_electronics/analyzer/afterattack(var/atom/A, var/mob/living/user)
	visible_message( "<span class='notice'>attempt to scan</span>")
	if(ispath(A.type,/obj/item/device/electronic_assembly))
		var/i = 0
		var/j = 0
		var/HTML ="start.assembly{{*}}"  //1-st in chapters.1-st block is just to secure start of program from excess symbols.{{*}} is delimeter for chapters.
		visible_message( "<span class='notice'>start of scan</span>")
		for(var/obj/item/I in assembly_list)
			if( A.type == I.type )
				HTML += I.name+"=-="+A.name         //2-nd block.assembly type and name. Maybe in future there will also be color and accesories.
				break
		/*
		If(I.name == "electronic implant")
			var/obj/item/weapon/implant/integrated_circuit/PI = PA        //now it can't recreate electronic implants.and devices maybe I'll fix it later.
			var/obj/item/device/electronic_assembly/implant/PIC = PI.IC
			A = PIC
			*/
		HTML += "{{*}}components"                   //3-rd block.components. First element is useless.delimeter for elements is ^%^.In element first circuit's default name.Second is user given name.delimiter is =-=

		for(var/obj/item/integrated_circuit/IC in A.contents)
			i =i + 1
			HTML += "^%^"+IC.name+"=-="+IC.displayed_name
		if(i == 0)
			return
		HTML += "{{*}}values"					//4-th block.values. First element is useless.delimeter for elements is ^%^.In element first i/o id.Second is data type.third is value.delimiter is :+:

		i = 0
		var/val
		var/list/inp=list()
		var/list/out=list()
		var/list/act=list()
		var/list/ioa=list()
		for(var/obj/item/integrated_circuit/IC in A.contents)
			i += 1
			j = 0
			for(var/datum/integrated_io/IN in IC.inputs)
				j = j + 1
				inp[IN] = "[i]i[j]"
				if(islist(IN.data))
					val = list2params(IN.data)
					HTML += "^%^"+"[i]i[j]:+:list:+:[val]"
				else if(isnum(IN.data))
					val= IN.data
					HTML += "^%^"+"[i]i[j]:+:num:+:[val]"
				else if(istext(IN.data))
					val = IN.data
					HTML += "^%^"+"[i]i[j]:+:text:+:[val]"
			j=0
			for(var/datum/integrated_io/OUT in IC.outputs)               //Also this block uses for setting all i/o id's
				j=j+1
				out[OUT] = "[i]o[j]"
			j=0
			for(var/datum/integrated_io/ACT in IC.activators)
				j=j+1
				act[ACT] = "[i]a[j]"
		ioa.Add(inp)
		ioa.Add(out)
		ioa.Add(act)
		HTML += "{{*}}wires"
		for(var/datum/integrated_io/P in inp)							//5-th block.wires. First element is useless.delimeter for elements is ^%^.In element first i/o id.Second too.delimiter is =-=

			for(var/datum/integrated_io/C in P.linked)
				HTML += "^%^"+inp[P]+"=-="+ioa[C]
		for(var/datum/integrated_io/P in out)
			for(var/datum/integrated_io/C in P.linked)
				HTML += "^%^"+out[P]+"=-="+ioa[C]
		for(var/datum/integrated_io/P in act)
			for(var/datum/integrated_io/C in P.linked)
				HTML += "^%^"+act[P]+"=-="+ioa[C]
		HTML += "{{*}}end"											//6 block.like 1.
		visible_message( "<span class='notice'>[A] has been scanned,</span>")
		user << browse(jointext(HTML, null), "window=analyzer;size=[500]x[600];border=1;can_resize=1;can_close=1;can_minimize=1")
	else
		..()




