
/datum/chemical_reaction/formaldehyde
	results = list(/datum/reagent/toxin/formaldehyde = 3)
	required_reagents = list(/datum/reagent/consumable/ethanol = 1, /datum/reagent/oxygen = 1, /datum/reagent/silver = 1)
	mix_message = "The mixture fizzles and gives off a fierce smell."
	is_cold_recipe = FALSE
	required_temp = 420
	optimal_temp = 520
	overheat_temp = 900
	optimal_ph_min = 0
	optimal_ph_max = 7
	determin_ph_range = 2
	temp_exponent_factor = 2
	ph_exponent_factor = 1.2
	thermic_constant = 200
	H_ion_release = -3
	rate_up_lim = 15
	purity_min = 0.5
	reaction_flags = REACTION_PH_VOL_CONSTANT
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_DAMAGING | REACTION_TAG_CHEMICAL | REACTION_TAG_BRUTE | REACTION_TAG_TOXIN

/datum/chemical_reaction/fentanyl
	results = list(/datum/reagent/toxin/fentanyl = 1)
	required_reagents = list(/datum/reagent/drug/space_drugs = 1)
	mix_message = "The mixture turns cloudy, then becomes clear again."
	is_cold_recipe = FALSE
	required_temp = 674
	optimal_temp = 774
	overheat_temp = 874
	optimal_ph_min = 7
	optimal_ph_max = 11
	determin_ph_range = 3
	temp_exponent_factor = 0.7
	ph_exponent_factor = 10
	thermic_constant = 50
	H_ion_release = 3
	rate_up_lim = 5
	purity_min = 0.5
	reaction_flags = REACTION_PH_VOL_CONSTANT
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_DAMAGING | REACTION_TAG_ORGAN | REACTION_TAG_TOXIN

/datum/chemical_reaction/cyanide
	results = list(/datum/reagent/toxin/cyanide = 3)
	required_reagents = list(/datum/reagent/fuel/oil = 1, /datum/reagent/ammonia = 1, /datum/reagent/oxygen = 1)
	mix_message = "The mixture emits the faint smell of almonds."
	is_cold_recipe = FALSE
	required_temp = 380
	optimal_temp = 420
	overheat_temp = NO_OVERHEAT
	optimal_ph_min = 9
	optimal_ph_max = 11
	determin_ph_range = 3
	temp_exponent_factor = 0.7
	ph_exponent_factor = 2
	thermic_constant = -300
	H_ion_release = 3.2
	rate_up_lim = 10
	purity_min = 0.4
	reaction_flags = REACTION_PH_VOL_CONSTANT
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_DAMAGING | REACTION_TAG_OXY | REACTION_TAG_TOXIN

/datum/chemical_reaction/itching_powder
	results = list(/datum/reagent/toxin/itching_powder = 3)
	required_reagents = list(/datum/reagent/fuel = 1, /datum/reagent/ammonia = 1, /datum/reagent/medicine/c2/multiver = 1)
	mix_message = "The mixture emits nose-irritating fumes."
	is_cold_recipe = FALSE
	required_temp = 280
	optimal_temp = 360
	overheat_temp = 700
	optimal_ph_min = 5
	optimal_ph_max = 9
	determin_ph_range = 4
	temp_exponent_factor = 0.7
	ph_exponent_factor = 1.5
	thermic_constant = -200
	H_ion_release = 5.7
	rate_up_lim = 20
	purity_min = 0.3
	reaction_flags = REACTION_PH_VOL_CONSTANT
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_DAMAGING | REACTION_TAG_BRUTE

