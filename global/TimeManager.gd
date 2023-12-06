extends Node

signal time_scale_changed(newTime : float);

## Allows instant [member Engine.time_scale] changes.
func instant_time_scale(scale : float = 0.0, duration : float = 0.1, audio : bool = false) -> void:
	Engine.time_scale = scale;
	if audio:
		adjust_sounds(scale);
	
	time_scale_changed.emit(scale);
	await get_tree().create_timer(duration, true, false, true).timeout;
	
	Engine.time_scale = 1.0;
	if audio:
		adjust_sounds(1.0);
	
	time_scale_changed.emit(1.0);

## Allows gradual [member Engine.time_scale] transitions.[br][br]
##
## [b]NOTE[/b]: not implemented yet.
func graduale_time_scale(
			scale : float = 0.0,
			spd_in : float = 0.1,
			wait : float = 0.0,
			spd_out : float = 0.1
			) -> void:
	
	pass;

## Sets the global speed for audio.[br][br]
## 
## A wrapper for [member AudioServer.playback_speed_scale].
func adjust_sounds(scale : float) -> void:
	AudioServer.playback_speed_scale = scale;
