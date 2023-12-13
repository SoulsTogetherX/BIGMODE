extends VisibleOnScreenNotifier2D

@export var room : Node2D;

func _ready() -> void:
	room.visible = false;

func _on_screen_entered() -> void:
	room.visible = true;
	room.process_mode = Node.PROCESS_MODE_INHERIT;

func _on_screen_exited() -> void:
	room.visible = false;
	room.process_mode = Node.PROCESS_MODE_DISABLED;
