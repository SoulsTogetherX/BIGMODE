extends Node2D

@onready var animate: AnimationPlayer = $animate;

signal play;
signal settings;
signal credits;

func _on_play_pressed() -> void:
	play.emit();

func _on_settings_pressed() -> void:
	settings.emit();

func _on_credits_pressed() -> void:
	credits.emit();
