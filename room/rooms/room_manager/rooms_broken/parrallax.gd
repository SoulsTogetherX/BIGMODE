extends Sprite2D

@onready var pos = global_position.x;

@export var parral_scale : float = 1.0;

func _process(delta: float) -> void:
	global_position.x = lerp(GlobalInfo.player.global_position.x, pos, parral_scale);