/datum/chemical_reaction/facid
	results = list(/datum/reagent/toxin/acid/fluacid = 4)
	required_reagents = list(/datum/reagent/toxin/acid = 1, /datum/reagent/fluorine = 1, /datum/reagent/hydrogen = 1, /datum/reagent/potassium = 1)
	mix_message = "The mixture bubbles fiercly."
	is_cold_recipe = FALSE
	required_temp = 380
	optimal_temp = 680
	overheat_temp = 800
	optimal_ph_min = 0
	optimal_ph_max = 2
	determin_ph_range = 5
	temp_exponent_factor = 2
	ph_exponent_factor = 10
	thermic_constant = -200
	H_ion_release = -25
	rate_up_lim = 20
	purity_min = 0.5
	reaction_flags = REACTION_PH_VOL_CONSTANT
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_DAMAGING | REACTION_TAG_PLANT | REACTION_TAG_BURN | REACTION_TAG_TOXIN

/datum/chemical_reaction/nitracid
	results = list(/datum/reagent/toxin/acid/nitracid = 2)
	required_reagents = list(/datum/reagent/toxin/acid/fluacid = 1, /datum/reagent/nitrogen = 1,  /datum/reagent/hydrogen_peroxide = 1)
	mix_message = "The mixture bubbles fiercly and gives off a pungent smell."
	is_cold_recipe = FALSE
	required_temp = 480
	optimal_temp = 680
	overheat_temp = 900
	optimal_ph_min = 0
	optimal_ph_max = 4.1
	determin_ph_range = 5
	temp_exponent_factor = 2
	ph_exponent_factor = 10
	thermic_constant = -200
	H_ion_release = -20
	rate_up_lim = 20
	purity_min = 0.5
	reaction_flags = REACTION_PH_VOL_CONSTANT
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_DAMAGING | REACTION_TAG_BURN | REACTION_TAG_TOXIN

/datum/chemical_reaction/sulfonal
	results = list(/datum/reagent/toxin/sulfonal = 3)
	required_reagents = list(/datum/reagent/acetone = 1, /datum/reagent/diethylamine = 1, /datum/reagent/sulfur = 1)
	mix_message = "The mixture changes color and becomes clear."
	is_cold_recipe = FALSE
	required_temp = 100
	optimal_temp = 450
	overheat_temp = 900
	optimal_ph_min = 4
	optimal_ph_max = 9
	determin_ph_range = 2
	temp_exponent_factor = 1.5
	ph_exponent_factor = 1.5
	thermic_constant = 200
	H_ion_release = 5
	rate_up_lim = 10
	purity_min = 0.5
	reaction_flags = REACTION_PH_VOL_CONSTANT
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_DAMAGING | REACTION_TAG_TOXIN | REACTION_TAG_OTHER

/datum/chemical_reaction/lipolicide
	results = list(/datum/reagent/toxin/lipolicide = 3)
	required_reagents = list(/datum/reagent/mercury = 1, /datum/reagent/diethylamine = 1, /datum/reagent/medicine/ephedrine = 1)
	mix_message = "The mixture becomes cloudy."
	is_cold_recipe = FALSE
	required_temp = 100
	optimal_temp = 450
	overheat_temp = 900
	optimal_ph_min = 4
	optimal_ph_max = 8.5
	determin_ph_range = 2
	temp_exponent_factor = 1
	ph_exponent_factor = 0.2
	thermic_constant = 500
	H_ion_release = 2.5
	rate_up_lim = 10
	purity_min = 0.7
	reaction_flags = REACTION_PH_VOL_CONSTANT
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_DAMAGING | REACTION_TAG_OTHER

/datum/chemical_reaction/mutagen
	results = list(/datum/reagent/toxin/mutagen = 3)
	required_reagents = list(/datum/reagent/uranium/radium = 1, /datum/reagent/phosphorus = 1, /datum/reagent/chlorine = 1)
	mix_message = "The mixture glows faintly, then stops."
	is_cold_recipe = FALSE
	required_temp = 100
	optimal_temp = 450
	overheat_temp = 900
	optimal_ph_min = 3
	optimal_ph_max = 9
	determin_ph_range = 1
	temp_exponent_factor = 2
	ph_exponent_factor = 5
	thermic_constant = 350
	H_ion_release = 0.1
	rate_up_lim = 10
	purity_min = 0.7
	reaction_flags = REACTION_PH_VOL_CONSTANT
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_DAMAGING | REACTION_TAG_PLANT | REACTION_TAG_OTHER

