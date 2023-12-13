extends Node

const ROOM_PATH : String = "res://room/boss_room/boss_room.tscn";

func _enter_tree() -> void:
	GlobalInfo.boss_room = true;

func _ready() -> void:
	add_child(load(ROOM_PATH).instantiate());
	ResourceLoader.load_threaded_request(ROOM_PATH);

func _exit_tree() -> void:
	GlobalInfo.boss_room = false;

func _free_childrend() -> void:
	for c in get_children():
		c.queue_free();

func refresh() -> void:
	_free_childrend();
	await add_child(ResourceLoader.load_threaded_get(ROOM_PATH).instantiate());
	ResourceLoader.load_threaded_request(ROOM_PATH);
	
