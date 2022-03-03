/datum/gene_frame/target/heart_brain_tumor
    name = "cardiomyelasis"
    organ_slots = list(ORGAN_SLOT_HEART, ORGAN_SLOT_BRAIN, ORGAN_SLOT_ETUMOR3)
    organ_slot_strengths = list(ORGAN_SLOT_HEART = 1.0, ORGAN_SLOT_BRAIN = 0.3, ORGAN_SLOT_ETUMOR3 = 0.5)

/datum/gene_frame/protein/organ_healing
    name = "enterosanitatium"

/datum/gene_frame/protein/organ_healing/life_act(obj/item/organ/organ)
    . = ..()
    organ.applyOrganDamage(-1)

/datum/gene_frame/protein/organ_healing/tumor_create_act(organ_slot)
    var/obj/item/organ/external/O = new /obj/item/organ/external/tumor/head
    O.slot = organ_slot
    return O

/datum/gene_frame/conditional/meth
    name = "alphamethyletium"

/datum/gene_frame/conditional/meth/binary_condition(obj/item/organ/organ)
    var/mob/living/carbon/owner = organ.owner
    var/meth_amount = 0.0
    //owner.reagents[/datum/reagent/drug/methamphetamine]
    for(var/datum/reagent/R in owner?.reagents.reagent_list)
        if(R.type == /datum/reagent/drug/methamphetamine)
            meth_amount = R.volume
    return (meth_amount > 8)

/datum/gene_frame/conditional/meth/conditional_strength(obj/item/organ/organ)
    return 1.0

/datum/gene/test_gene
    target_frames = list(new /datum/gene_frame/target/heart_brain_tumor)
    conditional_frames = list(new /datum/gene_frame/conditional/meth)
    protein_frames = list(new /datum/gene_frame/protein/organ_healing)
    epigenetic_strength = 1.0

