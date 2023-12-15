extends Node

func _input(event: InputEvent) -> void:
		if event.is_action("jump") ||\
		event.is_action("shoot") ||\
		event.is_action("left") ||\
		event.is_action("right"):
			TimeManager.toggle_timer(true);
			queue_free();
