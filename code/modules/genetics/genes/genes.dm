// to add
// target gene generation
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

/datum/controller/subsystem/atoms/proc/setupNuGenetics()
    for(var/i in 1 to NUM_TARGET_GENES)
        var/datum/gene_frame/target/T = new
        T.name = ""
        for(var/j in 1 to rand(1, MAX_TARGETS))
            var/organ = GLOB.valid_genetarget_slots[rand(1, GLOB.valid_genetarget_slots.len)]
            var/organ_power = rand()
            T.organ_slots += list(organ)
            T.organ_slot_strengths[organ] = organ_power
            T.name += organ // will be replaced with actual names
        GLOB.all_target_genes += list(T)