/datum/chemical_reaction/lexorin
	results = list(/datum/reagent/toxin/lexorin = 3)
	required_reagents = list(/datum/reagent/toxin/plasma = 1, /datum/reagent/hydrogen = 1, /datum/reagent/medicine/salbutamol = 1)
	mix_message = "The mixture turns clear and stops reacting."
	is_cold_recipe = FALSE
	required_temp = 100
	optimal_temp = 450
	overheat_temp = 900
	optimal_ph_min = 1.8
	optimal_ph_max = 7
	determin_ph_range = 3
	temp_exponent_factor = 2
	ph_exponent_factor = 5
	thermic_constant = -400
	H_ion_release = 0.1
	rate_up_lim = 25
	purity_min = 0.4
	reaction_flags = REACTION_PH_VOL_CONSTANT
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_DAMAGING | REACTION_TAG_OXY

/datum/chemical_reaction/hot_ice_melt
	results = list(/datum/reagent/toxin/plasma = 12) //One sheet of hot ice makes 200m of plasma
	required_reagents = list(/datum/reagent/toxin/hot_ice = 1)
	required_temp = T0C + 30 //Don't burst into flames when you melt
	thermic_constant = -200//Counter the heat
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_DAMAGING | REACTION_TAG_CHEMICAL | REACTION_TAG_TOXIN

/datum/chemical_reaction/chloralhydrate
	results = list(/datum/reagent/toxin/chloralhydrate = 1)
	required_reagents = list(/datum/reagent/consumable/ethanol = 1, /datum/reagent/chlorine = 3, /datum/reagent/water = 1)
	mix_message = "The mixture turns deep blue."
	is_cold_recipe = FALSE
	required_temp = 200
	optimal_temp = 450
	overheat_temp = 900
	optimal_ph_min = 7
	optimal_ph_max = 9
	determin_ph_range = 2
	temp_exponent_factor = 2
	ph_exponent_factor = 2
	thermic_constant = 250
	H_ion_release = 2
	rate_up_lim = 10
	purity_min = 0.6
	reaction_flags = REACTION_PH_VOL_CONSTANT
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_DAMAGING | REACTION_TAG_OTHER

/datum/chemical_reaction/mutetoxin //i'll just fit this in here snugly between other unfun chemicals :v
	results = list(/datum/reagent/toxin/mutetoxin = 2)
	required_reagents = list(/datum/reagent/uranium = 2, /datum/reagent/water = 1, /datum/reagent/carbon = 1)
	mix_message = "The mixture calms down."
	is_cold_recipe = FALSE
	required_temp = 100
	optimal_temp = 450
	overheat_temp = 900
	optimal_ph_min = 6
	optimal_ph_max = 14
	determin_ph_range = 2
	temp_exponent_factor = 3
	ph_exponent_factor = 1
	thermic_constant = -250
	H_ion_release = -0.2
	rate_up_lim = 15
	purity_min = 0.4
	reaction_flags = REACTION_PH_VOL_CONSTANT
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_DAMAGING | REACTION_TAG_OTHER

/datum/chemical_reaction/zombiepowder
	results = list(/datum/reagent/toxin/zombiepowder = 2)
	required_reagents = list(/datum/reagent/toxin/carpotoxin = 5, /datum/reagent/medicine/morphine = 5, /datum/reagent/copper = 5)
	mix_message = "The mixture turns into a strange green powder."
	is_cold_recipe = FALSE
	required_temp = 100
	optimal_temp = 450
	overheat_temp = 900
	optimal_ph_min = 5
	optimal_ph_max = 14
	determin_ph_range = 2
	temp_exponent_factor = 3
	ph_exponent_factor = 1
	thermic_constant = 150
	H_ion_release = -0.25
	rate_up_lim = 15
	purity_min = 0.3
	reaction_flags = REACTION_CLEAR_IMPURE
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_DAMAGING | REACTION_TAG_OTHER

