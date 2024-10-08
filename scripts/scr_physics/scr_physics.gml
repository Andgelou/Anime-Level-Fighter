// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function init_physics() {
	xspeed = 0;
	yspeed = 0;
	
	move_speed = base_movespeed;
	move_speed_mod = 1;
	move_speed_buff = 1;
	
	jump_speed = base_jumpspeed;
	
	on_ground = (y >= ground_height) and (yspeed >= 0);
	is_airborne = !on_ground;
	on_left_wall = x <= left_wall;
	on_right_wall = x >= right_wall;
	on_wall = on_left_wall or on_right_wall;
}

function run_physics() {
	x += xspeed;
	y += yspeed;
	on_left_wall = x <= left_wall;
	on_right_wall = x >= right_wall;
	on_wall = on_left_wall or on_right_wall;
	on_ground = (y >= ground_height) and (yspeed >= 0);
	is_airborne = !on_ground;
}

function gravitate(_multiplier = 1) {
	if is_char(id) or is_helper(id) {
		if is_hit or is_guarding {
			_multiplier = 1;
		}
		else {
			if yspeed > 0 {
				_multiplier += 1/2;
			}
		}
	}
	yspeed += ygravity * _multiplier;
}

function accelerate(_desired_speed, _speed = 1) {
	xspeed = approach(xspeed,_desired_speed,_speed * 2);
}

function decelerate(_speed = 1) {
	xspeed = approach(xspeed,0,_speed);
}

function bounce_off_wall() {
	if on_left_wall {
		xspeed = abs(xspeed);
	}
	else if on_right_wall {
		xspeed = -abs(xspeed);
	}
}