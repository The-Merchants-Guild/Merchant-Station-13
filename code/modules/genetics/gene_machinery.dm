/obj/machinery/admin_gene_machine/
  name = "Theogenetic Editor"
  desc = "Creates and dispenses genes."
  density = TRUE
  icon = 'icons/obj/chemical.dmi'
  icon_state = "dispenser"
  var/datum/gene/current_gene = new /datum/gene
  var/list/targets = list()
  var/list/conditionals = list()
  var/list/proteins = list()

/obj/machinery/admin_gene_machine/ui_interact(mob/user, datum/tgui/ui)
  ui = SStgui.try_update_ui(user, src, ui)
  if(!ui)
    ui = new(user, src, "GeneInterface", "TheoGenetic Editor")
    ui.open()

/obj/machinery/admin_gene_machine/ui_data(mob/user)
  var/list/data = list()
  var/list/available_targets = list()
  var/list/available_conditionals = list()
  var/list/available_proteins = list()

  for(var/datum/gene_frame/target/T in GLOB.all_target_genes)
    available_targets += list(T.name)
    targets += list(T.name = T)
  data["target_genes"] = available_targets

  for(var/datum/gene_frame/conditional/T in GLOB.all_conditional_genes)
    available_conditionals += list(T.name)
    conditionals += list(T.name = T)
  data["conditional_genes"] = available_conditionals

  for(var/datum/gene_frame/protein/T in GLOB.all_protein_genes)
    available_proteins += list(T.name)
    proteins += list(T.name = T)
  data["protein_genes"] = available_proteins

  SEND_TEXT(world.log, available_conditionals.len)
  SEND_TEXT(world.log, GLOB.all_conditional_genes.len)

  var/list/crt_targets = list()
  var/list/crt_conds = list()
  var/list/crt_prot = list()

  for(var/datum/gene_frame/target/T in current_gene.target_frames)
    crt_targets += list(T.name)
  data["crt_targets"] = crt_targets

  for(var/datum/gene_frame/conditional/T in current_gene.conditional_frames)
    crt_conds += list(T.name)
  data["crt_conds"] = crt_conds

  for(var/datum/gene_frame/protein/T in current_gene.protein_frames)
    crt_prot += list(T.name)
  data["crt_prot"] = crt_prot

  return data

/obj/machinery/admin_gene_machine/ui_act(action, params)
  . = ..()
  if(.)
    return
  if(action in targets)
    current_gene.target_frames += list(targets[action])
  else if(action in conditionals)
    current_gene.conditional_frames += list(conditionals[action])
  else if(action in proteins)
    current_gene.protein_frames += list(proteins[action])
  update_icon()
