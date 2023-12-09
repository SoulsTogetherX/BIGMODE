extends Node2D

@onready var floor_checker: RayCast2D = $floor_checker

var velocity_x : float = 0.0;
var animate : Tween;

func _physics_process(delta: float) -> void:
	if !floor_checker.is_colliding():
		end_animate();
		return;
	
	position.x += velocity_x * delta;
	if -1088 > position.x || position.x > 1088:
		queue_free();

func _ready() -> void:
	set_physics_process(false);

func init(speed : float, dir : bool = false) -> void:
	scale.y = 0.0;
	modulate.a = 0.0;
	
	animate = create_tween().set_parallel();
	animate.tween_property(self, "modulate:a", 1.0, 0.3);
	animate.tween_property(self, "scale:y", 1.0, 0.2);
	animate.tween_callback(set_loop_animate).set_delay(0.3);
	
	$origin/Sprite2D.flip_h = dir;
	
	floor_checker.position.x = 35 * (1 if dir else -1);
	floor_checker.force_raycast_update();
	
	velocity_x = speed * (1 if dir else -1);
	
	set_physics_process(true);

func set_loop_animate() -> void:
	if animate:
		animate.kill();
	
	var sprite = $origin;
	
	animate = create_tween().set_loops();
	animate.set_trans(Tween.TRANS_SPRING);
	animate.tween_property(sprite, "scale:y", 0.8, 0.5);
	animate.tween_property(sprite, "scale:y", 1.2, 0.5);

func end_animate() -> void:
	set_physics_process(false);
	if animate:
		animate.kill();
		
	animate = create_tween();
	animate.tween_property(self, "scale:y", 0.0, 0.5);
	animate.tween_callback(queue_free);
