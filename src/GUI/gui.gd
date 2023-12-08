extends CanvasLayer

@onready var score_label : Label = $MarginContainer/HBoxContainer/Score/score;
@onready var time_label  : Label = $MarginContainer/HBoxContainer/Time/time;

func _ready() -> void:
	TimeManager.toggle_timer();
	score_label.text = "Score\n%03d" % [GlobalInfo.score];
	GlobalInfo.score_increased.connect(update_score);

func _process(delta: float) -> void:
	time_label.text = "Time:\n" + TimeManager.get_timer_string(true, true, true, true);

func update_score() -> void:
	score_label.text = "Score\n%03d" % [GlobalInfo.score];