/datum/chemical_reaction/ghoulpowder
	results = list(/datum/reagent/toxin/ghoulpowder = 2)
	required_reagents = list(/datum/reagent/toxin/zombiepowder = 1, /datum/reagent/medicine/epinephrine = 1)
	mix_message = "The mixture turns into a strange brown powder."
	is_cold_recipe = FALSE
	required_temp = 100
	optimal_temp = 450
	overheat_temp = 900
	optimal_ph_min = 5
	optimal_ph_max = 14
	determin_ph_range = 2
	temp_exponent_factor = 3
	ph_exponent_factor = 1
	thermic_constant = 150
	H_ion_release = -0.25
	rate_up_lim = 15
	purity_min = 0.4
	reaction_flags = REACTION_PH_VOL_CONSTANT
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_DAMAGING | REACTION_TAG_OTHER

/datum/chemical_reaction/mindbreaker
	results = list(/datum/reagent/toxin/mindbreaker = 5)
	required_reagents = list(/datum/reagent/silicon = 1, /datum/reagent/hydrogen = 1, /datum/reagent/medicine/c2/multiver = 1)
	mix_message = "The mixture turns into a vivid red liquid."
	is_cold_recipe = FALSE
	required_temp = 100
	optimal_temp = 450
	overheat_temp = 900
	optimal_ph_min = 6
	optimal_ph_max = 14
	determin_ph_range = 3
	temp_exponent_factor = 2.5
	ph_exponent_factor = 2
	thermic_constant = 150
	H_ion_release = -0.06
	rate_up_lim = 15
	purity_min = 0.4
	reaction_flags = REACTION_CLEAR_IMPURE
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_DAMAGING | REACTION_TAG_OTHER

/datum/chemical_reaction/heparin
	results = list(/datum/reagent/toxin/heparin = 4)
	required_reagents = list(/datum/reagent/toxin/formaldehyde = 1, /datum/reagent/sodium = 1, /datum/reagent/chlorine = 1, /datum/reagent/lithium = 1)
	mix_message = "<span class='danger'>The mixture thins and loses all color.</span>"
	is_cold_recipe = FALSE
	required_temp = 100
	optimal_temp = 450
	overheat_temp = 800
	optimal_ph_min = 5
	optimal_ph_max = 9.5
	determin_ph_range = 3
	temp_exponent_factor = 2.5
	ph_exponent_factor = 2
	thermic_constant = 375
	H_ion_release = -0.6
	rate_up_lim = 10
	purity_min = 0.6
	reaction_flags = REACTION_PH_VOL_CONSTANT
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_DAMAGING | REACTION_TAG_OTHER

/datum/chemical_reaction/rotatium
	results = list(/datum/reagent/toxin/rotatium = 3)
	required_reagents = list(/datum/reagent/toxin/mindbreaker = 1, /datum/reagent/teslium = 1, /datum/reagent/toxin/fentanyl = 1)
	mix_message = "<span class='danger'>After sparks, fire, and the smell of mindbreaker, the mix is constantly spinning with no stop in sight.</span>"
	is_cold_recipe = FALSE
	required_temp = 100
	optimal_temp = 450
	overheat_temp = 900
	optimal_ph_min = 3
	optimal_ph_max = 9
	determin_ph_range = 2.5
	temp_exponent_factor = 2.5
	ph_exponent_factor = 2
	thermic_constant = -425
	H_ion_release = 4
	rate_up_lim = 15
	purity_min = 0.6
	reaction_flags = REACTION_PH_VOL_CONSTANT
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_DAMAGING | REACTION_TAG_TOXIN | REACTION_TAG_OTHER

