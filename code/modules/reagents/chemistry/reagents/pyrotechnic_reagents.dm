
/datum/reagent/thermite
	name = "Thermite"
	description = "Thermite produces an aluminothermic reaction known as a thermite reaction. Can be used to melt walls."
	reagent_state = SOLID
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	color = "#550000"
	taste_description = "sweet tasting metal"

/datum/reagent/thermite/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	if(reac_volume >= 1)
		exposed_turf.AddComponent(/datum/component/thermite, reac_volume)

/datum/reagent/thermite/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjustFireLoss(1 * REM * delta_time, 0)
	..()
	return TRUE

/datum/reagent/nitroglycerin
	name = "Nitroglycerin"
	description = "Nitroglycerin is a heavy, colorless, oily, explosive liquid obtained by nitrating glycerol."
	color = "#808080" // rgb: 128, 128, 128
	taste_description = "oil"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/stabilizing_agent
	name = "Stabilizing Agent"
	description = "Keeps unstable chemicals stable. This does not work on everything."
	reagent_state = LIQUID
	color = "#FFFF00"
	taste_description = "metal"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

	//It has stable IN THE NAME. IT WAS MADE FOR THIS MOMENT.
/datum/reagent/stabilizing_agent/on_hydroponics_apply(obj/item/seeds/myseed, datum/reagents/chems, obj/machinery/hydroponics/mytray, mob/user)
	. = ..()
	if(myseed && chems.has_reagent(type, 1))
		myseed.adjust_instability(-1)

/datum/reagent/clf3
	name = "Chlorine Trifluoride"
	description = "Makes a temporary 3x3 fireball when it comes into existence, so be careful when mixing. ClF3 applied to a surface burns things that wouldn't otherwise burn, sometimes through the very floors of the station and exposing it to the vacuum of space."
	reagent_state = LIQUID
	color = "#FFC8C8"
	metabolization_rate = 10 * REAGENTS_METABOLISM
	taste_description = "burning"
	penetrates_skin = NONE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/clf3/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjust_fire_stacks(2 * REM * delta_time)
	M.adjustFireLoss(0.3 * max(M.fire_stacks, 1) * REM * delta_time, 0)
	..()
	return TRUE

/datum/reagent/clf3/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	if(isplatingturf(exposed_turf))
		var/turf/open/floor/plating/target_plating = exposed_turf
		if(prob(10 + target_plating.burnt + 5*target_plating.broken)) //broken or burnt plating is more susceptible to being destroyed
			target_plating.ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
	if(isfloorturf(exposed_turf))
		var/turf/open/floor/target_floor = exposed_turf
		if(prob(reac_volume))
			target_floor.make_plating()
		else if(prob(reac_volume))
			target_floor.burn_tile()
		if(isfloorturf(target_floor))
			for(var/turf/nearby_turf in RANGE_TURFS(1, target_floor))
				if(!locate(/obj/effect/hotspot) in nearby_turf)
					new /obj/effect/hotspot(nearby_turf)

/datum/reagent/clf3/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	exposed_mob.adjust_fire_stacks(min(reac_volume/5, 10))
	exposed_mob.IgniteMob()
	if(!locate(/obj/effect/hotspot) in exposed_mob.loc)
		new /obj/effect/hotspot(exposed_mob.loc)

/datum/reagent/sorium
	name = "Sorium"
	description = "Sends everything flying from the detonation point."
	reagent_state = LIQUID
	color = "#5A64C8"
	taste_description = "air and bitterness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/liquid_dark_matter
	name = "Liquid Dark Matter"
	description = "Sucks everything into the detonation point."
	reagent_state = LIQUID
	color = "#210021"
	taste_description = "compressed bitterness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/gunpowder
	name = "Gunpowder"
	description = "Explodes. Violently."
	reagent_state = LIQUID
	color = "#000000"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	taste_description = "salt"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/gunpowder/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	. = TRUE
	..()
	if(!isplasmaman(M))
		return
	M.set_drugginess(15 * REM * delta_time)
	if(M.hallucination < volume)
		M.hallucination += 5 * REM * delta_time

/datum/reagent/gunpowder/on_ex_act()
	var/location = get_turf(holder.my_atom)
	var/datum/effect_system/reagents_explosion/e = new()
	e.set_up(1 + round(volume/6, 1), location, 0, 0, message = 0)
	e.start()
	holder.clear_reagents()

