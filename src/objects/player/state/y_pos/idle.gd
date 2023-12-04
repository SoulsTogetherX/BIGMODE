extends State

@export var fall : State;
@export var jump : State;

var quotes : QuotesInfo;

func get_id():
	return "idle";

func state_ready() -> void:
	quotes = QuotesInfo.new();
	quotes.quotes = [
		["Land", 5],
		["Puff", 2],
		["Hit", 2],
		["Grounded", 1.5],
		["Gravity sucks", 0.4],
		["Go! Go! Go!", 2],
		["Lund", 0.8],
		["Try flying noob", 0.01]
		];

func enter() -> void:
	TextSpawner.new(_actor.settings).spawn(get_tree(), _actor.global_position - Vector2(0, 30), quotes.pick_random());

func process_physics(_delta: float) -> State:
	if !_actor.is_on_floor():
		return fall;
	if Input.is_action_just_pressed("jump"):
		return jump;
	return null;
