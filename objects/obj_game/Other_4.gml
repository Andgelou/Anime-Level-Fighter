/// @description Insert description here
// You can write your code in this editor
	
for(var i = 0; i < array_length(player_slot); i++) {
	player[i] = noone;
}

init_view();

stop_music();

ground_height = room_height - round(game_height * 0.25);

switch(room) {
	case rm_charselect:
	for(var i = 0; i < array_length(player_slot); i++) {
		player_ready[i] = false;
	}
	ready_timer = 100;
	stage = choose(rm_namek);
	play_music(mus_umvc3_charselect);
	break;
	
	case stage:
	round_state = roundstates.intro;
	round_timer = round_timer_max;
	round_state_timer = 0;
		
	battle_x = room_width / 2;
	battle_y = ground_height;
	left_wall = 0;
	right_wall = room_width;
		
	var _w = game_width / 3;
	var _w2 = _w / 2;
	var _x1 = battle_x - _w2;
	var _x2 = battle_x + _w2;
	var active_players = 0;
	for(var i = 0; i < array_length(player_slot); i++) {
		if player_slot[i] != noone {
			active_players++;
		}
	}
	var spawned_players = 0;
	for(var i = 0; i < array_length(player_slot); i++) {
		if player_slot[i] != noone {
			var _x = map_value(spawned_players,0,active_players-1,_x1,_x2);
			var _y = battle_y;
			with(instance_create(_x,_y,get_char_object(player_char[i]))) {
				player[i] = id;
				input = player_input[player_slot[i]];
				if active_players mod 2 == 0 {
					if x < battle_x team = 1; else team = 2;
				}
				else {
					team = spawned_players + 1;
				}
				if x > battle_x {
					facing = -1;
				}
				change_state(intro_state);
			}
			spawned_players++;
		}
	}
	
	with(obj_char) {
	}
	
	chars_update_targeting();
	chars_update_stats();
	
	stop_music();
	var picked_player = instance_find(obj_char,irandom(instance_number(obj_char)-1));
	play_music(picked_player.theme);
	
	switch(room) {
		default:
		ground_sprite = noone;
		break;
		
		case rm_training:
		ground_sprite = spr_grid_ground;
		break;
		
		//case rm_namek:
		//ground_sprite = spr_namek_ground;
		//break;
	}
	break;
}