// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

enum attacktype {
	light,
	
	medium,
	antiair,
	unblockable,
	beam,
	
	heavy,
	launcher,
	hard_knockdown,
	smash,
	slide_knockdown,
	wall_splat,
	wall_bounce,
	ground_bounce,
	
	hit_grab,
	grab,
}

function add_move(_move,_input) {
	if movelist[0][0] == noone {
		movelist[0][0] = _move;
		movelist[0][1] = _input;
	}
	else {
		var n = array_length(movelist);
		movelist[n][0] = _move;
		movelist[n][1] = _input;
	}
}

function check_moves() {
	var moved = false;
	if can_cancel {
		var available_moves = ds_priority_create();
		var min_cancel = 0;
		if ds_list_empty(cancelable_moves) {
			for(var i = 0; i < array_length(movelist); i++) {
				if active_state == movelist[i][0]
				and ds_list_find_index(cancelable_moves,active_state) == -1 {
					min_cancel = i+1;
					break;
				}
			}
		}
		for(var i = min_cancel; i < array_length(movelist); i++) {
			var move = movelist[i][0];
			var input = movelist[i][1];
			if (ds_list_find_index(cancelable_moves,move) != -1)
			or ds_list_empty(cancelable_moves) {
				if check_input(input) {
					ds_priority_add(available_moves,move,string_length(input));
				}
			}
		}
		if !ds_priority_empty(available_moves) {
			can_block = false;
			can_cancel = false;
			input_buffer = "";
			input_buffer_timer = 0;
			reset_cancels();
			change_state(ds_priority_find_max(available_moves));
			moved = true;
		}
		ds_priority_destroy(available_moves);
	}
	return moved;
}

function add_cancel(_move) {
	if ds_list_find_index(cancelable_moves,_move) == -1 {
		ds_list_add(cancelable_moves,_move);
	}
}

function reset_cancels() {
	ds_list_clear(cancelable_moves);
}

function check_input(_input) {
	var valid = true;
	var _input_dir = string_digits(input_buffer);
	var _input_btn = string_letters(input_buffer);
	var cmd_dir = string_digits(_input);
	var cmd_btn = string_letters(_input);
	if cmd_dir != "" {
		if (!string_ends_with(_input_dir,cmd_dir)) and (!string_ends_with(_input_dir,cmd_dir + "5")) {
			valid = false;
		}
	}
	if !string_ends_with(_input_btn,cmd_btn) {
		valid = false;
	}
	return valid;
}

function setup_autocombo() {
	for(var i = 0; i < array_length(autocombo); i++) {
		add_move(autocombo[i],"A");
	}
}

function air_chase() {
	var _factor = 0.2;
	xspeed = (target_x-x) * _factor;
	yspeed = min(-2.25,(target_y-y) * _factor);
	//xspeed += target.xspeed;
	//yspeed += target.yspeed;
	//xspeed = 3 * facing;
	//yspeed = -2.5;
}

function create_shot(_x,_y,_xspeed,_yspeed,_sprite,_scale,_damage,_xknockback,_yknockback,_attacktype,_hiteffect) {
	var shot = instance_create(x+(_x*facing),y+_y,obj_shot);
	with(shot) {
		owner = other;
		if owner.object_index == obj_shot or object_is_ancestor(owner.object_index,obj_shot) {
			owner = owner.owner;
		}
		team = owner.team;
		init_sprite(_sprite);
		change_sprite(_sprite,3,true);
		xscale = _scale;
		yscale = _scale;
		width = min(sprite_get_width(sprite),sprite_get_height(sprite)) * _scale * 0.75;
		height = width;
		width_half = floor(width / 2);
		height_half = floor(height / 2);
		hitbox = create_hitbox(-width/2,-height/2,width,height,_damage,_xknockback,_yknockback,_attacktype,_hiteffect);
		hitbox.duration = -1;
		xspeed = _xspeed * owner.facing;
		yspeed = _yspeed;
		facing = owner.facing;
		target = owner.target;
		
		rotation = point_direction(0,0,xspeed,yspeed);

		if xspeed > 0 {
			facing = 1;
		}
		else if xspeed < 0 {
			facing = -1;
		}
	}
	return shot;
}

function fire_beam_attack(_x, _y, _damage, beam_sprite, _attacktype, _hiteffect) {
	var split = 1;
    var beam_speed = sprite_get_width(beam_sprite) / split;
	if (state_timer mod split == 0) {
        with(create_shot(_x, _y, beam_speed, 0, beam_sprite, _damage, _attacktype, _hiteffect)) {
            blend = true;
            hit_limit = -1;
        }
    }
}

function superfreeze(_duration = 30) {
	superfreeze_active = true;
	superfreeze_activator = id;
	superfreeze_timer = _duration;
	if team == 1 {
		p1_super_active = true;
	}
	else {
		p2_super_active = true;
	}
}

function deactivate_super() {
	if team == 1 {
		p1_super_active = false;
	}
	else {
		p2_super_active = false;
	}
}

function check_mp(_stocks) {
	if team == 1 {
		if p1_mp >= (_stocks * mp_stock_size) {
			return true;
		}
	}
	else {
		if p2_mp >= (_stocks * mp_stock_size) {
			return true;
		}
	}
	return false;
}

function spend_mp(_stocks) {
	if team == 1 {
		p1_mp -= (_stocks * mp_stock_size);
	}
	else {
		p2_mp -= (_stocks * mp_stock_size);
	}
}

function check_tp(_stocks) {
	if team == 1 {
		if p1_tp >= (_stocks * tp_stock_size) {
			return true;
		}
	}
	else {
		if p2_tp >= (_stocks * tp_stock_size) {
			return true;
		}
	}
	return false;
}

function spend_tp(_stocks) {
	if team == 1 {
		p1_tp -= (_stocks * tp_stock_size);
	}
	else {
		p2_tp -= (_stocks * tp_stock_size);
	}
}

function check_sp(_stocks) {
	if team == 1 {
		if p1_sp >= (_stocks * sp_stock_size) {
			return true;
		}
	}
	else {
		if p2_sp >= (_stocks * sp_stock_size) {
			return true;
		}
	}
	return false;
}

function spend_sp(_stocks) {
	if team == 1 {
		p1_sp -= (_stocks * sp_stock_size);
	}
	else {
		p2_sp -= (_stocks * sp_stock_size);
	}
}