/datum/chemical_reaction/anacea
	results = list(/datum/reagent/toxin/anacea = 3)
	required_reagents = list(/datum/reagent/medicine/haloperidol = 1, /datum/reagent/impedrezene = 1, /datum/reagent/uranium/radium = 1)
	mix_message = "The mixture turns into a strange green ooze."
	is_cold_recipe = FALSE
	required_temp = 100
	optimal_temp = 450
	overheat_temp = 900
	optimal_ph_min = 6
	optimal_ph_max = 9
	determin_ph_range = 4
	temp_exponent_factor = 1.6
	ph_exponent_factor = 2.4
	thermic_constant = 250
	H_ion_release = 3
	rate_up_lim = 10
	purity_min = 0.7
	reaction_flags = REACTION_PH_VOL_CONSTANT
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_DAMAGING | REACTION_TAG_TOXIN | REACTION_TAG_OTHER

/datum/chemical_reaction/mimesbane
	results = list(/datum/reagent/toxin/mimesbane = 3)
	required_reagents = list(/datum/reagent/uranium/radium = 1, /datum/reagent/toxin/mutetoxin = 1, /datum/reagent/consumable/nothing = 1)
	mix_message = "The mixture turns into an indescribable white."
	is_cold_recipe = FALSE
	required_temp = 100
	optimal_temp = 450
	overheat_temp = 900
	optimal_ph_min = 0
	optimal_ph_max = 8
	determin_ph_range = 4
	temp_exponent_factor = 1.5
	ph_exponent_factor = 3
	thermic_constant = -400
	H_ion_release = -2
	rate_up_lim = 15
	purity_min = 0.5
	reaction_flags = REACTION_PH_VOL_CONSTANT
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_DAMAGING | REACTION_TAG_OTHER

/datum/chemical_reaction/bonehurtingjuice
	results = list(/datum/reagent/toxin/bonehurtingjuice = 5)
	required_reagents = list(/datum/reagent/toxin/mutagen = 1, /datum/reagent/toxin/itching_powder = 3, /datum/reagent/consumable/milk = 1)
	mix_message = "<span class='danger'>The mixture suddenly becomes clear and looks a lot like water. You feel a strong urge to drink it.</span>"
	is_cold_recipe = FALSE
	required_temp = 100
	optimal_temp = 450
	overheat_temp = 900
	optimal_ph_min = 5
	optimal_ph_max = 9
	determin_ph_range = 3
	temp_exponent_factor = 0.5
	ph_exponent_factor = 1
	thermic_constant = -400
	H_ion_release = -0.4
	rate_up_lim = 15
	purity_min = 0.4
	reaction_flags = REACTION_PH_VOL_CONSTANT
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_DAMAGING | REACTION_TAG_OTHER

/datum/chemical_reaction/aus
	results = list(/datum/reagent/toxin/aus = 6)
	required_reagents = list(/datum/reagent/medicine/ephedrine = 4, /datum/reagent/consumable/ethanol = 2, /datum/reagent/lithium = 2)
	required_temp = 430
	centrifuge_recipe = TRUE

/datum/chemical_reaction/impalco
	results = list(/datum/reagent/consumable/ethanol/impalco = 5)
	required_reagents = list(/datum/reagent/toxin/aus = 2, /datum/reagent/consumable/ethanol = 3, /datum/reagent/drug/methamphetamine = 2)
	required_pressure = 5

/datum/chemical_reaction/alco
	results = list(/datum/reagent/consumable/ethanol/alco = 6, /datum/reagent/consumable/ethanol = 6)
	required_reagents = list(/datum/reagent/consumable/ethanol/impalco = 3, /datum/reagent/consumable/ethanol = 3, /datum/reagent/consumable/ethanol/isopropyl = 3)
	centrifuge_recipe = TRUE

/datum/chemical_reaction/emote
	results = list(/datum/reagent/toxin/emote = 5)
	required_reagents = list(/datum/reagent/medicine/synaptizine = 1, /datum/reagent/consumable/sugar = 2, /datum/reagent/ammonia = 1)
	required_catalysts = list(/datum/reagent/toxin/mutagen = 1)
	centrifuge_recipe = TRUE

