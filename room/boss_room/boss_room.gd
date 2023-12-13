extends Node2D

const END_SCEEN_PATH : String = "res://room/End_Sceen/end_sceen.tscn";

func _ready() -> void:
	GlobalInfo.boss_room = true;
	
	ResourceLoader.load_threaded_request(END_SCEEN_PATH);
	
	GlobalInfo.player.global_position.y = (global_position.y + 49) - GlobalInfo.hard_coded_player_y__I_am_a_terrible_programmer;
	GlobalInfo.player.velocity = GlobalInfo.hard_coded_player_velocity__I_am_a_terrible_programmer;
	GlobalInfo.camera.global_position = GlobalInfo.player.global_position + GlobalInfo.hard_coded_offset__I_am_a_terrible_programmer;
	
	var tw = create_tween();
	tw.tween_property(GlobalInfo.camera, "limit_bottom", 320, 3.0);
	
	if GlobalInfo.hard_coded_flag_check__I_am_a_terrible_programmer:
		GlobalInfo.player.global_position = GlobalInfo.respawn_pos;

func switch_to_end() -> void:
	if ResourceLoader.has_cached(END_SCEEN_PATH):
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(END_SCEEN_PATH));
