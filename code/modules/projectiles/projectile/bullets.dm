/obj/projectile/bullet
	name = "bullet"
	icon_state = "bullet"
	damage = 60
	damage_type = BRUTE
	nodamage = FALSE
	flag = BULLET
	hitsound_wall = "ricochet"
	sharpness = SHARP_POINTY
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	shrapnel_type = /obj/item/shrapnel/bullet
	embedding = list(embed_chance=20, fall_chance=2, jostle_chance=0, ignore_throwspeed_threshold=TRUE, pain_stam_pct=0.5, pain_mult=3, rip_time=10)
	wound_falloff_tile = -5
	embed_falloff_tile = -3

/obj/projectile/bullet/smite
	name = "divine retribution"
	damage = 10

/obj/projectile/bullet/process_hit(turf/T, atom/target, qdel_self, hit_something = FALSE)
	. = ..()
	if(ishuman(target) && damage && !nodamage)
		var/obj/effect/decal/cleanable/blood/hitsplatter/B = new(target.loc, target)
		B.add_blood_DNA(return_blood_DNA())
		var/dist = rand(1,7)
		var/turf/targ = get_ranged_target_turf(target, get_dir(starting, target), dist)
		B.GoTo(targ, dist)
