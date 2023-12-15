extends CanvasLayer

var _fading : bool = false;
var tw : Tween;
@onready var shade : ShaderMaterial = $Transition.material;

signal finish_in_fade();
signal finish_out_fade();

func transitioning() -> bool:
	return _fading;

func _ready() -> void:
	shade.set_shader_parameter("circle_size", 1.0);

func fade_in(time : float = 0.5) -> void:
	if tw:
		#tw.finished.emit();
		tw.kill();
	_fading = true;
	
	tw = create_tween();
	tw.tween_property(shade, "shader_parameter/circle_size", 0.0, time);
	await tw.finished;
	_fading = false;
	finish_in_fade.emit();

func fade_out(time : float = 0.5) -> void:
	if tw:
		#tw.finished.emit();
		tw.kill();
	_fading = true;
	
	tw = create_tween();
	tw.tween_property(shade, "shader_parameter/circle_size", 1.0, time);
	await tw.finished;
	_fading = false;
	finish_out_fade.emit();
