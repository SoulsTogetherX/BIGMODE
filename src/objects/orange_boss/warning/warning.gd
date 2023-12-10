extends Node2D

var tween : Tween;

@onready var background: Sprite2D = $background

func warn() -> void:
	if tween:
		tween.kill();
	tween = create_tween();
	
	tween.set_trans(Tween.TRANS_SINE).set_loops(3);
	tween.tween_property(background, "modulate", Color.RED, 0.1);
	tween.tween_property(background, "modulate", Color.YELLOW, 0.1);
