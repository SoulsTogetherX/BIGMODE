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
	
	SoundManager.set_music(load("res://asset/music/level_music.mp3"));
	SoundManager.play_music();
	SoundManager.volume_db = -40;
	
	var tw = create_tween();
	tw.set_trans(Tween.TRANS_EXPO);
	tw.tween_property(SoundManager, "volume_db", 0.0, 4);

func load_game() -> void:
	add_child(START_ROOM.instantiate());
	
	var player = PLAYER_SET.instantiate();
	add_child(player);
	
	call_deferred("load_next", 0);
	
	$Center.queue_free();

func load_next(indx : int) -> void:
	if indx >= ROOM_PATHS.size():
		return;
	
	ResourceLoader.load_threaded_request(ROOM_PATHS[indx]);
	var room = ResourceLoader.load_threaded_get(ROOM_PATHS[indx]).instantiate();
	add_child(room);
	call_deferred_thread_group("load_next", indx + 1);

func _exit_tree() -> void:
	for path in ROOM_PATHS:
		ResourceLoader.load_threaded_get(path);