/datum/reagent/rdx
	name = "RDX"
	description = "Military grade explosive"
	reagent_state = SOLID
	color = "#FFFFFF"
	taste_description = "salt"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/tatp
	name = "TaTP"
	description = "Suicide grade explosive"
	reagent_state = SOLID
	color = "#FFFFFF"
	taste_description = "death"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/flash_powder
	name = "Flash Powder"
	description = "Makes a very bright flash."
	reagent_state = LIQUID
	color = "#C8C8C8"
	taste_description = "salt"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/smoke_powder
	name = "Smoke Powder"
	description = "Makes a large cloud of smoke that can carry reagents."
	reagent_state = LIQUID
	color = "#C8C8C8"
	taste_description = "smoke"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/sonic_powder
	name = "Sonic Powder"
	description = "Makes a deafening noise."
	reagent_state = LIQUID
	color = "#C8C8C8"
	taste_description = "loud noises"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/phlogiston
	name = "Phlogiston"
	description = "Catches you on fire and makes you ignite."
	reagent_state = LIQUID
	color = "#FA00AF"
	taste_description = "burning"
	self_consuming = TRUE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/phlogiston/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	exposed_mob.adjust_fire_stacks(1)
	var/burndmg = max(0.3*exposed_mob.fire_stacks, 0.3)
	exposed_mob.adjustFireLoss(burndmg, 0)
	exposed_mob.IgniteMob()

/datum/reagent/phlogiston/on_mob_life(mob/living/carbon/metabolizer, delta_time, times_fired)
	metabolizer.adjust_fire_stacks(1 * REM * delta_time)
	metabolizer.adjustFireLoss(0.3 * max(metabolizer.fire_stacks, 0.15) * REM * delta_time, 0)
	..()
	return TRUE

/datum/reagent/napalm
	name = "Napalm"
	description = "Very flammable."
	reagent_state = LIQUID
	color = "#FA00AF"
	taste_description = "burning"
	self_consuming = TRUE
	penetrates_skin = NONE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

	// why, just why
/datum/reagent/napalm/on_hydroponics_apply(obj/item/seeds/myseed, datum/reagents/chems, obj/machinery/hydroponics/mytray, mob/user)
	. = ..()
	if(chems.has_reagent(type, 1))
		if(!(myseed.resistance_flags & FIRE_PROOF))
			mytray.adjustHealth(-round(chems.get_reagent_amount(type) * 6))
			mytray.adjustToxic(round(chems.get_reagent_amount(type) * 7))
		mytray.adjustWeeds(-rand(5,9)) //At least give them a small reward if they bother.

/datum/reagent/napalm/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjust_fire_stacks(1 * REM * delta_time)
	..()

/datum/reagent/napalm/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(istype(exposed_mob) && (methods & (TOUCH|VAPOR|PATCH)))
		exposed_mob.adjust_fire_stacks(min(reac_volume/4, 20))

#define CRYO_SPEED_PREFACTOR 0.4
#define CRYO_SPEED_CONSTANT 0.1

/datum/reagent/cryostylane
	name = "Cryostylane"
	description = "Induces a cryostasis like state in a patient's organs, preventing them from decaying while dead. Slows down surgery while in a patient however. When reacted with oxygen, it will slowly consume it and reduce a container's temperature to 0K. Also damages slime simplemobs when 5u is sprayed."
	color = "#0000DC"
	metabolization_rate = 0.05 * REAGENTS_METABOLISM
	taste_description = "icey bitterness"
	purity = REAGENT_STANDARD_PURITY
	self_consuming = TRUE
	impure_chem = /datum/reagent/consumable/ice
	inverse_chem_val = 0.5
	inverse_chem = /datum/reagent/inverse/cryostylane
	failed_chem = null
	burning_volume = 0.05
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED | REAGENT_DEAD_PROCESS

/datum/reagent/cryostylane/burn(datum/reagents/holder)
	if(holder.has_reagent(/datum/reagent/oxygen))
		burning_temperature = 0//king chilly
		return
	burning_temperature = null

/datum/reagent/cryostylane/on_mob_add(mob/living/consumer, amount)
	. = ..()
	consumer.mob_surgery_speed_mod = 1-((CRYO_SPEED_PREFACTOR * (1 - creation_purity))+CRYO_SPEED_CONSTANT) //10% - 30% slower
	consumer.color = COLOR_CYAN

