@tool
extends CameraFollow2D

func _ready() -> void:
	super();
	if !Engine.is_editor_hint():
		GlobalInfo.camera = self;
