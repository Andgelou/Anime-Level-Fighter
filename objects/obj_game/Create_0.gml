/// @description Insert description here
// You can write your code in this editor

if instance_number(object_index) > 1 {
	instance_destroy();
	exit;
}

enum gamestates {
	intro,
	title,
	main_menu,
	options,
	
	story_select,
	story_map,
	story_status,
	story_cutscene,
	story_battle,
	story_results,
	
	versus_setup,
	versus_select,
	versus_intro,
	versus_battle,
	versus_results,
	
	training_select,
	training
}

enum roundstates {
	intro,
	countdown,
	fight,
	pause,
	knockout,
	time_over,
	victory
}

globalvar	player, player_char, player_input,
			player_slot, player_ready, ready_timer,
			player_color,
			
			ygravity, ground_height, battle_x, battle_y, left_wall, right_wall,
			
			max_mp, max_mp_stocks, mp_stock_size,
			max_tp, max_tp_stocks, tp_stock_size,
			max_sp, max_sp_stocks, sp_stock_size,
			
			max_level,
			game_state, game_state_previous, game_state_timer, game_state_duration,
			round_state, round_timer, round_state_timer, round_timer_max, round_countdown_duration, round_is_infinite,
			stage,
			
			superfreeze_active, superfreeze_timer, superfreeze_activator,
			player_super_active, p2_super_active,
			
			screen_shake_x, screen_shake_y, screen_shake_intensity, screen_shake_timer,
			screen_flash_color, screen_flash_timer,
			screen_overlay_sprite, screen_overlay_timer,
			screen_zoom, screen_zoom_target, 
			
			screen_width, screen_height, screen_aspectratio,
			game_width, game_height, game_aspectratio,
			window_width, window_height, window_scale, window_max_scale,
			fullscreen_width, fullscreen_height,
			
			screen_flash_alpha, screen_shake_enabled, screen_overlay_alpha;

game_state = gamestates.main_menu;
game_state_previous = -1;
game_state_duration = -1;
game_state_timer = -1;

stage = rm_training;
round_state = roundstates.intro;
round_state_timer = 0;
round_timer_max = 300 * 60;
round_timer = round_timer_max;
round_countdown_duration = (3 * 30) + 30;
round_is_infinite = false;

for(var i = 0; i < 4; i++) {
	player[i] = noone;
	player_char[i] = 0;
	player_slot[i] = noone;
	player_ready[i] = false;
}

for(var i = 0; i < 8; i++) {
	gamepad_set_axis_deadzone(i,0.5);
}

for(var i = 0; i < 11; i++) {
	player_input[i] = instance_create(0,0,obj_input);
	player_input[i].type = input_types.joystick;
	player_input[i].pad = i;
}
player_input[8].type = input_types.wasd;
player_input[9].type = input_types.numpad;
player_input[10].type = input_types.touch;

var i = 0;
player_color[i++] = make_color_rgb(255,0,0);
player_color[i++] = make_color_rgb(0,128,255);
player_color[i++] = make_color_rgb(255,192,0);
player_color[i++] = make_color_rgb(0,192,0);
player_color[i++] = make_color_rgb(128,0,255);
player_color[i++] = make_color_rgb(255,0,255);
player_color[i++] = make_color_rgb(255,128,0);
player_color[i++] = make_color_rgb(128,64,32);

mp_stock_size = 1000;
max_mp_stocks = 5;
max_mp = max_mp_stocks * mp_stock_size;

tp_stock_size = 1000;
max_tp_stocks = 4;
max_tp = max_tp_stocks * tp_stock_size;

sp_stock_size = 1000;
max_sp_stocks = 4;
max_sp = sp_stock_size * max_sp_stocks;

superfreeze_active = false;
superfreeze_activator = noone;
superfreeze_timer = 0;

screen_flash_color = c_white;
screen_flash_timer = 0;
screen_flash_alpha = 1;

screen_shake_intensity = 0;
screen_shake_x = 0;
screen_shake_y = 0;
screen_shake_timer = 0;
screen_shake_enabled = true;

screen_overlay_sprite = noone;
screen_overlay_timer = 0;
screen_overlay_alpha = 1;

screen_zoom = 1;
screen_zoom_target = noone;

ygravity = 0.35;
left_wall = 0;
right_wall = room_width;
ground_height = room_height;
battle_x = room_width / 2;
battle_y = ground_height;
ground_sprite = noone;

depth = -9999;

for(var i = 0; i <= room_last; i++) {
	if i != rm_start {
		room_set_width(i,game_width*2);
		room_set_height(i,game_height*2);
	}
}