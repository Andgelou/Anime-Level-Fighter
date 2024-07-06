/// @description Insert description here
// You can write your code in this editor

max_hp = 1000;
hp = max_hp;
previous_hp = hp;
hp_percent = map_value(hp,0,max_hp,0,100);
dead = false;

team = 1;
target = noone;
target_x = 0;
target_y = 0;
target_distance = 0;
target_distance_x = 0;
target_distance_y = 0;
target_direction = 0;

input_up = false;
input_down = false;
input_left = false;
input_right = false;
input_forward = false;
input_back = false;

input_a = false;
input_b = false;
input_c = false;
input_d = false;

hurtbox = noone;
hitbox = noone;

mask_index = spr_charbox;

hitstun = 0;
blockstun = 0;

is_hit = false;

is_blocking = false;
can_block = true;

grabbed = noone;
grab_connect_state = noone;

hitstop = 0;

combo_hits = 0;
combo_damage = 0;
combo_hits_taken = 0;
combo_damage_taken = 0;

invincible = false;
dodging_attacks = false;
deflecting_attacks = false;

immune_to_projectiles = false;
dodging_projectiles = false;
deflecting_projectiles = false;
	
input_buffer = "";
input_buffer_timer = 0;
	
movelist[0][0] = noone;
cancelable_moves = ds_list_create();
can_cancel = true;

air_moves = 0;
max_air_moves = 1;

ygravity_mod = 1;

level = 1;

attack_power = 1;
defense = 1;

char_script = function() {};
draw_script = function() {};

weapon_sprite = spr_sword_blue;
weapon_enabled = false;

init_physics();
init_charsprites("goku");
init_charstates();
init_charaudio();

ai_enabled = false;
ai_timer = 0;
ai_script = function() {};