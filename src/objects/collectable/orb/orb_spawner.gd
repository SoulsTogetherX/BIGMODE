extends Path2D

static var _orb_scene : PackedScene = preload("res://src/objects/collectable/orb/orb.tscn");

@export var inveral : int = 100;
@export var flip : bool = false;

func _ready() -> void:
	var idx : int = -1;
	for point : Vector2 in curve.get_baked_points():
		idx += 1;
		if idx % inveral != 0:
			continue;
		
		var orb = _orb_scene.instantiate();
		orb.get_node("orb").flip_h = flip;
		orb.position = point;
		orb.global_scale = Vector2(1.0, 1.0);
		add_child(orb);
	
	#var count : int = curve.get_baked_points().size();
	#for offset in count:
		#if offset % inveral != 0:
			#continue;
		#
		#var trans : Transform2D = curve.sample_baked_with_rotation(offset);
		#
		#var orb = _orb_scene.instantiate();
		#orb.get_node("orb").flip_h = flip;
		#add_child(orb);
		#orb.position = trans.get_origin();
		#orb.rotation = trans.get_rotation() - PI/2;