/datum/reagent/cryostylane/on_mob_delete(mob/living/consumer)
	. = ..()
	consumer.mob_surgery_speed_mod = 1
	consumer.color = COLOR_WHITE

//Pauses decay! Does do something, I promise.
/datum/reagent/cryostylane/on_mob_dead(mob/living/carbon/consumer, delta_time)
	. = ..()
	metabolization_rate = 0.05 * REM //slower consumption when dead

/datum/reagent/cryostylane/on_mob_life(mob/living/carbon/consumer, delta_time, times_fired)
	metabolization_rate = 0.25 * REM//faster consumption when alive
	if(consumer.reagents.has_reagent(/datum/reagent/oxygen))
		consumer.reagents.remove_reagent(/datum/reagent/oxygen, 0.5 * REM * delta_time)
		consumer.adjust_bodytemperature(-15 * REM * delta_time)
		if(ishuman(consumer))
			var/mob/living/carbon/human/humi = consumer
			humi.adjust_coretemperature(-15 * REM * delta_time)
	..()

/datum/reagent/cryostylane/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	if(reac_volume < 5)
		return
	for(var/mob/living/simple_animal/slime/exposed_slime in exposed_turf)
		exposed_slime.adjustToxLoss(rand(15,30))

#undef CRYO_SPEED_PREFACTOR
#undef CRYO_SPEED_CONSTANT

/datum/reagent/pyrosium
	name = "Pyrosium"
	description = "Comes into existence at 20K. As long as there is sufficient oxygen for it to react with, Pyrosium slowly heats all other reagents in the container."
	color = "#64FAC8"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	taste_description = "bitterness"
	self_consuming = TRUE
	burning_temperature = null
	burning_volume = 0.05
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/pyrosium/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(holder.has_reagent(/datum/reagent/oxygen))
		holder.remove_reagent(/datum/reagent/oxygen, 0.5 * REM * delta_time)
		M.adjust_bodytemperature(15 * REM * delta_time)
		if(ishuman(M))
			var/mob/living/carbon/human/humi = M
			humi.adjust_coretemperature(15 * REM * delta_time)
	..()

/datum/reagent/pyrosium/burn(datum/reagents/holder)
	if(holder.has_reagent(/datum/reagent/oxygen))
		burning_temperature = 3500
		return
	burning_temperature = null

