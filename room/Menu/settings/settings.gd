extends Node2D

signal start;

@onready var master_volume: HSlider = $"Master Volume"
@onready var music: HSlider = $Music
@onready var sound: HSlider = $Sound

func _ready() -> void:
	master_volume.value = db_to_linear(AudioServer.get_bus_volume_db(0));
	music.value = db_to_linear(AudioServer.get_bus_volume_db(1));
	sound.value = db_to_linear(AudioServer.get_bus_volume_db(2));
	
	$"Challenges/1 HP".button_pressed = (GlobalInfo.player_max_health == 1);
	$"Challenges/Speed Mode".button_pressed = (Engine.time_scale == 1.5);
	$"Challenges/Enemy Hp".button_pressed = (GlobalInfo.enemy_hp_inc);

func _on_back_pressed() -> void:
	start.emit();

func _on_hp_toggled(toggled_on: bool) -> void:
	if toggled_on:
		GlobalInfo.player_max_health = 1;
		GlobalInfo.player_health = 1;
	else:
		GlobalInfo.player_max_health = 5;
		GlobalInfo.player_health = 5;

func _on_speed_toggled(toggled_on: bool) -> void:
	Engine.time_scale = 1.5 if toggled_on else 1.0;
	TimeManager.ignore_time_scale = toggled_on;
	TimeManager.default_time = Engine.time_scale;
	

func _on_double_hp_toggled(toggled_on: bool) -> void:
	GlobalInfo.enemy_hp_inc = toggled_on;

func _on_master_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value));

func _on_music_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, linear_to_db(value));

func _on_sound_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, linear_to_db(value));
