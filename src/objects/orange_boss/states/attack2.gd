extends AnimateState

@export var transition : State;

var charge_up : Tween;

func get_id():
	return "attack2";

func state_ready() -> void:
	pass;

func get_animation() -> String:
	return "attack2";

func enter() -> void:
	charge_up = create_tween();
	charge_up.tween_property(_actor, "modulate", Color("#ff4646"), 0.9);
	charge_up.tween_property(_actor, "modulate", Color.WHITE, 0.3);

func on_end_animation() -> State:
	return transition;
