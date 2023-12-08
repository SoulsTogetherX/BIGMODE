extends Path2D

static var _orb_scene : PackedScene = preload("res://src/objects/collectable/orb/orb.tscn");

@export var inveral : int = 100;

func _ready() -> void:
	var idx : int = -1;
	for point : Vector2 in curve.get_baked_points():
		idx += 1;
		if idx % inveral != 0:
			continue;
		
		var orb = _orb_scene.instantiate();
		add_child(orb);
		orb.position = point;
		
