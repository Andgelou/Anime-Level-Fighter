function init_naruto_baseform() {
	init_charsprites("naruto");

	name = "Naruto";

	move_speed *= 1.5;
	max_air_moves = 1;

	theme = mus_naruto_strongandstrike;

	shadow_clone_jutsu_cooldown = 0;
	shadow_clone_jutsu_cooldown_duration = 300;

	char_script = function() {
		var me = id;
		with(obj_helper) {
			if owner == me {
				with(me) {
					shadow_clone_jutsu_cooldown = shadow_clone_jutsu_cooldown_duration;
				}
			}
		}
	}

	//airdash_state.start = function() {
	//	if air_moves < max_air_moves {
	//		change_sprite(dash_sprite,2,true);
	//		yoffset = -height/2;
	//		rotation = 20;
	//		xspeed = move_speed * 1.5 * facing;
	//		yspeed = -5;
	//		air_moves += 1;
	//		play_sound(snd_dash);
	//	}
	//	else {
	//		change_state(air_state);
	//	}
	//}
	//airdash_state.run = function() {
	//	if state_timer >= 15 {
	//		change_state(air_state);
	//	}
	//}

	//air_backdash_state.start = function() {
	//	if air_moves < max_air_moves {
	//		change_sprite(dash_sprite,2,true);
	//		yoffset = -height/2;
	//		xscale = -1;
	//		rotation = 20;
	//		xspeed = move_speed * 1.5 * -facing;
	//		yspeed = -5;
	//		air_moves += 1;
	//		play_sound(snd_dash);
	//	}
	//	else {
	//		change_state(air_state);
	//	}
	//}
	//air_backdash_state.run = function() {
	//	if state_timer >= 15 {
	//		change_state(air_state);
	//	}
	//}

	var i = 0;
	autocombo[i] = new state();
	autocombo[i].start = function() {
		if on_ground {
			change_sprite(spr_naruto_attack_punch_straight,3,false);
			play_sound(snd_punch_whiff_light);
			play_voiceline(voice_attack,50,false);
		}
		else {
			change_state(autocombo[7]);
		}
	}
	autocombo[i].run = function() {
		basic_attack(2,10,attackstrength.light,hiteffects.hit);
		return_to_idle();
		check_moves();
	}
	i++;

	autocombo[i] = new state();
	autocombo[i].start = function() {
		change_sprite(spr_naruto_attack_dash_punch,3,false);
		play_sound(snd_punch_whiff_medium);
		play_voiceline(voice_attack,50,false);
	}
	autocombo[i].run = function() {
		basic_attack(2,10,attackstrength.light,hiteffects.hit);
		return_to_idle();
		check_moves();
	}
	i++;

	autocombo[i] = new state();
	autocombo[i].start = function() {
		change_sprite(spr_naruto_attack_punch_hook,3,false);
		play_sound(snd_punch_whiff_medium);
		play_voiceline(voice_attack,50,false);
	}
	autocombo[i].run = function() {
		basic_attack(2,20,attackstrength.medium,hiteffects.hit);
		return_to_idle();
		check_moves();
	}
	i++;

	autocombo[i] = new state();
	autocombo[i].start = function() {
		change_sprite(spr_naruto_attack_spinkick,3,false);
		play_sound(snd_punch_whiff_heavy2);
		play_voiceline(voice_attack,50,false);
	}
	autocombo[i].run = function() {
		basic_attack(3,20,attackstrength.medium,hiteffects.hit);
		return_to_idle();
		check_moves();
	}
	i++;

	autocombo[i] = new state();
	autocombo[i].start = function() {
		change_sprite(spr_naruto_attack_slash,2,false);
		play_sound(snd_slash_whiff_medium);
		play_voiceline(voice_heavyattack,50,false);
	}
	autocombo[i].run = function() {
		basic_attack(2,20,attackstrength.light,hiteffects.slash);
		return_to_idle();
		check_moves();
	}
	i++;

	autocombo[i] = new state();
	autocombo[i].start = function() {
		change_sprite(spr_naruto_attack_slash_up,3,false);
		play_sound(snd_punch_whiff_light);
		play_voiceline(voice_attack,50,false);
	}
	autocombo[i].run = function() {
		if check_frame(3) {
			create_hitbox(
				0,
				-height,
				width,
				height,
				50,
				1,
				-5,
				attacktype.hard_knockdown,
				attackstrength.heavy,
				hiteffects.slash
			);
			xspeed = 3 * facing;
			yspeed = -3;
		}
		if on_ground and anim_finished {
			if target.is_hit {
				change_state(autocombo[6]);
			}
			else {
				change_state(idle_state);
			}
		}
	}
	i++;

	autocombo[i] = new state();
	autocombo[i].start = function() {
		change_sprite(spr_naruto_jutsu,3,false);
		play_sound(snd_jutsu_activate);
		timestop(30);
		xspeed = -5 * facing;
	}
	autocombo[i].run = function() {
		if check_frame(3) {
			create_helper(0,0,init_naruto_baseform_clone_barrage);
			create_helper(20,0,init_naruto_baseform_clone_barrage);
			create_helper(120,0,init_naruto_baseform_clone_barrage);
			create_helper(100,0,init_naruto_baseform_clone_barrage);
		}
		if anim_finished {
			change_state(autocombo[7]);
		}
	}
	i++;

	autocombo[i] = new state();
	autocombo[i].start = function() {
		change_sprite(spr_naruto_flip,3,true);
		rotation_speed = -45;
		xspeed = 2.5 * facing;
		yspeed = -10;
	}
	autocombo[i].run = function() {
		if state_timer == 30 {
			change_sprite(spr_naruto_attack_smash_kick,3,false);
		}
		if sprite == spr_naruto_flip {
			if (state_timer mod 5) == 0 {
				play_sound(snd_punch_whiff_light2,1,1.5);
			}
		}
		else if sprite == spr_naruto_attack_smash_kick {
			basic_smash(3,100,hiteffects.hit);
			land();
		}
	}
	i++;

	forward_throw = new state();
	forward_throw.start = function() {
		change_sprite(spr_naruto_spinkick_up,5,false);
		with(grabbed) {
			change_sprite(grabbed_head_sprite,1000,false);
			yoffset = -40;
			depth = other.depth + 1;
		}
		xspeed = 0;
		yspeed = 0;
	}
	forward_throw.run = function() {
		xspeed = 0;
		yspeed = 0;
		if state_timer < 20 {
			frame = 0;
		}
		grab_frame(0,10,0,0,false);
		if check_frame(2) {
			play_sound(snd_punch_whiff_heavy);
			play_voiceline(voice_heavyattack,100,true);
		}
		if check_frame(4) {
			var _hit = grabbed;
			release_grab(0,20,0,0,0);
			with(_hit) {
				get_hit(other,50,1,-10,attacktype.normal,attackstrength.heavy,hiteffects.hit);
			}
		}
		return_to_idle();
	}

	back_throw = new state();
	back_throw.start = function() {
		forward_throw.start();
	}
	back_throw.run = function() {
		if check_frame(1) facing = -facing;
		forward_throw.run();
	}

	shadow_clone_jutsu = new state();
	shadow_clone_jutsu.start = function() {
		if check_mp(2) and (!shadow_clone_jutsu_cooldown) {
			change_sprite(spr_naruto_jutsu,5,false);
			activate_super();
			spend_mp(2);
			play_sound(snd_jutsu_activate);
		}
		else {
			change_state(previous_state);
		}
	}
	shadow_clone_jutsu.run = function() {
		if check_frame(3) {
			create_helper(
				-width,
				0,
				init_naruto_baseform_clone
			);
			create_helper(
				width,
				0,
				init_naruto_baseform_clone
			);
		}
		if superfreeze_active {
			if frame > 5 { 
				frame = 4;
			}
		}
		return_to_idle();
	}

	setup_autocombo();

	//add_move(mini_rasengan,"C");
	add_move(shadow_clone_jutsu,"D");

	//var i = 0;
	//voice_attack[i++] = snd_naruto_attack1;
	//voice_attack[i++] = snd_naruto_attack2;
	//voice_attack[i++] = snd_naruto_attack3;
	//voice_attack[i++] = snd_naruto_attack4;
	//voice_attack[i++] = snd_naruto_attack5;
	//i = 0;
	//voice_heavyattack[i++] = snd_naruto_heavyattack1;
	//voice_heavyattack[i++] = snd_naruto_heavyattack2;
	//voice_heavyattack[i++] = snd_naruto_heavyattack3;
	//i = 0;
	//voice_hurt[i++] = snd_naruto_hurt1;
	//voice_hurt[i++] = snd_naruto_hurt2;
	//voice_hurt[i++] = snd_naruto_hurt3;
	//voice_hurt[i++] = snd_naruto_hurt4;
	//voice_hurt[i++] = snd_naruto_hurt5;
	//i = 0;
	//voice_hurt_heavy[i++] = snd_naruto_hurt_heavy1;
	//voice_hurt_heavy[i++] = snd_naruto_hurt_heavy2;
	//voice_hurt_heavy[i++] = snd_naruto_hurt_heavy3;
	//voice_hurt_heavy[i++] = snd_naruto_hurt_heavy4;
	//voice_hurt_heavy[i++] = snd_naruto_hurt_heavy5;

	victory_state.run = function() {
		if frame >= anim_frames - 1
		and frame_timer >= frame_duration {
			frame = 3;
		}
	}

	draw_script = function() {
		gpu_set_blendmode(bm_normal);
	}
}