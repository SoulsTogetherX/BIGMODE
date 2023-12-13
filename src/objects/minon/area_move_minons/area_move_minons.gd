extends Area2D

@export var minons : Array[Minon];
@export var flip : bool;

func _on_body_entered(body: Node2D) -> void:
	for min in minons:
		if is_instance_valid(min):
			min.move = true;
			if flip:
				min.turn();
	queue_free();
