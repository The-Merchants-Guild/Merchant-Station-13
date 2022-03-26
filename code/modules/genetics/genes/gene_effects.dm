// this will be where the actual component effects will be
// gene frames, most of the time, will only regulate components

/datum/component/genetic_reagent_holder
    //var/datum/reagents/R

//TODO: gotta deal with removal from organs, will make it generic buut this is for testmerge quick shitcode
/datum/component/genetic_reagent_holder/Initialize()
    . = ..()
    var/obj/item/organ/par = parent
    if(!parent) return
    //R = par?.reagents
    RegisterSignal(par.owner, COMSIG_LIVING_LIFE, .proc/life)
     
/datum/component/genetic_reagent_holder/proc/life(delta_time, times_fired)
    var/obj/item/organ/par = parent
    var/datum/reagents/R = par?.reagents
    if(istype(parent, /obj/item/organ/external/tumor))
        var/obj/item/organ/external/tumor/T = parent
        R.maximum_volume = 10 * T.tumor_size
    else
        R.maximum_volume = 20
