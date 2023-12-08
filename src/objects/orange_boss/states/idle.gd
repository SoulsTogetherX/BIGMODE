extends State

@export var fall       : State;
@export var transition : State;

var timer : Timer;
var wait : float;

func get_id():
	return "idle";

func state_ready() -> void:
	timer = Timer.new();
	timer.one_shot = true;
	add_child(timer);

func enter() -> void:
	_animationPlayer.play("idle");
	
	fall.return_state = self;
	timer.wait_time = wait;
	timer.start();

func exit() -> void:
	pass;

func process_physics(_delta: float) -> State:
	if timer.is_stopped():
		return transition;
	
	return null;

func process_frame(_delta: float) -> State:
	return null;
