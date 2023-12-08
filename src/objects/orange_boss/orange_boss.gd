class_name Boss extends CharacterBody2D

const GRAVITY : int =  980;

var max_health : int = 100;
var health : int = max_health;

@onready var danger_mod: Area2D = $danger_mod
@onready var sprite: Sprite2D = $Sprite2D
@onready var body: Sprite2D = $Sprite2D
@onready var shoulder: CollisionShape2D = $shoulder
@onready var floor_detect: Area2D = $floor_detect

func shot_at() -> void:
	health -= 1;
	if health == 0:
		die();
	else:
		var tw = create_tween();
		tw.set_trans(Tween.TRANS_SINE);
		tw.tween_property(sprite, "modulate", Color("#ff4646"), 0.05);
		tw.tween_property(sprite, "modulate", Color.WHITE, 0.05);

func die() -> void:
	queue_free();

func turn(left : bool) -> void:
	body.flip_h = left;

func get_walk_pos(max_walk : float = 1000) -> float:
	var target = GlobalInfo.player.position.x + 100 * sign(position.x - GlobalInfo.player.position.x);
	if abs(target) > 672:
		target = 672 * sign(target);
	target = clamp(target, position.x - max_walk, position.x + max_walk);
	
	return target;

func get_jump_target() -> Marker2D:
	return get_tree().get_nodes_in_group("Jump_point").pick_random();

func on_floor() -> bool:
	return !floor_detect.get_overlapping_bodies().is_empty();

const shock_scene : PackedScene = preload("res://src/objects/orange_boss/shockwave/shockwave.tscn");
func create_shockwave() -> void:
	var shock : Node2D = shock_scene.instantiate();
	get_tree().current_scene.add_child(shock);
	shock.init(300, false);
	shock.global_position = global_position;
	
	shock = shock_scene.instantiate();
	get_tree().current_scene.add_child(shock);
	shock.init(300, true);
	shock.global_position = global_position;

const minon_scene : PackedScene = preload("res://src/objects/minon/minon.tscn");
func spawn_minons(spawn_falling : bool = false) -> void:
	for node_info in get_tree().get_nodes_in_group("spawner_node"):
		var minion : Minon = minon_scene.instantiate();
		get_tree().current_scene.add_child(minion);
		minion.global_position = node_info.global_position;
		
		minion.move = true;
		minion.fall_move = true;
		minion.face_left = node_info.get_meta("left", false);
