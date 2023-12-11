extends State

@export var transition : State;

func get_id():
	return "cutscene_start";

func state_ready() -> void:
	_actor.activate_area.body_entered.connect(cutscene);

func cutscene(body : Node2D) -> void:
	var OG_pos = GlobalInfo.camera.position;
	
	GlobalInfo.cutscene = true;
	
	if GlobalInfo.cutscene_before:
		await get_tree().create_timer(0.5).timeout;
	else:
		await get_tree().create_timer(1.2).timeout;
	
	var tw = create_tween().set_parallel();
	tw.set_trans(Tween.TRANS_QUINT);
	tw.tween_property(GlobalInfo.camera, "offset", Vector2(0, -100), 0.7);
	tw.tween_property(GlobalInfo.camera, "global_position", _actor.global_position, 0.7);
	GlobalInfo.cutscene_before = true;
	GlobalInfo.camera.auto_follow = false;
	
	await get_tree().create_timer(0.5).timeout;
	
	_animationPlayer.play("intro");
	
	await get_tree().create_timer(0.1).timeout;
	GlobalInfo.camera.zoom_event(Vector2(0.8, 0.8), Vector2(1.3, 1.3));
	
	await _animationPlayer.animation_finished;
	await get_tree().create_timer(0.2).timeout;
	
	tw = create_tween().set_parallel();
	tw.set_trans(Tween.TRANS_QUINT);
	tw.tween_property(GlobalInfo.camera, "offset", Vector2(0, 0), 0.7);
	tw.tween_property(GlobalInfo.camera, "position", OG_pos, 0.7);
	GlobalInfo.camera.zoom_event(Vector2(0.2, 0.2), Vector2(0.8, 0.8));
	
	await get_tree().create_timer(0.3).timeout;
	
	GlobalInfo.cutscene = false;
	GlobalInfo.camera.auto_follow = true;
	
	_actor.activate_area.queue_free();
	get_parent()._change_state(transition);
