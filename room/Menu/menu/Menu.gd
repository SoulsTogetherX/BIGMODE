extends Node2D

const ROOM_PATHS : Array[String] = [
	"res://room/rooms/room_1/room_1.tscn",
];

var start_menu : PackedScene;
const START_MENU_PATH     : String = "res://room/Menu/start_menu/start_menu.tscn";

var credit_menu : PackedScene;
const CREDITS_PATH        : String = "res://room/Menu/credits/credits.tscn";

var settings_menu : PackedScene;
const SETTING_PATH        : String = "res://room/Menu/settings/settings.tscn";

func _ready() -> void:
	ResourceLoader.load_threaded_request(START_MENU_PATH);
	ResourceLoader.load_threaded_request(CREDITS_PATH);
	ResourceLoader.load_threaded_request(SETTING_PATH);
	
	start_menu = ResourceLoader.load_threaded_get(START_MENU_PATH);
	_switch_to_start_menu();
	
	settings_menu  = ResourceLoader.load_threaded_get(SETTING_PATH);
	credit_menu    = ResourceLoader.load_threaded_get(CREDITS_PATH);
	
	for path in ROOM_PATHS:
		ResourceLoader.load_threaded_request(path);

func _free_childrend() -> void:
	for c in get_children():
		c.queue_free();

func _switch_to_play() -> void:
	_free_childrend();
		
	for path in ROOM_PATHS:
		add_child(ResourceLoader.load_threaded_get(path).instantiate());

func _switch_to_start_menu() -> void:
	if !start_menu:
		return;
	
	_free_childrend();
	var child : Node2D = start_menu.instantiate();
	add_child(child);
	
	child.play.connect(_switch_to_play);
	child.settings.connect(_switch_to_settings);
	child.credits.connect(_switch_to_credits);

func _switch_to_settings() -> void:
	if !settings_menu:
		return;
	
	_free_childrend();
	var child : Node2D = settings_menu.instantiate();
	add_child(child);
	
	child.start.connect(_switch_to_start_menu);

func _switch_to_credits() -> void:
	if !credit_menu:
		return;
	
	_free_childrend();
	var child : Node2D = credit_menu.instantiate();
	add_child(child);
	
	child.start.connect(_switch_to_start_menu);
