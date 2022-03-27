// to add
// target gene generation done
// some default target genes
// gene proteins (like 3 - 4 for hulk and stuff)
// a gene that interacts with tumors
// more generalized conditional gene
// maybe start to work on protein genes for enzymes (chem fabrication)
GLOBAL_LIST_EMPTY_TYPED(all_target_genes, /datum/gene_frame/target)
GLOBAL_LIST_EMPTY_TYPED(all_conditional_genes, /datum/gene_frame/conditional)
GLOBAL_LIST_EMPTY_TYPED(all_protein_genes, /datum/gene_frame/protein)

#define NUM_TARGET_GENES 50
#define MAX_TARGETS 4

/datum/gene_frame/conditional/chem
    var/chem = /datum/reagent/consumable/ethanol
    name = "chemical awaiter"
    desc = "Causes DNA to produce proteins that bind to and detect a chemical before activating further protein creation."

/datum/gene_frame/conditional/chem/binary_condition(obj/item/organ/organ)
    return TRUE

/datum/gene_frame/conditional/chem/conditional_strength(obj/item/organ/organ)
    var/mob/living/carbon/owner = organ.owner
    var/amount = 0.0
    for(var/datum/reagent/R in owner?.reagents.reagent_list)
        if(R.type == chem)
            amount = R.volume
    return (amount / 10.0) * epigenetic_strength

/datum/gene_frame/protein/chem
    //var/datum/reagent/chem = /datum/reagent/consumable/ethanol
    name = "enzymitic producer"
    var/chem = "ethanol"
    var/conversion_rate = 0.1
    desc = "Creates enzymes that create a certain chemical"

/datum/gene_frame/protein/chem/life_act(obj/item/organ/organ, strength)
    . = ..()
    if(!organ.reagents)
        return
    organ.reagents.add_reagent(chem, conversion_rate * strength)
    organ.owner.adjust_nutrition(-strength)

/datum/gene_frame/protein/chem_transfer
    var/chem = "ethanol"
    var/conversion_rate = 0.1
    name = "chem transfer"
    desc = "Creates thin sections of proteins that allow passage of a protein"

/datum/gene_frame/protein/chem_transfer/life_act(obj/item/organ/organ, strength)
    . = ..()
    var/amount = 0.0
    if(!organ.reagents)
        return
    for(var/datum/reagent/R in organ.owner?.reagents.reagent_list)
        if(get_chem_id(R.type) == chem)
            amount = R.volume
    if(amount > 1.0)
    organ.reagents.remove_reagent(chem, amount)
    organ.owner.reagents.add_reagent(chem, amount)

/datum/controller/subsystem/atoms/proc/setupNuGenetics()
    //GLOB.all_target_genes += subtypesof(/datum/gene_frame/target)
    for(var/T in subtypesof(/datum/gene_frame/target))
        GLOB.all_target_genes += list(new T)
    for(var/i in 1 to NUM_TARGET_GENES) // generation part
        var/datum/gene_frame/target/T = new
        T.name = ""
        for(var/j in 1 to rand(1, MAX_TARGETS))
            while(TRUE)
                var/organ = GLOB.valid_genetarget_slots[rand(1, GLOB.valid_genetarget_slots.len)]
                if(organ in T.organ_slots)
                    continue
                var/organ_power = rand()
                T.organ_slots += list(organ)
                T.organ_slot_strengths += list(organ = organ_power)
                T.name += organ // will be replaced with actual names
                break
        GLOB.all_target_genes += list(T)

    //GLOB.all_conditional_genes += subtypesof(/datum/gene_frame/conditional)
    for(var/T in subtypesof(/datum/gene_frame/conditional))
        GLOB.all_conditional_genes += list(new T)
    
    for(var/type in subtypesof(/datum/reagent))
        var/datum/gene_frame/conditional/chem/G = new

        G.chem = type
        var/datum/reagent/R = new type
        //G.chem = get_chem_id(R.name)
        G.name = R.name
        del R
        GLOB.all_conditional_genes += list(G)
    
    //GLOB.all_protein_genes += subtypesof(/datum/gene_frame/protein)
    for(var/T in subtypesof(/datum/gene_frame/protein))
        GLOB.all_protein_genes += list(new T)
        
    for(var/type in subtypesof(/datum/reagent))
        var/datum/gene_frame/protein/chem/G = new

        //G.chem = type
        var/datum/reagent/R = new type
        G.chem = get_chem_id(R.name)
        G.name = R.name
        del R
        GLOB.all_protein_genes += list(G)
        
    for(var/type in subtypesof(/datum/reagent))
        var/datum/gene_frame/protein/chem_transfer/G = new

        //G.chem = type
        var/datum/reagent/R = new type
        G.chem = get_chem_id(R.name)
        G.name = R.name
        del R
        GLOB.all_protein_genes += list(G)

/datum/gene_frame/protein/reagent_holder
    name = "reagentinium"
    desc = "Allows an organ or tumor to hold reagents"

/datum/gene_frame/protein/reagent_holder/apply_act(obj/item/organ/organ)
    . = ..()
    organ.reagents = new
    AddComponent(organ, /datum/component/genetic_reagent_holder)
