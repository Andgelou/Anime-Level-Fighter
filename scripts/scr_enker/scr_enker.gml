function init_enker() {
	init_charsprites("enker");
	init_charaudio("enker");

	name = "enker";
	display_name = "Enker";
	
	theme = mus_dbfz_trunks;
	theme_pitch = 1.1;
	
	universe = universes.uniforce;

	max_air_moves = 2;
	
	kazedama_cooldown = 0;
	kazedama_cooldown_duration = 100;

	greenwind_active = false;
	greenwind_timer = 0;
	greenwind_duration = 30 * 60;
	greenwind_mp_drain = ceil(mp_stock_size / (5 * 60))
	greenwind_buff = 1.10;

	//next_form = obj_enker_sgw;
	transform_aura = spr_aura_dbz_green;
	charge_aura = spr_aura_dbz_green;
	
	add_kiblast_state(
		5,
		spr_enker_special_ki_blast,
		spr_enker_special_ki_blast2,
		spr_kiblast_green
	);

	char_script = function() {
		kamehameha_cooldown -= 1;
		var _greenwind_active = greenwind_active;
		if dead or (mp <= 0) {
			greenwind_timer = 0;
		}
		if greenwind_timer-- > 0 {
			greenwind_active = true;
			mp -= greenwind_mp_drain;
			if greenwind_timer mod 30 == 1 {
				greenwind_sparks();
			}
		}
		else {
			greenwind_active = false;
		}
		if greenwind_active != _greenwind_active {
			if greenwind_active {
				attack_power = greenwind_buff;
				move_speed_buff = greenwind_buff;
			}
			else {
				flash_sprite();
				play_sound(snd_energy_stop);
				attack_power = 1;
				move_speed_buff = 1;
				aura_sprite = noone;
			}
		}
	}

	//ai_script = function() {
	//	if greenwind_active {
	//		if target_distance < 50 {
	//			ai_input_move(autocombo[0],100);
	//		}
	//		else {
	//			ai_input_move(dash_state,50);
	//		}
	//	}
	//	else {
	//		ai_input_move(activate_greenwind,10);
	//		ai_input_move(spirit_bomb,10);
	//	}
	//	if target_distance < 20 {
	//		ai_input_move(dragon_fist,10);
	//		ai_input_move(meteor_combo,10);
	//		ai_input_move(kiai_push,10);
	//	}
	//	else if target_distance > 200 {
	//		ai_input_move(kiblast,10);
	//		ai_input_move(kamehameha,10);
	//		ai_input_move(super_kamehameha,10);
	//	}
	//}

	light_attack = new charstate();
	light_attack.start = function() {
		change_sprite(spr_enker_attack_punch_straight,3,false);
		play_sound(snd_punch_whiff_light);
		play_voiceline(voice_attack,50,false);
	}
	light_attack.run = function() {
		basic_light_attack(2,hiteffects.hit);
	}

	light_attack2 = new charstate();
	light_attack2.start = function() {
		change_sprite(spr_enker_attack_kick_side,3,false);
		play_sound(snd_punch_whiff_medium);
		play_voiceline(voice_attack,50,false);
	}
	light_attack2.run = function() {
		basic_medium_attack(2,hiteffects.hit);
	}

	light_attack3 = new charstate();
	light_attack3.start = function() {
		change_sprite(spr_enker_attack_kick_lift,3,false);
		play_voiceline(voice_heavyattack,50,false);
	}
	light_attack3.run = function() {
		basic_heavy_lowattack(3,hiteffects.hit);
	}
	
	light_lowattack = new charstate();
	light_lowattack.start = function() {
		change_sprite(spr_enker_attack_triple_kick,2,false);
		play_voiceline(voice_attack,50,false);
	}
	light_lowattack.run = function() {
		if check_frame(2) or check_frame(4) or check_frame(6) {
			play_sound(snd_punch_whiff_light);
		}
		basic_light_airattack(3,hiteffects.hit);
		basic_light_airattack(5,hiteffects.hit);
		basic_light_airattack(7,hiteffects.hit);
	}
	
	light_airattack = new charstate();
	light_airattack.start = function() {
		change_sprite(spr_enker_attack_triple_kick,2,false);
		play_voiceline(voice_attack,50,false);
	}
	light_airattack.run = function() {
		if frame <= 8 {
			xspeed = 5 * facing;
			yspeed = -1;
		}
		if check_frame(2) or check_frame(4) or check_frame(6) {
			play_sound(snd_punch_whiff_light);
		}
		basic_light_airattack(3,hiteffects.hit);
		basic_light_airattack(5,hiteffects.hit);
		basic_light_airattack(7,hiteffects.hit);
	}
	
	medium_attack = new charstate();
	medium_attack.start = function() {
		change_sprite(spr_enker_attack_elbow_bash,3,false);
		play_sound(snd_punch_whiff_medium);
		play_voiceline(voice_attack,50,false);
	}
	medium_attack.run = function() {
		basic_medium_attack(2,hiteffects.hit);
		if check_frame(2) {
			xspeed = 10 * facing;
			yspeed = 0;
		}
	}
	
	medium_lowattack = new charstate();
	medium_lowattack.start = function() {
		change_sprite(spr_enker_attack_spin_kick,2,false);
		play_sound(snd_punch_whiff_medium);
		play_voiceline(voice_attack,50,false);
	}
	medium_lowattack.run = function() {
		basic_medium_lowattack(4,hiteffects.hit);
	}
	
	medium_airattack = new charstate();
	medium_airattack.start = function() {
		change_sprite(spr_enker_attack_spin_kick_double,2,false);
		play_voiceline(voice_attack,50,false);
	}
	medium_airattack.run = function() {
		if check_frame(2) or check_frame(6) {
			play_sound(snd_punch_whiff_medium);
		}
		basic_medium_airattack(4,hiteffects.hit);
		basic_medium_airattack(8,hiteffects.hit);
	}

	heavy_attack = new charstate();
	heavy_attack.start = function() {
		change_sprite(spr_enker_attack_kick_back,5,false);
		play_sound(snd_punch_whiff_super);
		play_voiceline(voice_heavyattack,100,true);
	}
	heavy_attack.run = function() {
		basic_heavy_attack(2,hiteffects.hit);
	}

	launcher_attack = new charstate();
	launcher_attack.start = function() {
		change_sprite(spr_enker_attack_backflip_kick,3,false);
		play_sound(snd_punch_whiff_super);
		play_voiceline(voice_heavyattack,100,true);
	}
	launcher_attack.run = function() {
		basic_heavy_lowattack(3,hiteffects.hit);
	}

	heavy_airattack = new charstate();
	heavy_airattack.start = function() {
		change_sprite(spr_enker_attack_smash,5,false);
		play_sound(snd_punch_whiff_super);
		play_voiceline(voice_heavyattack,100,true);
	}
	heavy_airattack.run = function() {
		basic_heavy_airattack(2,hiteffects.hit);
	}

	dragon_fist = new charstate();
	dragon_fist.start = function() {
		if check_mp(1) {
			change_sprite(spr_enker_attack_punch_straight,8,false);
			activate_super();
			spend_mp(1);
		}
		else {
			change_state(idle_state);
		}
	}
	dragon_fist.run = function() {
		if superfreeze_active {
			frame = 0;
		}
		if check_frame(1) {
			xspeed = 20 * facing;
			play_sound(snd_punch_whiff_ultimate);
		}
		if check_frame(2) {
			create_hitbox(0,-height_half,width,height_half,150,40,-2,attacktype.wall_bounce,attackstrength.super,hiteffects.hit);
		}
		if check_frame(3) {
			xspeed /= 10;
		}
		if (state_timer > 50) {
			return_to_idle();
		}
	}

	ki_blast_cannon = new charstate();
	ki_blast_cannon.start = function() {
		if check_mp(1) {
			activate_super();
			spend_mp(1);
			change_sprite(spr_enker_special_ki_blast,3,false);
		}
		else {
			change_state(idle_state)
		}
	}
	ki_blast_cannon.run = function() {
		if superfreeze_active {
			frame = 0;
		}
		if check_frame(3) {
			var _blast = create_shot(
				25,
				-35,
				1,
				0,
				spr_kiblast_cannon,
				1,
				100,
				30,
				-2,
				attacktype.hard_knockdown,
				attackstrength.super,
				hiteffects.fire
			);
			with(_blast) {
				duration = anim_duration;
				hit_limit = -1;
				play_sound(snd_dbz_beam_fire);
			}
		}
		if state_timer > 60 {
			return_to_idle();
		}
	}

	kamehameha = new charstate();
	kamehameha.start = function() {
		if kamehameha_cooldown <= 0 {
			change_sprite(spr_enker_special_kamehameha,5,false);
			if is_airborne {
				change_sprite(spr_enker_special_kamehameha_air,frame_duration,false);
			}
			xspeed = 0;
			yspeed = 0;
			kamehameha_cooldown = kamehameha_cooldown_duration;
			play_voiceline(snd_enker_kamehameha);
			play_sound(snd_dbz_beam_charge_short);
		}
		else {
			change_state(idle_state);
		}
	}
	kamehameha.run = function() {
		xspeed = 0;
		yspeed = 0;
		if check_frame(6) {
			play_sound(snd_dbz_beam_fire);
		}
		if value_in_range(frame,6,9) {
			fire_beam(20,-25,spr_kamehameha,1,0,50);
		}
		return_to_idle();
	}
	
	kamehameha_medium = new charstate();
	kamehameha_medium.start = function() {
		kamehameha_light.start();
		if active_state == kamehameha_medium {
			change_sprite(sprite,frame_duration + 2,false);
		}
	}
	kamehameha_medium.start = function() {
		kamehameha_light.run();
	}
	
	kamehameha_heavy = new charstate();
	kamehameha_heavy.start = function() {
		kamehameha_light.start();
		if active_state == kamehameha_heavy {
			change_sprite(sprite,frame_duration + 3,false);
		}
	}
	kamehameha_heavy.start = function() {
		kamehameha_light.run();
	}
	
	super_kamehameha = new charstate();
	super_kamehameha.start = function() {
		if kamehameha_cooldown <= 0 and check_mp(2) {
			change_sprite(spr_enker_special_kamehameha,5,false);
			if is_airborne {
				change_sprite(spr_enker_special_kamehameha_air,frame_duration,false);
			}
			activate_super(320);
			spend_mp(2);
			xspeed = 0;
			yspeed = 0;
			kamehameha_cooldown = kamehameha_cooldown_duration * 1.5;
		}
		else {
			change_state(idle_state);
		}
	}
	super_kamehameha.run = function() {
		xspeed = 0;
		yspeed = 0;
		if superfreeze_active {
			loop_anim_middle(4,5);
			if superfreeze_timer == 15 {
				if (input.forward) and check_tp(2) {
					spend_tp(2);
					play_sound(snd_dbz_teleport_long);
					teleport(target_x + ((width + target.width) * facing), target_y);
					face_target();
				
					var _frame = frame;
					change_sprite(spr_enker_special_kamehameha_air,frame_duration,false);
					frame = _frame;
				}
			}
		}
		if check_frame(3) {
			play_voiceline(snd_enker_kamehameha_charge);
			play_sound(snd_dbz_beam_charge_long);
		}
		if check_frame(6) {
			play_voiceline(snd_enker_kamehameha_fire);
			play_sound(snd_dbz_beam_fire);
		}
		loop_anim_middle_timer(6,9,120);
		if value_in_range(frame,6,9) {
			fire_beam(20,-25,spr_kamehameha,2,0,50);
			shake_screen(5,3);
		}
		return_to_idle();
	}


	angry_kamehameha = new charstate();
	angry_kamehameha.start = function() {
		if kamehameha_cooldown <= 0 and check_mp(5) {
			change_sprite(spr_enker_special_ki_blast,5,false);
			activate_ultimate(60);
			spend_mp(5);
			xspeed = 0;
			yspeed = 0;
			kamehameha_cooldown = kamehameha_cooldown_duration * 1.5;
		}
		else {
			change_state(idle_state);
		}
	}
	angry_kamehameha.run = function() {
		xspeed = 0;
		yspeed = 0;
		if superfreeze_active {
			frame = 0;
		}
		if check_frame(3) {
			play_voiceline(snd_enker_kamehameha_fire);
			play_sound(snd_dbz_beam_fire);
		}
		loop_anim_middle_timer(3,3,120);
		if frame == 3 {
			fire_beam(20,-25,spr_kamehameha,2,0,80);
			shake_screen(5,10);
		}
		return_to_idle();
	}

	meteor_combo = new charstate();
	meteor_combo.start = function() {
		if on_ground and check_mp(1) {
			change_sprite(spr_enker_attack_punch_straight,3,false);
			activate_super();
			spend_mp(1);
		}
		else {
			change_state(idle_state);
		}
	}
	meteor_combo.run = function() {
		if superfreeze_active {
			frame = 0;
		}
		if combo_hits > 0 {
			sprite_sequence(
				[
					spr_enker_attack_punch_straight,
					spr_enker_attack_elbow_bash,
					spr_enker_attack_kick_side,
					spr_enker_attack_kick_straight,
					spr_enker_attack_backflip_kick,
					spr_enker_special_kamehameha_air
				],
				frame_duration
			);
		}
		if sprite == spr_enker_special_kamehameha_air {
			if check_frame(1) {
				teleport(target_x - (100 * facing), target_y - 50);
				face_target();
				play_sound(snd_dbz_teleport_short);
			}
			kamehameha.run();
		}
		else {
			if sprite == spr_enker_attack_backflip_kick {
				if check_frame(3) {
					create_hitbox(0,-height,width,height,40,3,-10,attacktype.normal,attackstrength.super,hiteffects.hit);
				}
				if check_frame(2) {
					xspeed = 3 * facing;
					yspeed = -5;
					play_sound(snd_punch_whiff_super);
				}
			}
			else {
				basic_attack(2,40,attackstrength.medium,hiteffects.hit);
				if check_frame(1) {
					xspeed = 10 * facing;
					play_sound(snd_punch_whiff_medium);
				}
			}
		}
		return_to_idle();
	}

	activate_greenwind = new charstate();
	activate_greenwind.start = function() {
		if check_mp(1) and (!greenwind_timer) {
			change_sprite(charge_loop_sprite,3,true);
			flash_sprite();
		
			activate_super(100);
			spend_mp(1);
			greenwind_timer = greenwind_duration;
		
			play_sound(snd_energy_start);
			play_voiceline(voice_powerup);
			
			repeat(20) {
				greenwind_sparks();
			}
		}
		else {
			change_state(idle_state);
		}
	}
	activate_greenwind.run = function() {
		if superfreeze_timer mod 10 == 1 {
			greenwind_sparks();
		}
		xspeed = 0;
		yspeed = 0;
		if !superfreeze_active {
			change_state(idle_state);
		}
	}

	setup_basicmoves();
	
	add_move(kiblast,"D");
	
	add_move(kamehameha,"236A");
	add_move(super_kamehameha,"236B");
	add_move(angry_kamehameha,"236C");
	
	add_ground_move(kiai_push,"214A");
	add_ground_move(kiai_push,"214B");
	add_ground_move(kiai_push,"214C");
	
	add_ground_move(activate_greenwind,"2D");
	
	signature_move = super_kamehameha;
	finisher_move = angry_kamehameha;

	victory_state.run = function() {
		greenwind_timer = 0;
		if anim_timer >= (anim_duration - 2) {
			frame = anim_frames - 2;
		}
	}

	draw_script = function() {
		if sprite == spr_enker_special_kamehameha
		or sprite == spr_enker_special_kamehameha_air {
			gpu_set_blendmode(bm_add);
			if value_in_range(frame,3,5) {
				var _x = x - (10 * facing);
				var _y = y - 25;
				var _scale = anim_timer / 120;
				draw_sprite_ext(
					spr_kamehameha_charge,
					0,
					_x,
					_y,
					_scale,
					_scale,
					anim_timer * 5,
					c_white,
					1
				);
			}
		}
		gpu_set_blendmode(bm_normal);
	}
}