extends AnimateState

func get_id():
	return "ded";

const _particle : PackedScene = preload("res://asset/particles/score_particle.tscn");

func enter() -> void:
	if !is_instance_valid(GlobalInfo.player):
		return;
	
	GlobalInfo.increase_score(250);
	var part = _particle.instantiate();
	add_child(part);
	part.fade_this();
	part.emitting = true;
	part.global_position = _actor.global_position;

func get_animation() -> String:
	return "ded";
