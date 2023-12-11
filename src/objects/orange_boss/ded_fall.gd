extends State

@export var ded : State;

@onready var land_emitter: Emitter = $"../../../Sprite2D/land_emitter"

func get_id():
	return "ded_fall";

func enter() -> void:
	GlobalInfo.cutscene = true;
	
	await get_tree().create_timer(1.2).timeout;
	
	var tw = create_tween().set_parallel();
	tw.set_trans(Tween.TRANS_QUINT);
	tw.tween_property(GlobalInfo.camera, "offset", Vector2(0, -100), 0.7);
	tw.tween_property(GlobalInfo.camera, "global_position", _actor.global_position, 0.7);
	GlobalInfo.camera.auto_follow = false;
	
	await get_tree().create_timer(0.5).timeout;
	
	_animationPlayer.play("ded");

func process_physics(delta: float) -> State:
	if _actor.on_floor():
		return ded;
	
	_actor.velocity.y += _actor.GRAVITY * delta;
	
	return null;