/datum/chemical_reaction/over_reactible/bear
	results = list(/datum/reagent/toxin/bear = 4, /datum/reagent/toxin/radgoop = 2)
	required_reagents = list(/datum/reagent/medicine/liquid_life = 2, /datum/reagent/volt = 3, /datum/reagent/medicine/ephedrine = 1)
	required_temp = 460
	bluespace_recipe = TRUE
	can_overheat = TRUE
	overheat_temp = 1000
	exothermic_gain = 350

/datum/chemical_reaction/methphos
	results = list(/datum/reagent/toxin/methphos = 4)
	required_reagents = list(/datum/reagent/hydrogen = 3, /datum/reagent/carbon = 1, /datum/reagent/phosphorus = 1, /datum/reagent/oxygen = 1, /datum/reagent/fluorine = 2)
	required_pressure = 26

/datum/chemical_reaction/sarin_a
	results = list(/datum/reagent/toxin/sarin_a = 3)
	required_reagents = list(/datum/reagent/consumable/ethanol/isopropyl = 3, /datum/reagent/toxin/methphos = 2)

/datum/chemical_reaction/sarin_b
	results = list(/datum/reagent/toxin/sarin_b = 2)
	required_temp = 700
	required_pressure = 5
	required_reagents = list(/datum/reagent/toxin/sarin_a = 2)

/datum/chemical_reaction/over_reactible/sarin
	results = list(/datum/reagent/toxin/sarin = 3)
	can_overheat = TRUE
	can_overpressure = TRUE//hehehe quickest way to get killed as a lunatic chemist
	overheat_temp = 450
	overpressure_threshold = 100
	centrifuge_recipe = TRUE
	required_pressure = 95
	required_reagents = list(/datum/reagent/toxin/sarin_b = 6)

/datum/chemical_reaction/tabun_pa
	results = list(/datum/reagent/toxin/tabun_pa = 4, /datum/reagent/oxygen = 2)
	required_reagents = list(/datum/reagent/sodium = 1, /datum/reagent/water = 3, /datum/reagent/carbon = 2, /datum/reagent/nitrogen = 1)
	required_temp = 420

/datum/chemical_reaction/tabun_pb
	results = list(/datum/reagent/toxin/tabun_pb = 1)
	required_reagents = list(/datum/reagent/chlorine = 3, /datum/reagent/phosphorus = 1, /datum/reagent/oxygen = 1)

/datum/chemical_reaction/tabun_pc
	results = list(/datum/reagent/toxin/tabun_pc = 2)
	required_reagents = list(/datum/reagent/toxin/tabun_pb = 2, /datum/reagent/toxin/tabun_pa = 2)

/datum/chemical_reaction/tabun
	results = list(/datum/reagent/toxin/tabun = 1, /datum/reagent/toxin/goop = 9)
	required_reagents = list(/datum/reagent/toxin/tabun_pc = 3)
	centrifuge_recipe = TRUE

/datum/chemical_reaction/impgluco
	results = list(/datum/reagent/toxin/impgluco = 1)
	required_temp = 170
	required_pressure = 45
	required_reagents = list(/datum/reagent/consumable/sugar = 3, /datum/reagent/consumable/ethanol/isopropyl = 1, /datum/reagent/consumable/salt = 1)

/datum/chemical_reaction/gluco
	results = list(/datum/reagent/toxin/gluco = 1)
	required_temp = 120
	is_cold_recipe = TRUE
	required_pressure = 85
	required_reagents = list(/datum/reagent/toxin/impgluco = 2, /datum/reagent/cryogenic_fluid = 1)
	centrifuge_recipe = TRUE

/datum/chemical_reaction/over_reactible/screech
	results = list(/datum/reagent/toxin/screech = 3)
	can_overheat = TRUE
	required_temp = 750
	required_pressure = 30
	overheat_temp = 775
	required_reagents = list(/datum/reagent/toxin/emote = 3, /datum/reagent/medicine/ephedrine = 1)

