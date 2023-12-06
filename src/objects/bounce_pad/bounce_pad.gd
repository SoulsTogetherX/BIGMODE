@tool
extends Node2D

@export var bounce : Vector2:
	set(val):
		bounce = val;
		queue_redraw();
func _draw() -> void:
	draw_line(Vector2.ZERO, bounce / 10, Color.CRIMSON, 2);

func _on_enter(body: Node2D) -> void:
	body.velocity += bounce;

