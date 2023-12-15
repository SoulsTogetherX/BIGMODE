extends Area2D

func _on_body_entered(_body: Node2D) -> void:
	$"../../Boss_door".visible = true;
	GlobalInfo.camera.shake_event(Vector3(0.1, 0.1, 0.0), Vector3(5., 5., 0), Vector3.ZERO);
	$"../../Boss_door/StaticBody2D2/CollisionShape2D3".position = Vector2(-952, -64);
	queue_free();
