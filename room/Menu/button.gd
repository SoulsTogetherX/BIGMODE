extends Button

@onready var sprite = $sprite;

func _ready() -> void:
	sprite.frame = 0;

func _on_mouse_entered() -> void:
	sprite.frame = 1;

func _on_mouse_exited() -> void:
	sprite.frame = 0;
