extends Sprite2D

func _on_area_2d_body_entered(_body: Node2D) -> void:
	$"../CollisionShape2D".disabled = true;
	var tw : Tween = create_tween();
	tw.tween_property(self, "position:y", 1935, 1.5);
	tw.tween_callback($"..".queue_free);
