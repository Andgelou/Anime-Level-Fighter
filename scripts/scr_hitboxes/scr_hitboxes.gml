// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function create_hurtbox(_xoffset, _yoffset, _width, _height) {
	with(obj_hurtbox) {
		if owner == other {
			instance_destroy();
		}
	}
	var _hurtbox = instance_create(x,y,obj_hurtbox);
	with(_hurtbox) {
		owner = other;
		xoffset = _xoffset;
		yoffset = _yoffset;
		image_xscale = _width / sprite_get_width(spr_hitbox);
		image_yscale = _height / sprite_get_width(spr_hitbox);
	}
	return _hurtbox;
}

function create_hitbox(_xoffset,_yoffset,_width,_height,_damage,_xknockback,_yknockback,_attacktype,_strength,_hiteffect) {
	var _hitbox = instance_create(x,y,obj_hitbox);
	with(_hitbox) {
		owner = other;
		xoffset = _xoffset;
		yoffset = _yoffset;
		image_xscale = _width / sprite_get_width(spr_hurtbox);
		image_yscale = _height / sprite_get_width(spr_hurtbox);
		damage = _damage;
		xknockback = _xknockback;
		yknockback = _yknockback;
		attack_type = _attacktype;
		attack_strength = _strength;
		hit_effect = _hiteffect;
		my_state = owner.active_state;
		duration = owner.frame_duration;
	}
	return _hitbox;
}

function check_hit() {
	var a = id;
	var a2 = owner;
	with(obj_hitbox) {
		var b = id;
		var b2 = owner;
		var contact = true;
		if !place_meeting(x,y,a) {
			contact = false;
		}
		if a2.team == b2.team {
			contact = false;
		}
		if ds_list_find_index(a.hit_list,b2) != -1 {
			contact = false;
		}
		if contact {
			if object_is_ancestor(a2.object_index,obj_char)
			and object_is_ancestor(b2.object_index,obj_char) {
				init_clash(a2,b2);
				ds_list_add(a.hit_list,b2);
				ds_list_add(b.hit_list,a2);
			}
			
			if ((a2.object_index == obj_shot) or (object_is_ancestor(a2.object_index,obj_shot)))
			and ((b2.object_index == obj_shot) or (object_is_ancestor(b2.object_index,obj_shot))) {
				with(a2) {
					hit_script(b2);
					if b2.width >= a2.width {
						hit_count++;
					}
				}
				with(b2) {
					hit_script(a2);
					if a2.width >= b2.width {
						hit_count++;
					}
				}
			}
		}
	}
	with(obj_hurtbox) {
		var b = id;
		var b2 = owner;
		var contact = true;
		if !place_meeting(x,y,a) {
			contact = false;
		}
		if a2.team == b2.team {
			contact = false;
		}
		if ds_list_find_index(a.hit_list,b2) != -1 {
			contact = false;
		}
		if b2.grabbed {
			contact = false;
		}
		if object_is_ancestor(a2.object_index,obj_char) {
			if b2.dodging_attacks {
				contact = false;
				ds_list_add(a.hit_list,b2);
			}
			if b2.deflecting_attacks {
				contact = false;
				a2.xspeed = 20 * b2.facing;
				a2.yspeed = b2.yspeed;
				ds_list_add(a.hit_list,b2);
			}
		}
		else {
			if b2.dodging_projectiles {
				contact = false;
				ds_list_add(a.hit_list,b2);
			}
			if b2.deflecting_projectiles {
				contact = false;
				a2.xspeed = 20 * b2.facing;
				a2.yspeed = -20;
				a2.homing = false;
				a2.affected_by_gravity = true;
				ds_list_add(a.hit_list,b2);
			}
		}
		if contact {
			if a2.object_index == obj_shot
			or object_is_ancestor(a2.object_index,obj_shot) {
				with(a2) {
					hit_script(b2);
					hit_count++;
				}
			}
			with(b2) {
				get_hit(a2,a.damage,a.xknockback,a.yknockback,a.attack_type,a.attack_strength,a.hit_effect,a.hit_anim);
			}
			ds_list_add(a.hit_list,b2);
		}
	}
}