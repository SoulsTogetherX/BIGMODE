class_name Jump_Point extends Marker2D

var spikes : Array[Node2D] = []

var activated : bool = false;

func activate_spikes(position_x : float) -> void:
	for spike in spikes:
		spike.start(abs(spike.global_position.x - position_x) * 0.003);
	
	activated = true;

func retract_spikes() -> void:
	for spike in spikes:
		spike.end();
	
	activated = false;
