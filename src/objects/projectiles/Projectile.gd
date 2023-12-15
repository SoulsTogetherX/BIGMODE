class_name Projectile extends Node2D

@onready var _detector : Area2D         = $CollisionDetection;
@onready var _particle : CPUParticles2D = $BulletParticle

@export var continous_collition_checking : bool = false:
	set(val):
		continous_collition_checking = val;
		set_physics_process(continous_collition_checking);

func set_timer(max_duration : float) -> void:
	if max_duration > 0:
		var timer = Timer.new();
		timer.wait_time = max_duration;
		timer.timeout.connect(on_dissipate);
		timer.autostart = true;
		add_child(timer);

func _ready() -> void:
	set_physics_process(continous_collition_checking);

func destroy(fade_particle : bool = true) -> void:
	if fade_particle && _particle:
		_particle.fade_this();
	queue_free();

func on_collide(_collide : Node2D) -> void:
	destroy();

func on_dissipate() -> void:
	destroy();

func _move_to(_delta : float) -> void:
	pass;

func _physics_process(delta : float) -> void:
	_move_to(delta);
	_find_collitions();

func _find_collitions() -> bool:
	for collide in _detector.get_overlapping_bodies():
		on_collide(collide);
		return true;
	return false;
