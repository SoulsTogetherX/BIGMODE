extends Node2D

const PLAYER_SET  : PackedScene = preload("res://src/objects/player/player_settup.tscn");
const START_ROOM  : PackedScene = preload("res://room/rooms/room_manager/rooms_broken/room1.tscn");
const ROOM_PATHS  : Array[String] = [
	"res://room/rooms/room_manager/rooms_broken/room2.tscn",
	"res://room/rooms/room_manager/rooms_broken/room3.tscn",
	"res://room/rooms/room_manager/rooms_broken/room4.tscn",
	"res://room/rooms/room_manager/rooms_broken/room5.tscn",
	"res://room/rooms/room_manager/rooms_broken/room6.tscn",
	"res://room/rooms/room_manager/rooms_broken/room7.tscn",
	"res://room/rooms/room_manager/rooms_broken/room8.tscn",
	"res://room/rooms/room_manager/rooms_broken/room9.tscn",
	"res://room/rooms/room_manager/rooms_broken/room10.tscn",
	"res://room/rooms/room_manager/rooms_broken/room11.tscn",
	"res://room/rooms/room_manager/rooms_broken/room12.tscn",
	"res://room/rooms/room_manager/rooms_broken/room13.tscn",
	"res://room/rooms/room_manager/rooms_broken/room14.tscn",
];

func _ready() -> void:
	TimeManager.adjust_sounds(TimeManager.default_time);
	call_deferred_thread_group("load_game");

func load_game() -> void:
	add_child(START_ROOM.instantiate());
	var player = PLAYER_SET.instantiate();
	add_child(player);
	
	for path in ROOM_PATHS:
		ResourceLoader.load_threaded_request(path);
	
	for path in ROOM_PATHS:
		add_child(ResourceLoader.load_threaded_get(path).instantiate());
	
	$Center.queue_free();
