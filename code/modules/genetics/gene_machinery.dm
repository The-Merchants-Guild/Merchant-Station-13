/obj/machinery/admin_gene_machine/
    name = "Theogenetic Editor"
    desc = "Creates and dispenses genes."
    density = TRUE
    icon = 'icons/obj/chemical.dmi'
    icon_state = "dispenser"
    var/datum/gene/current_gene = new /datum/gene

/obj/machinery/admin_gene_machine/ui_interact(mob/user, datum/tgui/ui)
  ui = SStgui.try_update_ui(user, src, ui)
  if(!ui)
    ui = new(user, src, "GeneInterface", "TheoGenetic Editor")
    ui.open()

/obj/machinery/admin_gene_machine/ui_data(mob/user)
  var/list/data = list()
  var/list/available_targets = list()

  for(var/datum/gene_frame/target/T in GLOB.all_target_genes)
    available_targets += list(T.name)
  data["target_genes"] = available_targets

  return data

/obj/machinery/admin_gene_machine/ui_act(action, params)
  . = ..()
  if(.)
    return
//   if(action == "change_color")
//     var/new_color = params["color"]
//     if(!(color in allowed_coors))
//       return FALSE
//     color = new_color
//     . = TRUE
  update_icon()
