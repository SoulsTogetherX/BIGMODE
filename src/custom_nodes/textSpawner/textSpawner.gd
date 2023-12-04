class_name TextSpawner extends RefCounted

var _settings : LabelSettings;

func _init(settings : LabelSettings) -> void:
	_settings = settings;

func spawn(tree : SceneTree, global_pos : Vector2, text : String, color : Color = Color.WHITE, w : float = 10, h_1 : float = -10, h_2 : float = -5) -> TextSpawner:
	var label : Label = Label.new();
	label.label_settings = _settings;
	label.text = text;
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER;
	global_pos -= _settings.font.get_string_size(text, HORIZONTAL_ALIGNMENT_CENTER, -1, _settings.font_size) * 0.5;
	label.global_position = global_pos;
	tree.current_scene.add_child(label)
	
	var tw = tree.create_tween().set_parallel();
	var x_reach : float = (randf() - 0.5) * w;
	tw.tween_property(label, "global_position", Vector2(x_reach * 0.5, h_1) + global_pos, 0.3);
	tw.tween_property(label, "global_position", Vector2(x_reach, h_2) + global_pos, 0.3).set_delay(0.3);
	tw.tween_property(label, "modulate:a", 0, 0.4).set_delay(0.2);
	tw.tween_callback(label.queue_free).set_delay(0.6);
	
	return self;
