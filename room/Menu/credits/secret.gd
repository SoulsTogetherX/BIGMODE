extends Area2D

@onready var secret : AudioStreamPlayer = $secret_sound;

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if secret.playing:
		return;
	
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
		secret.play();
