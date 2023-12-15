extends Area2D

@export var minons : Array[Minon];
@export var flip : bool;

func _on_body_entered(body_ : Node2D) -> void:
	if not body_ is Player:
		return;
	
	for min_ in minons:
		if is_instance_valid(min_):
			min_.move = true;
			print(min_.global_position)
			if flip:
				min_.turn();
	queue_free();
