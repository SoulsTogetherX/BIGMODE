extends CanvasLayer

var tw : Tween;
@onready var shade : ShaderMaterial = $Transition.material;

func _ready() -> void:
	shade.set_shader_parameter("circle_size", 1.0);

func fade_in(time : float) -> void:
	var tw = create_tween();
	tw.tween_property(shade, "shader_parameter/circle_size", 0.0, time);
	await tw.finished;

func fade_out(time : float) -> void:
	var tw = create_tween();
	tw.tween_property(shade, "shader_parameter/circle_size", 1.0, time);
