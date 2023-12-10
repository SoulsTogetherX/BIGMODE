extends AnimateState

@export var transition : State;

@onready var mod = $"../../../danger_mod";

var charge_up : Tween;

func get_id():
	return "attack1";

func state_ready() -> void:
	pass;

func get_animation() -> String:
	return "attack1";

func enter() -> void:
	charge_up = create_tween();
	charge_up.tween_property(_actor, "modulate", Color("#ff4646"), 0.7).set_delay(0.2);
	charge_up.tween_property(_actor, "modulate", Color.WHITE, 0.1);

func on_end_animation() -> State:
	_animationPlayer.play("attack1_hold");
	if mod.shown:
		mod.hide_danger_shape(0.6);
	return transition;

