@tool
extends NinePatchRect

@onready var shape : CollisionShape2D = $Oneway/CollisionShape2D;

func _ready() -> void:
	shape.position.x = size.x * 0.5;
	shape.shape = RectangleShape2D.new();
	shape.shape.size = Vector2(size.x, 2);

func _on_resized() -> void:
	size.y = 15;
	shape.shape.size.x = size.x;
	shape.position.x = size.x * 0.5;
