extends Node2D

@onready var animate: AnimationPlayer = $animate;
@onready var icon: Sprite2D = $Icon;

signal play;
signal settings;
signal credits;

var tween : Tween;

func _ready() -> void:
	if !GlobalInfo.menu_fancy:
		icon.scale.x = 0;
		
		tween = create_tween();
		tween.set_trans(Tween.TRANS_ELASTIC);
		tween.tween_property(icon, "scale:x", 3.0, 0.5).set_delay(0.5);
		GlobalInfo.menu_fancy = true;

func _on_play_pressed() -> void:
	GlobalInfo.menu_fancy = false;
	if tween:
		tween.kill();
	play.emit();

func _on_settings_pressed() -> void:
	if tween:
		tween.kill();
	settings.emit();

func _on_credits_pressed() -> void:
	if tween:
		tween.kill();
	credits.emit();
