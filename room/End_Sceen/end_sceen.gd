extends Control

const ROOM_MANAGER : PackedScene = preload("res://room/rooms/room_manager/room_manager.tscn");
const MAIN_MENU : PackedScene = preload("res://room/Menu/menu/menu.tscn");

func _ready() -> void:
	$MarginContainer/time.text = "Final Time:\n" + TimeManager.get_timer_string(true, true, true, true);
	
	GlobalInfo.reset_values();
	SoundManager.set_music(load("res://asset/music/end_music.wav"));
	SoundManager.play_music();

func _on_try_again_pressed() -> void:
	$select.play();
	await $select.finished;
	
	get_tree().change_scene_to_packed(ROOM_MANAGER);

func _on_main_menu_pressed() -> void:
	$select.play();
	await $select.finished;
	
	get_tree().change_scene_to_packed(MAIN_MENU);
