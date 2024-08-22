// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function init_sprite(_sprite = sprite_index) {
	sprite = _sprite;
	frame = 0;
	frame_duration = 5;
	frame_timer = 0;
	anim_frames = sprite_get_number(sprite);
	anim_duration = anim_frames * frame_duration;
	anim_loop = true;
	anim_timer = 0;
	anim_finished = false;
	xoffset = 0;
	yoffset = 0;
	facing = 1;
	xscale = 1;
	yscale = 1;
	xstretch = 1;
	ystretch = 1;
	rotation = 0;
	rotation_speed = 0;
	color = c_white;
	alpha = 1;
	flash = 0;
	flash_color = c_white;
	change_sprite(_sprite,5,true);
	reset_sprite();
}

function change_sprite(_sprite,_frameduration, _loop) {
	if sprite != _sprite {
		sprite = _sprite;
		frame = 0;
		frame_timer = 0;
		anim_timer = 0;
		anim_frames = sprite_get_number(sprite);
		anim_finished = false;
		reset_sprite();
	}
	if !_loop {
		frame = 0;
		frame_timer = 0;
	}
	anim_loop = _loop;
	frame_duration = _frameduration;
	anim_duration = anim_frames * frame_duration;
}

function reset_sprite() {
	xoffset = 0;
	yoffset = 0;
	xscale = 1;
	yscale = 1;
	rotation = 0;
	rotation_speed = 0;
	color = c_white;
	alpha = 1;
}

function flash_sprite(_duration = 6,_color = c_white) {
	flash = _duration;
	flash_color = _color;
}

function squash_stretch(_x,_y) {
	xstretch = _x;
	ystretch = _y;
}

function run_animation() {
	frame_timer += 1;
	if frame_timer >= frame_duration {
		frame += 1;
		frame_timer = 0;
		if frame >= anim_frames {
			if anim_loop {
				frame = 0;
			}
			else {
				frame = anim_frames - 1;
				frame_timer = frame_duration - 1;
			}
			anim_finished = true;
		}
	}
	xstretch = approach(xstretch,1,1/30);
	ystretch = approach(ystretch,1,1/30);
	rotation += rotation_speed;
	flash -= 1;
	anim_timer = anim_duration - (frame_timer + (frame * frame_duration));
}

function check_frame(_frame, _startonly = true) {
	if frame == _frame {
		if (!_startonly) or (_startonly and frame_timer == 0) {
			return true;
		}
	}
	return false;
}

function sprite_sequence(_sprites, _frameduration) {
	if (frame >= anim_frames - 1) and (frame_timer >= frame_duration - 2) {
		show_debug_message("sprite sequence check");
		for(var i = 0; i < array_length(_sprites) - 1; i++) {
			if sprite == _sprites[i] {
				change_sprite(_sprites[i+1],_frameduration,false);
				break;
			}
		}
	}
}