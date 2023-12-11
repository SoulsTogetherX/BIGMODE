extends CanvasLayer

@onready var score_label : Label = $Score/Value;
@onready var time_label  : Label = $Time/Value;
@onready var health_back : TextureRect = $HealthBack;
@onready var health      : TextureRect = $Health;

const HEARTH_WIDTH : int = 32;

func _ready() -> void:
	TimeManager.toggle_timer();
	
	update_score();
	update_health_max(-1);
	update_health(-1);
	
	GlobalInfo.score_increased.connect(update_score);
	GlobalInfo.updated_max_health.connect(update_health_max);
	GlobalInfo.updated_health.connect(update_health);

func _process(delta: float) -> void:
	time_label.text = TimeManager.get_timer_string(false, true, true, true, true);

func update_score() -> void:
	score_label.text = "%06d" % [GlobalInfo.score];

func update_health_max(old : int) -> void:
	if GlobalInfo.player_health <= 0:
		health_back.visible = false;
		return;
	else:
		health_back.visible = true;
	health_back.size.x = GlobalInfo.player_max_health * HEARTH_WIDTH;

static var particle : PackedScene = preload("res://asset/particles/heart_particle.tscn");
func update_health(old : int) -> void:
	if GlobalInfo.player_health <= 0:
		health.visible = false;
		return;
	else:
		health.visible = true;
	
	if GlobalInfo.player_health < old:
		for i in range(old, GlobalInfo.player_health, -1):
			_create_heart_particle(i);
	
	health.size.x = GlobalInfo.player_health * HEARTH_WIDTH;

func _create_heart_particle(pos_x : int) -> void:
	var part : CPUParticles2D = particle.instantiate();
	add_child(part);
	#350
	part.position = Vector2(8 + (pos_x * HEARTH_WIDTH * 1.5), 92);
	part.emitting = true;	
	
	await get_tree().create_timer(part.lifetime).timeout;
	
	part.queue_free();
