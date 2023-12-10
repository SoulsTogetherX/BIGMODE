## @experimental
class_name AnimateState extends State

var _prebaked_intervals                : Array[float] = [];

##
##
## [b]NOTE[/b]: Currently not functioning.
@export var _prebake_intervals         : bool = true;
##
##
## [b]NOTE[/b]: Currently not functioning.
@export var _prebake_interval_percents : bool = true;

func get_animation() -> String:
	return "";

func get_intervals() -> Array[float]:
	return [];

func get_interval_percentage() -> Array[float]:
	return [];

func on_interval(interval : float) -> State:
	return null;

func on_end_animation() -> State:
	return null;
