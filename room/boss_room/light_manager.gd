extends Node2D

var lights : Array[PointLight2D] = [];
var reference : Sprite2D;
var time : float = 0.0;

const oneThrid : float = 0.333333;

var tw : Tween;

func _ready() -> void:
	reference = $lights;
	lights.append($lights_full/PointLight2D1);
	lights.append($lights_full/PointLight2D2);
	lights.append($lights_full/PointLight2D3);
	
	set_process(false);

func run_lights() -> void:
	material.set_shader_parameter("num", 2);
	set_process(true);
	
	tw = create_tween().set_parallel();
	for idx in lights.size():
		if idx == 0:
			tw.tween_method(foo, 0.0, 3.0, 5);
		else:
			tw.tween_property(lights[idx], "color:a", 3.0, 5);
	tw.tween_property(self, "modulate:a", 3.0, 5);

func fade_lights() -> void:
	tw = create_tween().set_parallel();
	for idx in lights.size():
		if idx == 0:
			tw.tween_method(foo, 1.0, 0.0, 1);
		else:
			tw.tween_property(lights[idx], "color:a", 0.0, 1);
	tw.tween_property(self, "modulate:a", 0.0, 1);
	
	await tw.finished;
	material.set_shader_parameter("num", 0);
	set_process(false);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta;
	material.set_shader_parameter("time", time);
	
	var offset = fmod((time * 0.5), 0.5);
	for idx in lights.size():
		lights[idx].global_position = reference.global_position;
		lights[idx].global_position.x += (fmod((0.5 * (idx - 1) + offset), 1.0) - 0.5) * reference.scale.x;
	
	if !tw.is_running():
		if lights[0].global_position.x < reference.global_position.x - (reference.scale.x * 0.5):
			lights[0].color.a = 0.0;
		else:
			lights[0].color.a = 1.0;

func foo(light : float) -> void:
	if lights[0].global_position.x < reference.global_position.x - (reference.scale.x * 0.5):
		lights[0].color.a = 0.0;
	else:
		lights[0].color.a = light;