/datum/reagent/teslium //Teslium. Causes periodic shocks, and makes shocks against the target much more effective.
	name = "Teslium"
	description = "An unstable, electrically-charged metallic slurry. Periodically electrocutes its victim, and makes electrocutions against them more deadly. Excessively heating teslium results in dangerous destabilization. Do not allow to come into contact with water."
	reagent_state = LIQUID
	color = "#20324D" //RGB: 32, 50, 77
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	taste_description = "charged metal"
	self_consuming = TRUE
	var/shock_timer = 0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/teslium/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	shock_timer++
	if(shock_timer >= rand(5, 30)) //Random shocks are wildly unpredictable
		shock_timer = 0
		M.electrocute_act(rand(5, 20), "Teslium in their body", 1, SHOCK_NOGLOVES) //SHOCK_NOGLOVES because it's caused from INSIDE of you
		playsound(M, "sparks", 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	..()

/datum/reagent/teslium/on_mob_metabolize(mob/living/carbon/human/L)
	. = ..()
	if(!istype(L))
		return
	L.physiology.siemens_coeff *= 2

/datum/reagent/teslium/on_mob_end_metabolize(mob/living/carbon/human/L)
	. = ..()
	if(!istype(L))
		return
	L.physiology.siemens_coeff *= 0.5

/datum/reagent/teslium/energized_jelly
	name = "Energized Jelly"
	description = "Electrically-charged jelly. Boosts jellypeople's nervous system, but only shocks other lifeforms."
	reagent_state = LIQUID
	color = "#CAFF43"
	taste_description = "jelly"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/teslium/energized_jelly/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(isjellyperson(M))
		shock_timer = 0 //immune to shocks
		M.AdjustAllImmobility(-40  *REM * delta_time)
		M.adjustStaminaLoss(-2 * REM * delta_time, 0)
		if(isluminescent(M))
			var/mob/living/carbon/human/H = M
			var/datum/species/jelly/luminescent/L = H.dna.species
			L.extract_cooldown = max(L.extract_cooldown - (20 * REM * delta_time), 0)
	..()

/datum/reagent/firefighting_foam
	name = "Firefighting Foam"
	description = "A historical fire suppressant. Originally believed to simply displace oxygen to starve fires, it actually interferes with the combustion reaction itself. Vastly superior to the cheap water-based extinguishers found on NT vessels."
	reagent_state = LIQUID
	color = "#A6FAFF55"
	taste_description = "the inside of a fire extinguisher"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/firefighting_foam/expose_turf(turf/open/exposed_turf, reac_volume)
	. = ..()
	if (!istype(exposed_turf))
		return

	if(reac_volume >= 1)
		var/obj/effect/particle_effect/foam/firefighting/foam = (locate(/obj/effect/particle_effect/foam) in exposed_turf)
		if(!foam)
			foam = new(exposed_turf)
		else if(istype(foam))
			foam.lifetime = initial(foam.lifetime) //reduce object churn a little bit when using smoke by keeping existing foam alive a bit longer

	var/obj/effect/hotspot/hotspot = (locate(/obj/effect/hotspot) in exposed_turf)
	if(hotspot && !isspaceturf(exposed_turf) && exposed_turf.air)
		var/datum/gas_mixture/air = exposed_turf.air
		if(air.temperature > T20C)
			air.temperature = max(air.temperature/2,T20C)
		air.react(src)
		qdel(hotspot)

/datum/reagent/firefighting_foam/expose_obj(obj/exposed_obj, reac_volume)
	. = ..()
	exposed_obj.extinguish()

/datum/reagent/firefighting_foam/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(methods & (TOUCH|VAPOR))
		exposed_mob.extinguish_mob() //All stacks are removed

/datum/reagent/impvolt
	name = "Translucent mixture"
	description = "It's sparking slightly."
	color = "#CABFAC"
	metabolization_rate = 2 * REAGENTS_METABOLISM

/datum/reagent/impvolt/on_mob_life(mob/living/M)
	if(prob(25))
		to_chat(M, "<span class='userdanger'>Your insides burn!</span>")
		M.adjustFireLoss(10)
	..()

/datum/reagent/volt
	name = "Sparking mixture"
	description = " A bubbling concoction of sparks and static electricity."
	color = "#11BFAC"

/datum/reagent/volt/on_mob_life(mob/living/M)
	if(prob(20))
		for(var/mob/living/T in view(M.loc,6))
			M.Beam(T, icon_state="lightning[rand(1,12)]",time=5)
			T.electrocute_act(15, "\a lightning from [M]")
		playsound(M.loc, 'sound/magic/lightningbolt.ogg', 50, 1)
		holder.remove_reagent(src.type,10, safety = 1)
	..()

/datum/reagent/cryogenic_fluid
	name = "Cryogenic Fluid"
	description = "Extremely cold superfluid used to put out fires that will viciously freeze people on contact causing severe pain and burn damage, weak if ingested."
	color = "#b3ffff"
	metabolization_rate = 1.5 * REAGENTS_METABOLISM

/datum/reagent/cryogenic_fluid/process()
	if(holder)
		holder.chem_temp = max(holder.chem_temp - 15, TCMB)


/datum/reagent/cryogenic_fluid/on_mob_life(mob/living/M) //not very pleasant but fights fires
	M.adjust_fire_stacks(-2)
	M.adjustStaminaLoss(2)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 1)
	M.bodytemperature = max(M.bodytemperature - 10, TCMB)
	return ..()

/datum/reagent/cryogenic_fluid/expose_mob(mob/living/M, methods=TOUCH, reac_volume, show_message = 1)
	if(iscarbon(M) && M.stat != DEAD)
		if(methods in list(INGEST,INJECT))
			M.bodytemperature = max(M.bodytemperature - 50, TCMB)
			if(show_message)
				to_chat(M, "<span class='warning'>You feel like you are freezing from the inside!</span>")
		else
			if (reac_volume >= 5)
				if(show_message)
					to_chat(M, "<span class='danger'>You can feel your body freezing up and your metabolism slow, the pain is excruciating!</span>")
				M.bodytemperature = max(M.bodytemperature - 5*reac_volume, TCMB) //cold
				M.adjust_fire_stacks(-(12*reac_volume))
				M.losebreath += (0.2*reac_volume) //no longer instadeath rape but losebreath instead much more immulshion friendly
				M.drowsyness += 2
				M.add_confusion(6)
				M.adjustOrganLoss(ORGAN_SLOT_BRAIN, (0.25*reac_volume)) //hypothermia isn't good for the brain

			else
			 M.bodytemperature = max(M.bodytemperature - 15, TCMB)
			 M.adjust_fire_stacks(-(6*reac_volume))
	return ..()

