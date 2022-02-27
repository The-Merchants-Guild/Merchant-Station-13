/datum/component/gene_editable
    var/test

/datum/component/gene_editable/Initialize(...)
    if(!parent)
        return COMPONENT_INCOMPATIBLE
    RegisterSignal(parent, COMSIG_LIVING_LIFE, .proc/on_life)

/datum/component/proc/on_life(delta_time, times_fired)
    return

/obj/item/organ/tumor
    name = "tumor"
    icon = 'icons/mob/genetics/tumors.dmi'
    /// the actual slot used is dynamic
    slot = ORGAN_SLOT_ITUMOR1
    zone = BODY_ZONE_CHEST
    var/tumor_size = 0.0

/obj/item/organ/external/tumor
    name = "tumor"
    icon = 'icons/mob/genetics/tumors.dmi'
    icon_state = "m__head_FRONT"
    organ_flags = ORGAN_EDIBLE
    /// the actual slot used is dynamic
    slot = ORGAN_SLOT_ETUMOR1
    zone = BODY_ZONE_CHEST
    sprite_datum = new /datum/sprite_accessory/tumor/head
    layers = EXTERNAL_BEHIND | EXTERNAL_FRONT
    var/tumor_size = 0.0

/obj/item/organ/external/tumor/head
    sprite_datum = new /datum/sprite_accessory/tumor/head

/obj/item/organ/external/tumor/Initialize(...)
    . = ..()
    AddComponent(/datum/component/gene_editable)

/datum/sprite_accessory/tumor
    icon = 'icons/mob/genetics/tumors.dmi'
    locked = TRUE
    icon_state = "head"
    
/datum/sprite_accessory/tumor/head
    icon_state = "head"
