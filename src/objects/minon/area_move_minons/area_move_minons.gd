extends Area2D

@export var minons : Array[Minon];

func _on_body_entered(body: Node2D) -> void:
	for min in minons:
		if is_instance_valid(min):
			min.move = true;
	queue_free();
