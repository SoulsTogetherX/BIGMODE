class_name ParticleClear extends CPUParticles2D

func fade_this() -> void:
	reparent(get_tree().get_root());
	emitting = false;
	
	await get_tree().create_timer(lifetime / speed_scale).timeout;
	queue_free();
