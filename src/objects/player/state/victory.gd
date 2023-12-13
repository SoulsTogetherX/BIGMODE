extends State

func get_id():
	return "victory";

func enter() -> void:
	$"../../../victory_sound".play();
	await $"../../../victory_sound".finished;
	owner.owner.switch_to_end();
