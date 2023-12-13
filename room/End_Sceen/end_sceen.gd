extends Control

const ROOM_MANAGER : PackedScene = preload("res://room/rooms/room_manager/room_manager.tscn");
const MAIN_MENU : PackedScene = preload("res://room/Menu/menu/menu.tscn");

func _ready() -> void:
	$MarginContainer/time.text = "Final Time:\n" + TimeManager.get_timer_string(false, true, true, true, true);
	
	GlobalInfo.boss_room = false;
	GlobalInfo.hard_coded_flag_check__I_am_a_terrible_programmer = false;
	GlobalInfo.score = 0;
	GlobalInfo.player_health = GlobalInfo.player_max_health;
	TimeManager.time = 0;

func _on_try_again_pressed() -> void:
	$select.play();
	await $select.finished;
	
	get_tree().change_scene_to_packed(ROOM_MANAGER);

func _on_main_menu_pressed() -> void:
	$select.play();
	await $select.finished;
	
	get_tree().change_scene_to_packed(MAIN_MENU);
