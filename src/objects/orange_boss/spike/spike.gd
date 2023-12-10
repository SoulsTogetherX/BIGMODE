@tool
extends Node2D

@export var jump_pos    : Marker2D = null;
@export var immediate   : bool     = true;

@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	if jump_pos != null && !Engine.is_editor_hint():
		jump_pos.spikes.append(self);
	
	if immediate || Engine.is_editor_hint():
		visible = true;
		animations.play("idle");

func start(delay : float = 0) -> void:
	if delay != 0:
		await get_tree().create_timer(delay).timeout;
	animations.play("start");
	#audio.play();

func end() -> void:
	animations.play("end");

func _victum_entered(body: Node2D) -> void:
	if body is Player:
		body.kill();
	elif body is Minon:
		body.spike_kill();
