extends Node2D

var velocity_x : float = 0.0;
var animate : Tween;

func init(speed : float, dir : bool = false) -> void:
	scale.y = 0.0;
	modulate.a = 0.0;
	
	animate = create_tween().set_parallel();
	animate.tween_property(self, "modulate:a", 1.0, 0.3);
	animate.tween_property(self, "scale:y", 1.0, 0.2);
	animate.tween_callback(set_loop_animate).set_delay(0.3);
	
	$Sprite2D.flip_h = dir;
	
	velocity_x = speed * (1 if dir else -1);

func set_loop_animate() -> void:
	if animate:
		animate.kill();
	
	scale.y = 1.0;
	
	animate = create_tween().set_loops();
	animate.set_trans(Tween.TRANS_SPRING);
	animate.tween_property(self, "scale:y", 0.8, 0.5);
	animate.tween_property(self, "scale:y", 1.2, 0.5);

func _physics_process(delta: float) -> void:
	position.x += velocity_x * delta;