/datum/chemical_reaction/stablemutationtoxin
	results = list(/datum/reagent/mutationtoxin = 1)
	required_reagents = list(/datum/reagent/unstablemutationtoxin = 1, /datum/reagent/blood = 1)

/datum/chemical_reaction/lizardmutationtoxin
	results = list(/datum/reagent/mutationtoxin/lizard = 1)
	required_reagents = list(/datum/reagent/unstablemutationtoxin = 1, /datum/reagent/uranium/radium = 1)

/datum/chemical_reaction/flymutationtoxin
	results = list(/datum/reagent/mutationtoxin/fly = 1)
	required_reagents = list(/datum/reagent/unstablemutationtoxin = 1, /datum/reagent/toxin/mutagen = 1)

/datum/chemical_reaction/jellymutationtoxin
	results = list(/datum/reagent/mutationtoxin/jelly = 1)
	required_reagents = list(/datum/reagent/unstablemutationtoxin = 1, /datum/reagent/toxin/slimejelly = 1)

/datum/chemical_reaction/podmutationtoxin
	results = list(/datum/reagent/mutationtoxin/pod = 1)
	required_reagents = list(/datum/reagent/unstablemutationtoxin = 1, /datum/reagent/plantnutriment/eznutriment = 1)

/datum/chemical_reaction/golemmutationtoxin
	results = list(/datum/reagent/mutationtoxin/golem = 1)
	required_reagents = list(/datum/reagent/unstablemutationtoxin = 1, /datum/reagent/silver = 1)

/datum/chemical_reaction/abductormutationtoxin
	results = list(/datum/reagent/mutationtoxin/abductor = 1)
	required_reagents = list(/datum/reagent/unstablemutationtoxin = 1, /datum/reagent/medicine/morphine = 1)

/datum/chemical_reaction/androidmutationtoxin
	results = list(/datum/reagent/mutationtoxin/android = 1)
	required_reagents = list(/datum/reagent/unstablemutationtoxin = 1, /datum/reagent/teslium = 1)

/datum/chemical_reaction/skeletonmutationtoxin
	results = list(/datum/reagent/mutationtoxin/skeleton = 1)
	required_reagents = list(/datum/reagent/unstablemutationtoxin = 1, /datum/reagent/consumable/milk = 1)

/datum/chemical_reaction/zombiemutationtoxin
	results = list(/datum/reagent/mutationtoxin/zombie = 1)
	required_reagents = list(/datum/reagent/unstablemutationtoxin = 1, /datum/reagent/toxin = 1)

/datum/chemical_reaction/ashmutationtoxin
	results = list(/datum/reagent/mutationtoxin/ash = 1)
	required_reagents = list(/datum/reagent/unstablemutationtoxin = 1, /datum/reagent/mutationtoxin/lizard = 1, /datum/reagent/ash = 1)

/datum/chemical_reaction/shadowmutationtoxin
	results = list(/datum/reagent/mutationtoxin/shadow = 1)
	required_reagents = list(/datum/reagent/unstablemutationtoxin = 1, /datum/reagent/liquid_dark_matter = 1, /datum/reagent/water/holywater = 1)

/datum/chemical_reaction/plasmamutationtoxin
	results = list(/datum/reagent/mutationtoxin/plasma = 1)
	required_reagents = list(/datum/reagent/unstablemutationtoxin = 1, /datum/reagent/uranium = 1, /datum/reagent/toxin/plasma = 1)

/datum/chemical_reaction/carbonf
	results = list(/datum/reagent/toxin/carbonf = 4)
	required_reagents = list(/datum/reagent/consumable/ethanol = 4, /datum/reagent/fluorine = 2)
	required_temp = 320
	reaction_tags = REACTION_TAG_TOXIN | REACTION_TAG_DAMAGING

/datum/chemical_reaction/bleach
	results = list(/datum/reagent/toxin/bleach = 3)
	required_reagents = list(/datum/reagent/space_cleaner = 1, /datum/reagent/sodium = 1, /datum/reagent/chlorine = 1)
