/obj/item/card_access_chip
	name = "\improper AA-chip"
	desc = "Additional Access chip, used to add higher tier access to lower tier cards."
	icon = 'icons/obj/new_id.dmi'
	icon_state = "aa-chip-temp-codersprite-help" // TODO: get proper sprite

	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF

	var/access_tier = 0
	var/rewritable = FALSE
	var/list/access = list()

/obj/item/card_access_chip/proc/apply_access(obj/item/card/id/id)
	// this is += instead of |= because chips could share accesses.
	id.additional_access += access

/obj/item/card_access_chip/proc/remove_access(obj/item/card/id/id)
	id.additional_access -= access

/obj/item/card_access_chip/roundstart
	access_tier = 5
	rewritable = FALSE // In case someone decides to change the base.
	var/assignment = ""

/obj/item/card_access_chip/roundstart/Initialize(mapload, _assignment)
	. = ..()
	assignment = _assignment
	name = "[_assignment] AA-chip"
