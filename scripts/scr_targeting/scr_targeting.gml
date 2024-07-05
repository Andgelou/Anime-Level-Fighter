// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function chars_update_targeting() {
	with(obj_char) {
		if target_exists() {
			target_x = target.x;
			target_y = target.y;
			target_distance_x = max(abs(x-target_x) - (width_half+target.width_half),0);
			target_distance_y = target_y - y;
			target_distance = target_distance_x + abs(target_distance_y);
			target_direction = point_direction(x,y-height_half,target_x,target_y-target.height_half);
		}
	}
}

function target_exists() {
	if instance_exists(target) {
		return true;
	}
	else {
		target = noone;
		return false;
	}
}

function face_target() {
	if target_exists() {
		if x < target.x {
			facing = 1;
		}
		else if x > target.x {
			facing = -1;
		}
	}
}