/datum/reagent/cryogenic_fluid/expose_turf(turf/T, reac_volume)
	if (!istype(T))
		return FALSE
	var/obj/effect/hotspot/hotspot = (locate(/obj/effect/hotspot) in T) //instantly delts hotspots
	if(isopenturf(T))
		var/turf/open/O = T
		if(hotspot)
			if(O.air)
				var/datum/gas_mixture/G = O.air
				G.temperature = 0
				G.react()
				qdel(hotspot)
		if(reac_volume >= 6)
			O.freon_gas_act() //freon in my pocket

/datum/reagent/sparky
	name = "Electrostatic substance"
	description = "A charged substance that generates an electromagnetic field capable of interfering with light fixtures."
	color = "#A300B3"

/datum/reagent/sparky/on_mob_life(mob/living/M)
	for(var/obj/machinery/light/L in range(M, 5))
		if(prob(25))
			L.flicker()
		if(prob(15))
			L.light_color = pick("#FA8282", "#64C864", "#6496FA", "#7DE1E1", "#C48A18")
		if(prob(2))
			L.break_light_tube()

	if(prob(10))
		M.adjustFireLoss(3)//extremely weak damage
		do_sparks(2, TRUE, M)
	if(prob(5))
		M.adjust_fire_stacks(2)
		holder.remove_reagent(src.type,5)
	..()

/datum/reagent/dizinc//more dangerous than clf3 when ingested with slower metabolism, less effective on touch and doesn't burn objects
	name = "Diethyl zinc"
	description = "Highly pyrophoric substance that incinerates carbon based life, although it's not so effective on objects"
	color = "#000067"
	metabolization_rate = 2 * REAGENTS_METABOLISM

/datum/reagent/dizinc/on_mob_life(mob/living/M)
	M.adjust_fire_stacks(4)
	M.IgniteMob()
	..()

/datum/reagent/dizinc/expose_mob(mob/living/M, methods=TOUCH)
	if(methods != INGEST && methods != INJECT)
		M.adjust_fire_stacks(pick(1, 3))
		M.IgniteMob()
		..()

/datum/reagent/hexamine
	name = "Hexamine"
	description = "Used in fuel production"
	color = "#000067"
	metabolization_rate = 4 * REAGENTS_METABOLISM

/datum/reagent/hexamine/on_mob_life(mob/living/M)
	M.adjust_fire_stacks(3)//increases burn time
	..()

/datum/reagent/hexamine/expose_mob(mob/living/M, methods=TOUCH, reac_volume)
	M.adjust_fire_stacks(min(reac_volume/2, 10))//much more effective on the outside
	..()

/datum/reagent/emit
	name = "Emittrium"
	description = "An unstable compound prone to emitting intense bursts of plasma when in an excited state, it currently appears inert."
	color = "#AAFFAA"

/datum/reagent/emit_on
	name = "Glowing Emittrium"
	description = "It's rather radioactive and glowing painfully bright, you feel the need to RUN!"
	color = "#1211FB"

/datum/reagent/emit_on/process()
	if(holder)
		playsound(get_turf(holder.my_atom), 'sound/weapons/emitter.ogg', 50, 1)
		for(var/direction in GLOB.cardinals)
			var/obj/projectile/beam/emitter/P = new /obj/projectile/beam/emitter(get_turf(holder.my_atom))
			switch(direction)
				if(1)
					P.fire(dir2angle(1))

				if(2)
					P.fire(dir2angle(2))

				if(4)
					P.fire(dir2angle(4))

				if(8)
					P.fire(dir2angle(8))

		holder.remove_reagent(src.type,10,safety = 1)
	..()

/datum/reagent/emit_on/on_mob_life(mob/living/M)
	M.apply_effect(5, EFFECT_IRRADIATE, 0)
	..()

/datum/reagent/sboom
	name = "Nitrogenated isopropyl alcohol"
	description = "Hmm , needs more nitrogen!"
	color = "#13BC5E"

/datum/reagent/superboom//oh boy
	name = "N-amino azidotetrazole"
	description = "An absurdly unstable chemical prone to causing gigantic explosions when even slightly disturbed. Only an idiot would attempt to create this."
	color = "#13BC5E"

