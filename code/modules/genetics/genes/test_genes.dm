/datum/gene_frame/target/heart_brain_tumor
    name = "cardiomyelasis"
    organ_slots = list(ORGAN_SLOT_HEART, ORGAN_SLOT_BRAIN, ORGAN_SLOT_ETUMOR3)
    organ_slot_strengths = list(ORGAN_SLOT_HEART = 1.0, ORGAN_SLOT_BRAIN = 0.3, ORGAN_SLOT_ETUMOR3 = 0.5)

/datum/gene_frame/protein/organ_healing
    name = "enterosanitatium"

/datum/gene_frame/protein/organ_healing/life_act(obj/item/organ/organ, strength)
    . = ..()
    organ.applyOrganDamage(-1 * strength)

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

/obj/item/test_gene_injector
    name = "\improper DNA injector"
    desc = "This injects the person with DNA."
    icon = 'icons/obj/items_and_weapons.dmi'
    icon_state = "dnainjector"
    worn_icon_state = "pen"
    lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
    righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
    throw_speed = 3
    throw_range = 5
    w_class = WEIGHT_CLASS_TINY

    var/damage_coeff  = 1
    var/list/fields
    var/list/add_mutations = list()
    var/list/remove_mutations = list()

    var/used = 0

/obj/item/test_gene_injector/proc/inject(mob/living/carbon/M, mob/user)
    if(M.has_dna() && !HAS_TRAIT(M, TRAIT_GENELESS) && !HAS_TRAIT(M, TRAIT_BADDNA))
        M.dna.genes += new /datum/gene/test_gene
        return TRUE
    return FALSE

/obj/item/test_gene_injector/attack(mob/target, mob/user)
    if(!ISADVANCEDTOOLUSER(user))
        to_chat(user, span_warning("You don't have the dexterity to do this!"))
        return
    if(used)
        to_chat(user, span_warning("This injector is used up!"))
        return
    if(ishuman(target))
        var/mob/living/carbon/human/humantarget = target
        if (!humantarget.try_inject(user, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE))
            return
    log_combat(user, target, "attempted to inject", src)

    if(target != user)
        target.visible_message(span_danger("[user] is trying to inject [target] with [src]!"), \
            span_userdanger("[user] is trying to inject you with [src]!"))
        if(!do_mob(user, target) || used)
            return
        target.visible_message(span_danger("[user] injects [target] with the syringe with [src]!"), \
                        span_userdanger("[user] injects you with the syringe with [src]!"))

    else
        to_chat(user, span_notice("You inject yourself with [src]."))

    log_combat(user, target, "injected", src)

    if(!inject(target, user)) //Now we actually do the heavy lifting.
        to_chat(user, span_notice("It appears that [target] does not have compatible DNA."))

    used = 1
    icon_state = "dnainjector0"
    desc += " This one is used up."
