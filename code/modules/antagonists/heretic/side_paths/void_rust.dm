/datum/eldritch_knowledge/armor
	name = "Armorer's Ritual"
	desc = "You can now create Eldritch Armor using a table and a gas mask."
	gain_text = "The Rusted Hills welcomed the Blacksmith in their generosity."
	cost = 1
	next_knowledge = list(/datum/eldritch_knowledge/rust_regen,/datum/eldritch_knowledge/cold_snap)
	required_atoms = list(/obj/structure/table,/obj/item/clothing/mask/gas)
	result_atoms = list(/obj/item/clothing/suit/hooded/cultrobes/eldritch)

/datum/eldritch_knowledge/crucible
	name = "Mawed Crucible"
	gain_text = "This is pure agony, i wasn't able to summon the dereliction of the emperor, but i stumbled upon a diffrent recipe..."
	desc = "Allows you to create a mawed crucible, eldritch structure that allows you to create potions of various effects, to do so transmute a table with a watertank"
	cost = 1
	next_knowledge = list(/datum/eldritch_knowledge/spell/void_phase,/datum/eldritch_knowledge/spell/area_conversion)
	required_atoms = list(/obj/structure/reagent_dispensers/watertank,/obj/structure/table)
	result_atoms = list(/obj/structure/eldritch_crucible)

/datum/eldritch_knowledge/summon/rusty
	name = "Rusted Ritual"
	gain_text = "I combined my principle of hunger with my desire for corruption. And the Rusted Hills called my name."
	desc = "You can now summon a Rust Walker by transmutating a vomit pool, a severed head and a book."
	cost = 1
	required_atoms = list(/obj/effect/decal/cleanable/vomit,/obj/item/book,/obj/item/bodypart/head)
	mob_to_summon = /mob/living/simple_animal/hostile/eldritch/rust_spirit
	next_knowledge = list(/datum/eldritch_knowledge/spell/voidpull,/datum/eldritch_knowledge/spell/entropic_plume)
