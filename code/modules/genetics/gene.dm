/datum/gene
    var/list/target_frames
    var/list/conditional_frames
    var/list/protein_frames
    var/epigenetic_strength = 1.0
    var/name

/datum/gene/proc/tumor_create_act(organ_slot)
    return new /obj/item/organ/external/tumor/head

/datum/gene_frame
    var/frame_type
    var/name
    var/list/composed_gene_frames
    var/parent_gene

/datum/gene_frame/proc/can_compose_with(datum/gene_frame/C)
    return FALSE

/datum/gene_frame/target
    frame_type = "target"
    var/list/organ_slots
    var/list/organ_slot_strengths // pairs of (organ_slot = strength)

/datum/gene_frame/protein
    frame_type = "protein"

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
/datum/gene_frame/protein/proc/life_act(obj/item/organ/organ)
    return

/datum/gene_frame/conditional
    frame_type = "conditional"

// why two of them? they have different uses; one is to outright toggle the genetic expression off
/datum/gene_frame/conditional/proc/binary_condition(obj/item/organ/organ)
    return FALSE

/datum/gene_frame/conditional/proc/conditional_strength(obj/item/organ/organ)
    return 0.0

/datum/gene_frame/conditional/proc/apply_act(obj/item/organ/organ)
    return

// don't forget to remove your signals
/datum/gene_frame/conditional/proc/remove_act(obj/item/organ/organ)
    return
