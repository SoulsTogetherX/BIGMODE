extends State

func get_id():
	return "victory";

func enter() -> void:
	$"../../../victory_sound".play();
	await get_tree().create_timer(4.07).timeout;
	
	prints(owner, owner.owner);
	owner.owner.switch_to_end();

func process_frame(_delta : float) -> State:
	return null;
