extends State

var gravity : float = 980.0;
var start_jump_speed : float = 100;
var jump_speed : float;

@export var fall : State;
@export var idle : State;

var quotes : QuotesInfo = QuotesInfo.new();

func get_id():
	return "jump";

func state_ready() -> void:
	quotes = QuotesInfo.new();
	quotes.quotes = [
		["Jump", 8],
		["Boing", 6],
		["Bounce", 6],
		["Liftoff", 2.5],
		["Higher!", 2.5],
		["10/10 jump", 1.],
		["Jamp", 1.2],
		["[Insert insult here]", 0.1]
		];

func enter() -> void:
	_actor.velocity.y = _actor.JUMP_VELOCITY;
	_actor.coyote_timer.stop();
	_actor.jump_buffer.stop();
	fall.has_jumped = true;
	if _actor.display:
		TextSpawner.new(_actor.settings).spawn(get_tree(), _actor.global_position + Vector2(0, 30), quotes.pick_random());
	_actor.display = true;

func process_physics(delta: float) -> State:
	if _actor.is_on_floor():
		return fall;
	
	if Input.is_action_just_released("jump"):
		_actor.velocity.y *= 0.5;
		return fall;
	
	_actor.velocity.y += _actor.GRAVITY * delta;
	if _actor.velocity.y > 0:
		return fall;
	
	return null;
