extends State

@export var attack1 : State;
@export var attack2 : State;
@export var idle : State;
@export var jump : State;
@export var spawn : State;
@export var walk : State;

var state_queue : Array = [];
var timer : Timer;

var move_to_state : State = null;
var delay = 0;

var cutscene_2 : bool = false;

func get_id():
	return "transition";

func state_ready() -> void:
	timer = Timer.new();
	add_child(timer);

func enter() -> void:
	if cutscene_2:
		cutscene_2 = false;
		state_queue = [
						[Boss.ACTION.JUMP, 0.7, _actor.get_jump_target(false)],
						[Boss.ACTION.ATTACK2, 1.5],
						[Boss.ACTION.JUMP, 0.2, _actor.floor_mid_marker],
					  ]
	
	if state_queue.size() == 0:
		state_queue = _actor.prioirtize();
	if delay == 0:
		delay = state_queue.back()[1];
		get_move_to_state();
		return;
	get_tree().create_timer(delay).timeout.connect(get_move_to_state);
	delay = state_queue.back()[1];

func exit() -> void:
	move_to_state = null;

func process_physics(_delta : float) -> State:
	return move_to_state;

func get_move_to_state() -> void:
	var info = state_queue.pop_back();
	
	match info[0]:
		Boss.ACTION.ATTACK1:
			_actor.turn(GlobalInfo.player.global_position > _actor.global_position);
			move_to_state = attack1;
		Boss.ACTION.ATTACK2:
			_actor.turn(GlobalInfo.player.global_position > _actor.global_position);
			move_to_state = attack2;
		Boss.ACTION.IDLE:
			_actor.turn(GlobalInfo.player.global_position > _actor.global_position);
			move_to_state = idle;
		Boss.ACTION.JUMP:
			jump.target = info[2];
			move_to_state = jump;
		Boss.ACTION.SPAWN:
			_actor.warning.warn();
			move_to_state = spawn;
		Boss.ACTION.WALK:
			walk.target_x = info[2];
			move_to_state = walk;
