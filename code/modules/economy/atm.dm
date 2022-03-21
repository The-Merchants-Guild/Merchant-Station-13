/obj/machinery/atm
	name = "ATM"
	desc = "Used to convert your good boy job points to credits."
	icon = 'icons/obj/economy.dmi'
	icon_state = "atm"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/atm
	var/static/list/conversion_rates = list(
		ACCOUNT_ENG = 2,
		ACCOUNT_SCI = 2,
		ACCOUNT_MED = 2,
		ACCOUNT_SRV = 2,
		ACCOUNT_CAR = 2,
		ACCOUNT_SEC = 2
	)

/obj/machinery/atm/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ATM")
		ui.open()

/obj/machinery/atm/ui_static_data(mob/user)
	. = ..()
	.["rates"] = conversion_rates

/obj/machinery/atm/ui_data(mob/user)
	. = list()
	var/obj/item/card/id/C
	if (isliving(user))
		var/mob/living/L = user
		C = L.get_idcard(TRUE)
	if (C)
		.["card"] = C
		.["points"] = C.registered_account.job_points

/obj/machinery/atm/ui_act(action, params)
	. = ..()
	if (.)
		return
	if ((machine_stat & BROKEN) || !powered())
		return

	var/obj/item/card/id/C
	if (isliving(usr))
		var/mob/living/L = usr
		C = L.get_idcard(TRUE)
	if (!C)
		return

	switch (action)
		if ("convert")
			var/S = params["selected"]
			var/datum/bank_account/acc = C.registered_account
			if (!acc.job_points[S])
				return
			var/P = params["amount"]
			if (acc.job_points[S] < P)
				return
			var/R = conversion_rates[S]
			acc.adjust_money(P * R)
			acc.job_points[S] -= P
