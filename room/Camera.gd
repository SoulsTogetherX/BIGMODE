@tool
extends CameraFollow2D

func _ready() -> void:
	GlobalInfo.camera = self;
