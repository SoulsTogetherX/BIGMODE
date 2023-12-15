@tool
extends Node2D

@export var bounce : Vector2:
	set(val):
		bounce = val;
		queue_redraw();

var scale_OG : Vector2;
@onready var audio : AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	scale_OG = scale;

func _on_enter(body: Node2D) -> void:
	body.velocity = bounce;
	body.body_overhead.change_state("main", "fall");
	
	var tw = create_tween();
	tw.set_trans(Tween.TRANS_SINE);
	tw.tween_property(self, "scale", scale_OG * Vector2(0.6, 4), 0.2);
	tw.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2);
	
	audio.play();