/datum/reagent/superboom/on_mob_life(mob/living/M)
	if(M.m_intent == MOVE_INTENT_RUN && current_cycle <= 5)
		var/location = get_turf(holder.my_atom)
		var/datum/effect_system/reagents_explosion/e = new()
		e.set_up(round(volume, 0.5), location, 0, 0, message = 0)
		e.start()
		holder.clear_reagents()
	..()

/datum/reagent/superboom/on_ex_act()
	var/location = get_turf(holder.my_atom)
	var/datum/effect_system/reagents_explosion/e = new()
	e.set_up(round(volume, 0.5), location, 0, 0, message = 0)
	e.start()
	holder.clear_reagents()
	..()

/datum/reagent/oxyplas//very rapidly heats people up then metabolises
	name = "Plasminate"
	description = "A toxic and flammable precursor"
	color = "#FF32A1"
	metabolization_rate = 4 * REAGENTS_METABOLISM

/datum/reagent/oxyplas/expose_mob(mob/living/M, methods=TOUCH)
	var/turf/T = get_turf(M)
	for(var/turf/F in range(1,T))
		new /obj/effect/hotspot(F)
	..()

/datum/reagent/oxyplas/on_mob_life(mob/living/M)
	M.adjustToxLoss(1)
	M.bodytemperature += 60
	..()

/datum/reagent/proto//volatile. causes fireballs when heated or put in a burning human
	name = "Protomatised plasma"
	description = "An exceedingly pyrophoric state of plasma that superheats air and lifeforms alike"
	color = "#FF0000"

/datum/reagent/proto/expose_mob(mob/living/M, methods=TOUCH)
	var/turf/T = get_turf(M)
	for(var/turf/F in range(1,T))
		new /obj/effect/hotspot(F)
	..()

/datum/reagent/proto/on_mob_life(mob/living/M)
	if(M.on_fire)
		var/turf/T = get_turf(M)
		for(var/turf/F in range(1,T))
			new /obj/effect/hotspot(F)
	else
		M.reagents.add_reagent(pick("clf3", "dizinc", "oxyplas", "plasma"), 2)//ouch
	..()

/datum/reagent/arclumin//memechem made in honour of the late arclumin
	name = "Arc-Luminol"
	description = "You have no idea what the fuck this is but it looks absurdly unstable. It is emitting a sickly glow suggesting ingestion is probably not a great idea."
	color = "#ffff66" //RGB: 255, 255, 102
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

/datum/reagent/arclumin/on_mob_life(mob/living/carbon/M)//windup starts off with constant shocking, confusion, dizziness and oscillating luminosity
	M.electrocute_act(1, 1, 1, stun = FALSE) //Override because it's caused from INSIDE of you
	M.set_light(rand(1,3))
	M.add_confusion(2)
	M.dizziness += 4
	if(current_cycle >= 20) //the fun begins as you become a demigod of chaos
		var/turf/open/T = get_turf(holder.my_atom)
		switch(rand(1,6))

			if(1)
				playsound(T, 'sound/magic/lightningbolt.ogg', 50, 1)
				tesla_zap(T, 6, 1000)//weak tesla zap
				M.Stun(2)

			if(2)
				playsound(T, 'sound/effects/EMPulse.ogg', 30, 1)
				do_teleport(M, T, 5)

			if(3)
				M.random_mutate()
				if(prob(75))
					M.easy_random_mutate(NEGATIVE+MINOR_NEGATIVE)
				if(prob(1))
					M.easy_random_mutate(POSITIVE)
				M.updateappearance()
				M.domutcheck()

			if(4)
				empulse(T, 3, 5, 1)

			if(5)
				playsound(T, 'sound/effects/supermatter.ogg', 20, 1)
				radiation_pulse(T, 4, 8, 25, 0)

			if(6)
				T.atmos_spawn_air("water_vapor= 40 ;TEMP= 298")//janitor friendly
	..()

/datum/reagent/arclumin/on_mob_end_metabolize(mob/living/M)// so you don't remain at luminosity 3 forever
	M.set_light(0)

/datum/reagent/arclumin/expose_mob(mob/living/M, methods=TOUCH, reac_volume, show_message = 1)//weak on touch, short teleport and low damage shock, will however give a permanent weak glow
	if(methods == TOUCH)
		M.electrocute_act(5, 1, 1, stun = FALSE)
		M.set_light(1)
		var/turf/T = get_turf(M)
		do_teleport(M, T, 2)
