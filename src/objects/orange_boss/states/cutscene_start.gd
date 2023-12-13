extends State

const menu_theme : AudioStream = preload("res://asset/music/boss_music.mp3");

@export var transition : State;

func get_id():
	return "cutscene_start";

func state_ready() -> void:
	_actor.activate_area.body_entered.connect(cutscene);

func cutscene(body : Node2D) -> void:
	GlobalInfo.hard_coded_flag_check__I_am_a_terrible_programmer = true;
	
	var OG_pos = GlobalInfo.camera.position;
	var OG_health_pos = _actor.health_bar.position.x;
	GlobalInfo.cutscene = true;
	
	if GlobalInfo.cutscene_before:
		await get_tree().create_timer(0.5).timeout;
	else:
		await get_tree().create_timer(1.2).timeout;
	
	_actor.health_bar.position.x += _actor.health_bar.size.x * 0.5;
	_actor.health_bar.scale.x = 0;
	_actor.health_bar.visible = true;
	
	var tw = create_tween().set_parallel();
	tw.set_trans(Tween.TRANS_QUINT);
	tw.tween_property(GlobalInfo.camera, "offset", Vector2(0, -100), 0.7);
	tw.tween_property(GlobalInfo.camera, "global_position", _actor.global_position, 0.7);
	tw.tween_property(_actor.health_bar, "scale:x", 1, 2).set_delay(1.0);
	tw.tween_property(_actor.health_bar, "position:x", OG_health_pos, 2).set_delay(1.0);
	GlobalInfo.cutscene_before = true;
	GlobalInfo.camera.auto_follow = false;
	
	await get_tree().create_timer(0.5).timeout;
	
	_animationPlayer.play("intro");
	
	await get_tree().create_timer(0.1).timeout;
	GlobalInfo.camera.zoom_event(Vector2(0.8, 0.8), Vector2(1.3, 1.3));
	
	await _animationPlayer.animation_finished;
	
	tw = create_tween().set_parallel();
	tw.set_trans(Tween.TRANS_QUINT);
	tw.tween_property(GlobalInfo.camera, "offset", Vector2(0, 0), 0.7);
	tw.tween_property(GlobalInfo.camera, "position", OG_pos, 0.7);
	GlobalInfo.camera.zoom_event(Vector2(0.2, 0.2), Vector2(0.8, 0.8));
	
	await get_tree().create_timer(0.5).timeout;
	
	GlobalInfo.cutscene = false;
	GlobalInfo.camera.auto_follow = true;
	
	_actor.activate_area.queue_free();
	transition.state_queue = [[Boss.ACTION.JUMP, 0.2, _actor.floor_mid_marker]]
	
	get_parent()._change_state(transition);
	
	SoundManager.set_music(menu_theme);
	SoundManager.play_music();
