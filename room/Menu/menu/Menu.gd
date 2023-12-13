extends Node2D

const ROOM_MANAGER : String = "res://room/rooms/room_manager/room_manager.tscn";

var start_menu : PackedScene;
const START_MENU_PATH     : String = "res://room/Menu/start_menu/start_menu.tscn";

var credit_menu : PackedScene;
const CREDITS_PATH        : String = "res://room/Menu/credits/credits.tscn";

var settings_menu : PackedScene;
const SETTING_PATH        : String = "res://room/Menu/settings/settings.tscn";

@onready var select   : AudioStreamPlayer = $select;
@onready var deselect : AudioStreamPlayer = $deselect;

const menu_theme : AudioStream = preload("res://asset/music/menu_music.mp3");

func _ready() -> void:
	ResourceLoader.load_threaded_request(START_MENU_PATH);
	ResourceLoader.load_threaded_request(CREDITS_PATH);
	ResourceLoader.load_threaded_request(SETTING_PATH);
	
	start_menu = ResourceLoader.load_threaded_get(START_MENU_PATH);
	var child : Node2D = start_menu.instantiate();
	add_child(child);
	child.play.connect(_switch_to_play);
	child.settings.connect(_switch_to_settings);
	child.credits.connect(_switch_to_credits);
	
	settings_menu  = ResourceLoader.load_threaded_get(SETTING_PATH);
	credit_menu    = ResourceLoader.load_threaded_get(CREDITS_PATH);
	
	ResourceLoader.load_threaded_request(ROOM_MANAGER);
	
	SoundManager.set_music(menu_theme);
	SoundManager.play_music();

func _free_childrend() -> void:
	for c in get_children():
		if c is AudioStreamPlayer:
			continue;
		
		c.queue_free();

func _switch_to_play() -> void:
	select.play();
	await Transition.fade_in(0.5);
	
	SoundManager.stop();
	_free_childrend();
	
	var packed : PackedScene = ResourceLoader.load_threaded_get(ROOM_MANAGER);
	get_tree().change_scene_to_packed(packed)
	
	Transition.fade_out(0.5);

func _switch_to_start_menu() -> void:
	if !start_menu:
		return;
	
	deselect.play();
	_free_childrend();
	
	var child : Node2D = start_menu.instantiate();
	add_child(child);
	
	child.play.connect(_switch_to_play);
	child.settings.connect(_switch_to_settings);
	child.credits.connect(_switch_to_credits);

func _switch_to_settings() -> void:
	if !settings_menu:
		return;
	
	select.play();
	_free_childrend();
	
	var child : Node2D = settings_menu.instantiate();
	add_child(child);
	
	child.start.connect(_switch_to_start_menu);

func _switch_to_credits() -> void:
	if !credit_menu:
		return;
	
	select.play();
	_free_childrend();
	
	var child : Node2D = credit_menu.instantiate();
	add_child(child);
	
	child.start.connect(_switch_to_start_menu);
