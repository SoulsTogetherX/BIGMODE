class_name QuotesInfo extends Resource

@export var quotes : Array[Array]:
	set(val):
		var sum : float = 0;
		for pair : Array in val:
			sum += pair[1];
		for idx : int in val.size():
			val[idx][1] /= sum;
		quotes = val;

func pick_random() -> String:
	var rand = randf();
	for quote in quotes:
		if rand <= quote[1]:
			return quote[0];
		rand -= quote[1];
	return "";
