extends State

@export var attack1 : State;
@export var attack2 : State;
@export var idle : State;
@export var jump : State;
@export var walk : State;

var state_queue : Array[State] = [];

func get_id():
	return "transition";

func state_ready() -> void:
	pass;

func enter() -> void:
	pass;

func exit() -> void:
	pass;

func process_input(event: InputEvent) -> State:
	if Input.is_action_pressed("1"):
		print("attack1");
		return attack1;
	if Input.is_action_pressed("2"):
		print("attack2");
		return attack2;
	if Input.is_action_pressed("3"):
		print("idle");
		idle.wait = 2.5;
		return idle;
	if Input.is_action_pressed("4"):
		print("jump");
		jump.target = _actor.get_jump_target();
		
		return jump;
	if Input.is_action_pressed("5"):
		print("walk");
		walk.target_x = _actor.get_walk_pos();
		
		return walk;
	
	return null;

func process_physics(_delta: float) -> State:
	return null;

func process_frame(_delta: float) -> State:
	return null;

func update() -> State:
	return null;
