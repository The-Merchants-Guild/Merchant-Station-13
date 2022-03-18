// increase or remove this limit if it turns out it's unnecessary
#define MAX_GENE_LIMIT 10
#define DEFAULT_GENE_STRENGTH 1.0
#define TUMOR_GROWTH_RATE 0.2 
#define APPLY_STR_THRSH 30
// temporarily 0, to study the effect of tumors
#define TUMOR_CREATE_THRSH 0
#define GENE_APPLY_THRSH 1.0

/datum/gene
    var/list/target_frames
    var/list/conditional_frames
    var/list/protein_frames
    var/epigenetic_strength = DEFAULT_GENE_STRENGTH
    var/name = "gene"
    var/desc = ""
    // different from epigenetic strength, which determines how much growth factor increases the expression strength, while this one determines effect strength (if at all)
    var/expr_strength = 0.0 

/datum/gene/proc/tumor_create_act(organ_slot)
    return new /obj/item/organ/external/tumor/head

/datum/gene_frame
    var/frame_type
    var/name = "gene_frame"
    var/desc = ""
    var/list/composed_gene_frames
    var/parent_gene
    var/min_expression = DEFAULT_GENE_STRENGTH

/datum/gene_frame/proc/can_compose_with(datum/gene_frame/C)
    return FALSE

/datum/gene_frame/target
    frame_type = "target"
    var/list/organ_slots
    var/list/organ_slot_strengths // pairs of (organ_slot = strength)

/datum/gene_frame/protein
    frame_type = "protein"
    var/applied = FALSE
    expr_strength = 1.0

// maybe this should be handled on the gene side directly - can't decide today, will decide tomorrow
/datum/gene_frame/protein/proc/tumor_create_act(organ_slot)
    return new /obj/item/organ/external/tumor/head

// original instantiation onto an existing organ or tumor; should be called right after tumor_create_act - git blame me if I'm dumb and didn't do that
// ideally this is where you should be applying stuff like hulking out or getting abilities, telekinesis etc - though sometimes there might be treshholds; tread lightly
/datum/gene_frame/protein/proc/apply_act(obj/item/organ/organ)
    return
    
// don't forget to remove your signals
/datum/gene_frame/protein/proc/remove_act(obj/item/organ/organ)
    return

// called when growth factors act on the parent
/datum/gene_frame/protein/proc/growth_act(obj/item/organ/organ, growth_strength)
    return

// called on_life
/datum/gene_frame/protein/proc/life_act(obj/item/organ/organ, strength)
    return

/datum/gene_frame/conditional
    frame_type = "conditional"

// why two of them? they have different uses; one is to outright toggle the genetic expression off
/datum/gene_frame/conditional/proc/binary_condition(obj/item/organ/organ)
    // TODO: implement so it automatically looks through composed conditionals to implement an 'and'
    return FALSE

/datum/gene_frame/conditional/proc/conditional_strength(obj/item/organ/organ)
    return 1.0

/datum/gene_frame/conditional/proc/apply_act(obj/item/organ/organ)
    return

// don't forget to remove your signals
/datum/gene_frame/conditional/proc/remove_act(obj/item/organ/organ)
    return

/datum/dna/proc/add_gene(datum/gene/G)
    if(genes.len < MAX_GENE_LIMIT)
        genes += G

/mob/living/carbon/proc/add_gene(datum/gene/G)
    if(!has_dna())
        return
    dna.add_gene(G)

/mob/living/carbon/proc/calculate_growth_factor()
    var/growth_factor = 0.0
    for(var/datum/reagent/R in reagents.reagent_list)
        if(R.type == /datum/reagent/toxin/mutagen)
            growth_factor += 1.0 // TODO: probably move this to being a reagent property, so that it's cleaner?
    return growth_factor

/mob/living/carbon/proc/process_genes(delta_time, times_fired)
    if(!has_dna())
        return
    
    var/growth_factor = calculate_growth_factor() * delta_time

    for(var/slot in GLOB.organ_slots_etumors)
        var/obj/item/organ/external/tumor/tumor = getorganslot(slot)
        if(tumor)
            tumor.growth_act(growth_factor * TUMOR_GROWTH_RATE)

    for(var/datum/gene/G in dna.genes)
        G.expr_strength += growth_factor
        process_gene_effects(G, growth_factor)

/mob/living/carbon/proc/process_gene_effects(datum/gene/G, growth_factor)
    var/list/targets = list()
    // compile gene targets, with their strengths
    for(var/datum/gene_frame/target/T in G.target_frames)
        for(var/tgt in T.organ_slot_strengths)
            if(targets?[tgt])
                targets[tgt] += T.organ_slot_strengths[tgt]
            else targets[tgt] = T.organ_slot_strengths[tgt]
    // process each gene target individually
    for(var/T in targets)
        var/obj/item/organ/organ = getorganslot(T)
        var/slot_strength = targets[T]
        if(slot_strength < 0) continue

        if(!organ && slot_strength * growth_factor * G.epigenetic_strength > TUMOR_CREATE_THRSH)
            var/obj/item/organ/new_organ = G.protein_frames[1].tumor_create_act(T)
            new_organ.Insert(src)
            organ = new_organ
        
        if(!organ)
            continue

        // calculate conditionals
        var/cond_strength = -0.00001 //eps fuck you
        for(var/datum/gene_frame/conditional/C in G.conditional_frames)
            if(C.binary_condition(organ))
                cond_strength += C.conditional_strength(organ)
        if(len(G.conditional_frames) == 0)
            cond_strength = 1.0

        if(cond_strength < 0)
            continue
        
        for(var/datum/gene_frame/protein/P in G.protein_frames)
            if(slot_strength * growth_factor * G.epigenetic_strength * P.expr_strength > GENE_APPLY_THRSH)
                P.apply_act(organ)
                P.applied = TRUE
            if(P.applied)
                P.growth_act(organ)
            P.life_act(organ, G.epigenetic_strength * slot_strength)
