class_name Player extends CharacterBody2D

const SPEED         : float =  500;
const JUMP_VELOCITY : int   = -400;
const JUMP_CUTOFF   : float = -50.;
const GRAVITY       : int   =  980;

var display : bool = false;

@export var settings : LabelSettings;

@onready var coyote_timer   : Timer            = $coyote_timer;
@onready var jump_buffer    : Timer            = $jump_buffer;
@onready var body           : Sprite2D         = $body;
@onready var body_collide   : CollisionShape2D = $bodyCollide;
@onready var state_overhead : StateOverhead    = $StateOverhead;

func get_movement() -> float:
	return Input.get_axis("left", "right");

func _physics_process(delta: float) -> void:
	move_and_slide();

func turn(left : bool = false) -> void:
	body.flip_h = left;
	body_collide.position.x = 4 * (-1 if left else 1);

func force_jump() -> void:
	state_overhead.change_state("jump", "y_pos");

func is_falling() -> bool:
	return state_overhead.is_in_state("y_pos", "fall");

func kill() -> void:
	queue_free();
