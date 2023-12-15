extends Node

@onready var root : MarginContainer = $MarginContainer;

func _ready() -> void:
	root.visible = false;

func pause() -> void:
	TimeManager.pause(true);
	GlobalInfo.cutscene = true;
	root.visible = true;
	
func unpause() -> void:
	TimeManager.pause(false);
	GlobalInfo.cutscene = false;
	root.visible = false;

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if Engine.time_scale == 0.0:
			unpause();
		else:
			pause()
		set_process_input(false);

const ROOM_MANAGER_PATH : String = "res://room/rooms/room_manager/room_manager.tscn";
func _on_restart_pressed() -> void:
	unpause();
	await Transition.fade_in(0.5);
	Transition.fade_out(0.5);
	
	GlobalInfo.reset_values();
	get_tree().change_scene_to_file(ROOM_MANAGER_PATH);

const MAIN_MENU_PATH : String = "res://room/Menu/menu/menu.tscn";
func _on_main_menu_pressed() -> void:
	unpause();
	await Transition.fade_in(0.5);
	Transition.fade_out(0.5);
	
	GlobalInfo.reset_values();
	get_tree().change_scene_to_file(MAIN_MENU_PATH);

func _on_last_flag_pressed() -> void:
	GlobalInfo.respawn();
	unpause();
	set_process_input(true);

func _on_resume_pressed() -> void:
	unpause();
	set_process_input(true);
