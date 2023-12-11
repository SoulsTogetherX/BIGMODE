extends Node2D

signal start;

func _on_back_pressed() -> void:
	start.emit();
