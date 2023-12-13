extends Area2D

const BOSS_ROOM : PackedScene = preload("res://room/boss_room/Boss_Room_manager.tscn");

func _process(delta: float) -> void:
	var diff : float = (global_position.x - GlobalInfo.player.global_position.x);
	modulate.a = 1.0 - (diff / 2500);
	
	if abs(diff) < 30:
		GlobalInfo.hard_coded_player_y__I_am_a_terrible_programmer = global_position.y - GlobalInfo.player.global_position.y;
		GlobalInfo.hard_coded_player_velocity__I_am_a_terrible_programmer = GlobalInfo.player.velocity;
		GlobalInfo.hard_coded_offset__I_am_a_terrible_programmer = GlobalInfo.camera.global_position - GlobalInfo.player.global_position;
		get_tree().change_scene_to_packed(BOSS_ROOM);

func _on_player_entered(_body: Node2D) -> void:
	set_process(true);

func _on_player_exited(_body: Node2D) -> void:
	modulate.a = 0.0;
	set_process(false);
